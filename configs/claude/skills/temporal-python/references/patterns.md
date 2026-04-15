# Temporal Python SDK: Patterns

## Signals

Send data or commands to a running workflow from external sources. Fire-and-forget, no response.

```python
@workflow.defn
class OrderWorkflow:
    def __init__(self):
        self._approved = False

    @workflow.signal
    async def approve(self) -> None:
        self._approved = True

    @workflow.run
    async def run(self) -> str:
        await workflow.wait_condition(lambda: self._approved)
        return "approved"
```

## Queries

Read workflow state without affecting execution. Must NOT modify state.

```python
@workflow.query
def get_status(self) -> str:
    return self._status

@workflow.query
def get_progress(self) -> int:
    return self._progress
```

## Updates

Synchronous request-response that CAN modify state:

```python
@workflow.update
def set_and_get_greeting(self, greeting: str) -> str:
    old = self._current_greeting
    self._current_greeting = greeting
    return old
```

## Child Workflows

Break complex workflows into smaller units with independent failure domains:

```python
result = await workflow.execute_child_workflow(
    ProcessOrderWorkflow.run,
    order,
    id=f"order-{order.id}",
    parent_close_policy=workflow.ParentClosePolicy.ABANDON,
)
```

Use child workflows when: failure domain isolation, different retry policies, reusability, independent scaling, or history size management is needed. Use activities for short-lived operations.

## Parallel Execution

```python
tasks = [
    workflow.execute_activity(process_item, item,
        start_to_close_timeout=timedelta(minutes=5))
    for item in items
]
results = await asyncio.gather(*tasks)
```

For deterministic ordering, prefer:
```python
done, pending = await workflow.wait(futures, return_when=workflow.WaitConditionResult.FIRST_COMPLETED)
for future in workflow.as_completed(futures):
    result = await future
```

## Saga Pattern (Compensations)

Distributed transactions with compensating actions for rollback:

```python
@workflow.run
async def run(self, order: Order) -> str:
    compensations = []
    try:
        await workflow.execute_activity(reserve_inventory, order, ...)
        compensations.append(lambda: workflow.execute_activity(release_inventory, order, ...))

        await workflow.execute_activity(charge_payment, order, ...)
        compensations.append(lambda: workflow.execute_activity(refund_payment, order, ...))

        return "Order completed"
    except Exception as e:
        for compensate in reversed(compensations):
            try:
                await compensate()
            except Exception as comp_err:
                workflow.logger.error(f"Compensation failed: {comp_err}")
        raise
```

## Cancellation Handling

```python
@workflow.run
async def run(self) -> str:
    try:
        await workflow.execute_activity(long_running, ...)
        return "completed"
    except asyncio.CancelledError:
        workflow.logger.info("Cancelled, running cleanup")
        await workflow.execute_activity(cleanup, ...)
        raise
```

## Continue-as-New

Prevent unbounded event history (recommended around 10,000 events):

```python
@workflow.run
async def run(self, state: State) -> str:
    while True:
        state = await process_batch(state)
        if state.is_complete:
            return "done"
        if workflow.info().get_current_history_length() > 10000:
            workflow.continue_as_new(args=[state])
```

## Wait Condition with Timeout

```python
try:
    await workflow.wait_condition(lambda: self._approved, timeout=timedelta(hours=24))
    return "approved"
except asyncio.TimeoutError:
    return "auto-rejected"
```

## Wait for All Handlers

Ensure signal/update handlers complete before workflow exits:
```python
await workflow.wait_condition(workflow.all_handlers_finished)
return "done"
```

## Batching with Activity IDs

Split large workloads into per-batch activities for visibility and granular retry:

```python
def _chunk(items: list, size: int) -> list[list]:
    return [items[i : i + size] for i in range(0, len(items), size)]

batches = _chunk(articles, batch_size)
for i, batch in enumerate(batches):
    result = await workflow.execute_activity(
        process_batch, BatchInput(items=batch),
        activity_id=f"process_batch_{i+1}_of_{len(batches)}",
        start_to_close_timeout=timedelta(minutes=10),
        retry_policy=LLM_RETRY,
    )
```

## External Workflow Interaction

Signal or cancel workflows that are not children:
```python
handle = workflow.get_external_workflow_handle(target_workflow_id)
await handle.signal(TargetWorkflow.data_ready, payload)
await handle.cancel()
```

## Pydantic Models

```python
from temporalio.contrib.pydantic import pydantic_data_converter

client = await Client.connect("localhost:7233", data_converter=pydantic_data_converter)
```
