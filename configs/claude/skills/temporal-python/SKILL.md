---
name: temporal-python
description: >
  Temporal Python SDK (`temporalio`) patterns, determinism rules, error handling, and testing.
  Trigger: When writing Temporal workflows, activities, or workers in Python, or when the user
  mentions Temporal, durable workflows, or the Python SDK in the context of workflow orchestration.
  Activated when working on files importing `temporalio`, `@activity.defn`, `@workflow.defn`,
  in directories named `temporal_app/`, `workflows/`, `activities/`, or when user asks about
  Temporal concepts, determinism, replay, signals, or activity patterns.
license: Apache-2.0
metadata:
  author: zorya-development
  version: "1.0"
  sources:
    - MasonEgger/temporal-plugin-claude-code
    - mfateev/temporal-claude-skill
    - Temporal Python SDK docs
---

# Temporal Python SDK Best Practices

## Overview

The Temporal Python SDK (`temporalio`) provides async, type-safe durable workflows. Python 3.9+ required. Workflows run in a sandbox for determinism protection.

## File Organization

**Keep Workflow definitions separate from Activity definitions.** The sandbox reloads workflow files on every execution. Minimizing their contents improves worker performance.

```
temporal_app/
  steps/           # Step classes (preferred pattern)
  workflows/       # Workflow classes only
  activities/      # Standalone activity functions
  dataclasses.py   # Workflow-level I/O
  worker.py        # Worker setup, registers all
```

## Step Pattern (Preferred for Complex Pipelines)

Organize workflow logic into self-contained step classes. Each step owns its activities as methods and exposes a `run()` orchestration method.

```python
from temporalio import activity, workflow

class MyStep:
    @activity.defn(name="my_step__do_work")
    async def do_work(self, input: DoWorkInput) -> DoWorkOutput:
        # Activity logic (DB, API, LLM) with lazy imports
        from my_app.models import MyModel
        result = await asyncio.to_thread(MyModel.objects.get, id=input.id)
        return DoWorkOutput(...)

    async def run(self, input: StepInput) -> StepOutput:
        """Orchestration - runs in workflow context, NOT an activity."""
        result = await workflow.execute_activity_method(
            MyStep.do_work,
            DoWorkInput(...),
            start_to_close_timeout=timedelta(seconds=30),
            retry_policy=DEFAULT_RETRY,
        )
        return StepOutput(...)
```

Key rules:
- Activity methods use `@activity.defn(name="step_name__method")` to namespace names
- `run()` is NOT an activity - it calls `workflow.execute_activity_method(StepClass.method, ...)`
- Register instance in worker: `activities=[..., MyStep()]`
- Call from workflow: `await MyStep().run(input)`

## Activity Pattern

```python
import asyncio
from dataclasses import dataclass
from temporalio import activity

@dataclass
class MyInput:
    some_id: int

@dataclass
class MyOutput:
    result_count: int

@activity.defn
async def my_activity(input: MyInput) -> MyOutput:
    # Lazy imports for Django/heavy deps
    from my_app.models import SomeModel

    # asyncio.to_thread for all sync/ORM calls
    obj = await asyncio.to_thread(SomeModel.objects.get, id=input.some_id)
    return MyOutput(result_count=1)
```

### Sync vs Async Activities

**Default to sync activities** with `ThreadPoolExecutor` - they are safer and easier to debug. Async activities share the event loop with the Worker; any blocking call freezes everything.

```python
# Worker setup for sync activities
with ThreadPoolExecutor(max_workers=100) as executor:
    worker = Worker(
        client, task_queue="queue",
        activities=[my_sync_activity],
        activity_executor=executor,
    )
```

If using async activities, ensure ALL code paths use async-safe libraries (`aiohttp`, not `requests`). Use `asyncio.to_thread()` to offload blocking calls.

### Error Handling in Activities

For partial failures (one source out of many), return errors in the output - don't raise:
```python
except Exception as e:
    return FetchOutput(success=False, error=str(e))
```

For permanent failures, use `ApplicationError`:
```python
from temporalio.exceptions import ApplicationError
raise ApplicationError("Invalid input", type="ValidationError", non_retryable=True)
```

### Heartbeats

Long-running activities need `activity.heartbeat()` with progress data for resumability:
```python
@activity.defn
async def process_large_file(path: str) -> str:
    start = (activity.info().heartbeat_details or [0])[0]
    for i, line in enumerate(lines[start:], start):
        process(line)
        activity.heartbeat(i + 1)
```

## Workflow Pattern

