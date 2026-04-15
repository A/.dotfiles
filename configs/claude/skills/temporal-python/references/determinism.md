# Temporal Python SDK: Determinism & History Replay

## How Replay Works

1. **Initial Execution**: Workflow runs, SDK records Commands (like "schedule activity") to Event History
2. **Recovery**: Worker restarts or picks up Workflow Task, re-executes code from the beginning
3. **Command Matching**: During replay, SDK compares Commands against Events in history. Matching events return stored results instead of re-executing
4. **Non-determinism Detection**: If code generates different Commands than history, SDK raises `NondeterminismError`

### Why datetime.now() Breaks Replay

```python
# BAD - Non-deterministic
if datetime.datetime.now().hour < 12:  # Different value on replay!
    await workflow.execute_activity(morning_activity, ...)

# GOOD - Deterministic
if workflow.now().hour < 12:  # Consistent during replay
    await workflow.execute_activity(morning_activity, ...)
```

## Safe Alternatives

| Forbidden | Safe Alternative |
|-----------|------------------|
| `datetime.now()` | `workflow.now()` |
| `datetime.utcnow()` | `workflow.now()` |
| `random.random()` | `workflow.random().random()` |
| `random.randint()` | `workflow.random().randint()` |
| `uuid.uuid4()` | `workflow.uuid4()` |
| `time.time()` | `workflow.now().timestamp()` |
| `asyncio.wait()` | `workflow.wait()` |
| `asyncio.as_completed()` | `workflow.as_completed()` |

## Sandbox Behavior

The Python SDK sandbox:
- Isolates global state via `exec` compilation
- Restricts non-deterministic library calls via proxy objects
- Passes through standard library with restrictions

### Pass-Through for Third-Party Libraries

```python
with workflow.unsafe.imports_passed_through():
    import pydantic
    from my_module import my_activity
```

### Disabling Sandbox

```python
# Per-workflow
@workflow.defn(sandboxed=False)
class UnsandboxedWorkflow:
    pass

# Globally (worker level)
from temporalio.worker import UnsandboxedWorkflowRunner
Worker(..., workflow_runner=UnsandboxedWorkflowRunner())
```

## Forbidden Operations in Workflows

- Direct I/O (network, filesystem)
- Threading operations
- `subprocess` calls
- Global mutable state modification
- `time.sleep()` (use `asyncio.sleep()` which the sandbox handles)
- `print()` (use `workflow.logger`)

## Commands and Events Mapping

| Workflow Code | Command Generated | Event Created |
|--------------|-------------------|---------------|
| `workflow.execute_activity()` | ScheduleActivityTask | ActivityTaskScheduled |
| `asyncio.sleep()` | StartTimer | TimerStarted |
| `workflow.execute_child_workflow()` | StartChildWorkflowExecution | ChildWorkflowExecutionStarted |
| `workflow.continue_as_new()` | ContinueAsNewWorkflowExecution | WorkflowExecutionContinuedAsNew |
| Return from `@workflow.run` | CompleteWorkflowExecution | WorkflowExecutionCompleted |

## Testing Replay Compatibility

```python
from temporalio.worker import Replayer
from temporalio.client import WorkflowHistory

async def test_replay_compatibility():
    replayer = Replayer(workflows=[MyWorkflow])
    with open("workflow_history.json") as f:
        history = WorkflowHistory.from_json("my-workflow-id", f.read())
    await replayer.replay_workflow(history)  # Raises NondeterminismError if incompatible
```

## Versioning with Patching

Safely deploy code changes without breaking running workflows:

```python
# Step 1: Add patch with both paths
if workflow.patched("new-greeting"):
    greeting = await workflow.execute_activity(new_greet, ...)
else:
    greeting = await workflow.execute_activity(old_greet, ...)

# Step 2: After all old workflows complete, deprecate
workflow.deprecate_patch("new-greeting")
greeting = await workflow.execute_activity(new_greet, ...)

# Step 3: Remove patch entirely
greeting = await workflow.execute_activity(new_greet, ...)
```
