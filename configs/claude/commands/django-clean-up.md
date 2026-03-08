---
model: sonnet
---

Run code cleanup checks on the Django project using ruff and basedpyright.

## Step 1: Ruff Linting

1. Check docker-compose.yml (or compose.yaml) to find the service name for the Django app container.

2. Run ruff checks:
```bash
docker compose exec <service_name> uv run ruff check . --select=F401,PLC0415,UP006,UP007 --output-format=concise
```

3. If there are issues, show them and ask if user wants to auto-fix.

4. If user agrees:
```bash
docker compose exec <service_name> uv run ruff check . --select=F401,PLC0415,UP006,UP007 --fix
```

Ruff rules:
- F401: Unused imports
- PLC0415: Import not at top of file
- UP006: Deprecated type hints (`list` instead of `List`)
- UP007: Deprecated Optional (`X | None` instead of `Optional[X]`)

## Step 2: Type Checking with basedpyright

1. Run type checker:
```bash
uvx basedpyright .
```

2. For each error, fix properly rather than suppressing:
   - **Missing type stubs**: Add stub packages to dev dependencies (e.g., `celery-types`, `django-stubs`) or create local stubs in `stubs/` directory
   - **Import conflicts**: Rename files that shadow package names, or use `import pkg as alias` pattern
   - **Django model field types**: Add explicit type hints using `TYPE_CHECKING` blocks for `id` and other auto-generated fields
   - **Unknown types from model fields**: Use `cast()` when Django field types are inferred as `Unknown | T`

3. Only suppress warnings when:
   - It's a known limitation in third-party stubs (search GitHub issues first)
   - The fix requires upstream changes to stub packages
   - Document the reason in pyproject.toml if suppressing

4. When encountering type errors:
   - Search the web for the specific error + package name
   - Check if there's a stub package available
   - Check GitHub issues for the stubs repo (e.g., typeddjango/djangorestframework-stubs)
   - Consider creating local stubs in `stubs/` directory with `stubPath` in pyproject.toml

## pyproject.toml Configuration

Ensure pyright is configured:
```toml
[tool.pyright]
stubPath = "stubs"
venvPath = "."
venv = ".venv"
```

## Goal

Achieve `0 errors, 0 warnings, 0 notes` from basedpyright.