```python
from temporalio import workflow
with workflow.unsafe.imports_passed_through():
    from my_activities import my_activity, MyInput

@workflow.defn
class MyWorkflow:
    @workflow.run
    async def run(self, input: WorkflowInput) -> WorkflowOutput:
        result = await workflow.execute_activity(
            my_activity,
            MyInput(id=input.id),
            start_to_close_timeout=timedelta(minutes=5),
            retry_policy=DEFAULT_RETRY,
        )
        return WorkflowOutput(...)
```

### Determinism Rules

Workflows re-execute from the beginning on recovery (history replay). Non-deterministic code causes `NondeterminismError`.

| Forbidden | Safe Alternative |
|-----------|------------------|
| `datetime.now()` | `workflow.now()` |
| `random.random()` | `workflow.random().random()` |
| `uuid.uuid4()` | `workflow.uuid4()` |
| `time.time()` | `workflow.now().timestamp()` |
| `print()` | `workflow.logger.info()` |
| `asyncio.wait()` | `workflow.wait()` |
| `asyncio.as_completed()` | `workflow.as_completed()` |

### Sandbox Pass-Through

Third-party libraries need explicit pass-through:
```python
with workflow.unsafe.imports_passed_through():
    import pydantic
    from my_activities import my_activity
```

### Parallel Execution

```python
tasks = [
    workflow.execute_activity(process_item, item,
        start_to_close_timeout=timedelta(minutes=5))
    for item in items
]
results = await asyncio.gather(*tasks)
```

### Retry Policies

```python
DEFAULT_RETRY = RetryPolicy(
    initial_interval=timedelta(seconds=1),
    maximum_interval=timedelta(minutes=1),
    backoff_coefficient=2.0,
    maximum_attempts=3,
)

LLM_RETRY = RetryPolicy(
    initial_interval=timedelta(seconds=2),
    maximum_interval=timedelta(minutes=2),
    backoff_coefficient=2.0,
    maximum_attempts=3,
    non_retryable_error_types=["ValidationError"],
)
```

### Continue-as-New

Prevent unbounded event history growth (recommended around 10,000 events):
```python
if workflow.info().get_current_history_length() > 10000:
    workflow.continue_as_new(args=[state])
```

### Versioning (Patching)

Safely deploy workflow code changes without breaking running workflows:
```python
if workflow.patched("new-greeting"):
    result = await workflow.execute_activity(new_activity, ...)
else:
    result = await workflow.execute_activity(old_activity, ...)
```

Three-step process: (1) Add `workflow.patched()` with both paths, (2) `workflow.deprecate_patch()` after old workflows complete, (3) Remove entirely.

## Dataclass Conventions

- One `*Input` and one `*Output` per activity
- **Plain types only**: `int`, `str`, `bool`, `float`, `list[int]`, `str | None`
- **Datetimes as ISO strings**: Pass `str`, parse with `datetime.fromisoformat()` inside activity
- No Django model instances, no `datetime` objects in dataclasses

## Testing

```python
from temporalio.testing import WorkflowEnvironment, ActivityEnvironment

# Workflow test with time-skipping
async def test_workflow():
    async with await WorkflowEnvironment.start_time_skipping() as env:
        async with Worker(env.client, task_queue="test", workflows=[MyWorkflow], activities=[my_activity]):
            result = await env.client.execute_workflow(MyWorkflow.run, "input", id="test-wf", task_queue="test")
            assert result == "expected"

# Isolated activity test
async def test_activity():
    env = ActivityEnvironment()
    result = await env.run(my_activity, MyInput(some_id=1))
    assert result.count == 1

# Replay compatibility test (after code changes)
from temporalio.worker import Replayer
async def test_replay():
    replayer = Replayer(workflows=[MyWorkflow])
    await replayer.replay_workflow(WorkflowHistory.from_json("wf-id", history_json))
```

## Common Pitfalls

1. **Blocking async activities** - Use sync activities or async-safe libraries only. `requests.get()` in an async activity freezes the entire worker
2. **Missing executor for sync activities** - Add `activity_executor=ThreadPoolExecutor()`
3. **Mixing workflows and activities in same file** - Causes unnecessary sandbox reloads
4. **Using `datetime.now()` in workflows** - Use `workflow.now()`
5. **LLM batch timeouts** - Use per-batch activities (10min each) not one monolithic activity. Set explicit `activity_id` for UI visibility
6. **Local model retry storms** - Disable retries for single-slot inference servers
7. **Forgetting heartbeats** - Long activities need `activity.heartbeat()` or Temporal assumes the worker died
8. **Using `print()` in workflows** - Use `workflow.logger` for replay-safe logging

## Reference Files

See `references/` for detailed guides on:
- `determinism.md` - Sandbox, history replay, safe alternatives
- `error-handling.md` - ApplicationError, retry policies, idempotency
- `patterns.md` - Signals, queries, child workflows, saga, cancellation
