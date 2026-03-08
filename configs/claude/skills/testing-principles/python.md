# Python Testing Reference

## Framework: pytest (preferred) + unittest.TestCase

### pytest Conventions

```python
# File naming: *_test.py (co-located) or test_*.py (separate dir)
# Function naming: test_* (no class needed for simple tests)
# Class naming: Test* (for grouping related tests)

# Run
pytest                          # All tests
pytest -x                       # Stop on first failure
pytest --lf                     # Rerun last failed
pytest -k "test_cancel"         # Match by name
pytest path/to/test_file.py     # Specific file
pytest --timeout=20             # Global timeout
```

### Parametrize

```python
@pytest.mark.parametrize(
    "input_yaml,expected",
    [
        ("port: 1234", {"port": 1234}),
        ("", {"port": 9876}),              # default
    ],
    ids=["custom_port", "default_port"],    # ALWAYS provide ids
)
def test_config_parsing(input_yaml, expected):
    result = parser.parse(yaml.safe_load(input_yaml))
    assert result == expected
```

For testing success + error in one parametrize:

```python
@pytest.mark.parametrize(
    "method,args,status,expected_response,expected_error",
    [
        ("get_item", [1], 200, {"id": 1}, None),
        ("get_item", [1], 404, None, "Not found"),
    ],
    ids=["get_item_success", "get_item_not_found"],
)
def test_api_client(method, args, status, expected_response, expected_error):
    # ... mock HTTP ...
    try:
        result = getattr(client, method)(*args)
        assert result == expected_response
    except ApiError as ex:
        assert ex.message == expected_error
```

### Fixtures

```python
# conftest.py — shared across test files in the directory
@pytest.fixture
def temp_config(tmp_path):
    config_file = tmp_path / "config.yml"
    config_file.write_text("port: 9876")
    return config_file

@pytest.fixture
def service(temp_config):
    return MyService(config_path=str(temp_config))

# Use autouse sparingly — only for truly universal setup
@pytest.fixture(autouse=True)
def reset_id_counter():
    IdField.reset()
    yield
```

### unittest.TestCase Base Classes

For component families that need heavy setup/teardown:

```python
class ControllerTestCase(TestCase):
    maxDiff = None          # Full diff on failures
    config_data = ""        # Override in subclass

    def before_create_services(self): ...  # Template method hook

    def setUp(self):
        self.temp_dir = TempDirectory()
        self.config_file = self.temp_dir / "config.yml"
        self.config_file.write_text(self.config_data)
        self.before_create_services()
        self.service = create_service(config_path=...)
        self.test_client = create_app(self.service).test_client()

    def tearDown(self):
        self.service.terminate()
        self.temp_dir.cleanup()
```

## Mocking Libraries

### testfixtures — System Boundary Mocking

**MockPopen** (subprocess):
```python
from testfixtures import Replacer
from testfixtures.popen import MockPopen

self.Popen = MockPopen()
self.r = Replacer()
self.r.replace("subprocess.Popen", self.Popen)
self.addCleanup(self.r.restore)

# Pre-configure commands
self.Popen.set_command("echo hello", stdout=b"hello", stderr=b"", returncode=0)

# Verify calls
self.assertEqual(self.Popen.all_calls[0],
    call.Popen("echo hello", shell=True, env=ANY, cwd="/home/"))
```

**Replacer** (environment + modules):
```python
r = Replacer()
r.in_environ("HOME", "/tmp/test")
r.replace("mymodule.datetime", mock_dt)
r.restore()  # Always in tearDown or addCleanup
```

**TempDirectory** (filesystem):
```python
self.temp_dir = TempDirectory()
config = self.temp_dir / "config.yml"
config.write_text("key: value")
# self.temp_dir.cleanup() in tearDown
```

**mock_datetime** (time):
```python
from testfixtures import mock_datetime
d = mock_datetime(2024, 1, 1, 8, 0, 0, delta=0)
r.replace("mymodule.datetime", d)
d.set(2024, 1, 1, 8, 30, 0)  # Advance time
```

### responses — HTTP Mocking (for `requests` library)

```python
import responses
from responses import matchers

@responses.activate
def test_create_item():
    responses.post(
        "http://example.com/api/items/",
        json={"data": {"id": 1}},
        status=200,
        match=[matchers.json_params_matcher({"name": "test"})],  # Verify request body
    )
    result = client.create({"name": "test"})
    assert result == {"id": 1}
```

### unittest.mock

```python
from unittest.mock import MagicMock, patch, ANY

# Patch at the import location, not the definition
with patch("mymodule.subprocess.Popen") as mock_popen:
    ...

# MagicMock for dependency injection
printer = MagicMock()
output = Output(printer=printer)
output.print("hello")
printer.print.assert_called_once_with("hello")

# ANY for non-deterministic values in assertions
self.assertEqual(data, {"id": ANY, "created_at": ANY, "state": "PENDING"})
```

## Flask Testing

```python
# Use Flask's test_client with real services (integration style)
app = create_app(service=real_service)
client = app.test_client()

res = client.post("/api/items/", json={"name": "test"})
assert res.status_code == 200
data = res.get_json()
assert data["data"]["name"] == "test"
```

## Django Testing

See the `django-pytest-patterns` skill for Django-specific patterns (Factory Boy, `@pytest.mark.django_db`, view testing, etc.)

## Assertion Patterns

```python
# Prefer specific assertions
assert result.state == "FINISHED"               # Not: assert result.state
assert len(items) == 3                           # Not: assert items
assert "error" in response.json()                # Not: assert response.json()

# For TestCase methods
self.assertEqual(a, b)                           # Gives diff on failure
self.assertIsNone(result)
self.assertIn("key", data)
self.assertRaises(ValueError, func, bad_arg)

# For full-response contract tests, use ANY for volatile fields
self.assertEqual(data, {
    "id": ANY,
    "created_at": ANY,
    "name": "Echo",
    "state": "PENDING",
})
```
