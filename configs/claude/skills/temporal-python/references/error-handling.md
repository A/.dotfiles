# Temporal Python SDK: Error Handling

## ApplicationError

```python
from temporalio.exceptions import ApplicationError

@activity.defn
async def validate_order(order: Order) -> None:
    if not order.is_valid():
        raise ApplicationError("Invalid order", type="ValidationError")
```

## Non-Retryable Errors

```python
raise ApplicationError(
    "Permanent failure - invalid credit card",
    type="PaymentError",
    non_retryable=True,  # Will not retry
)
```

## Handling Activity Errors in Workflows

```python
from temporalio.exceptions import ActivityError

@workflow.run
async def run(self) -> str:
    try:
        return await workflow.execute_activity(risky_activity, ...)
    except ActivityError as e:
        workflow.logger.error(f"Activity failed: {e}")
        raise ApplicationError("Workflow failed due to activity error")
```

## Retry Policy

```python
from temporalio.common import RetryPolicy

result = await workflow.execute_activity(
    my_activity,
    schedule_to_close_timeout=timedelta(minutes=10),
    retry_policy=RetryPolicy(
        initial_interval=timedelta(seconds=1),
        backoff_coefficient=2.0,
        maximum_interval=timedelta(minutes=1),
        maximum_attempts=5,
        non_retryable_error_types=["ValidationError", "PaymentError"],
    ),
)
```

## Timeout Configuration

```python
await workflow.execute_activity(
    my_activity,
    start_to_close_timeout=timedelta(minutes=5),       # Single attempt timeout
    schedule_to_close_timeout=timedelta(minutes=30),   # Total including retries
    heartbeat_timeout=timedelta(seconds=30),           # Between heartbeats
)
```

## Soft Failure Pattern

For activities where partial failure is acceptable (e.g., fetching one source out of many):

```python
@activity.defn
async def fetch_source(input: FetchInput) -> FetchOutput:
    try:
        await asyncio.to_thread(do_fetch, input.source_id)
        return FetchOutput(success=True)
    except Exception as e:
        error(f"Failed: {e}", exc_info=True)
        return FetchOutput(success=False, error=str(e))  # Don't raise
```

The workflow decides what to do with failures:
```python
results = await asyncio.gather(*fetch_tasks)
for r in results:
    if not r.success:
        workflow.logger.warning(f"Source {r.source_id} failed: {r.error}")
```

## Idempotency Patterns

Activities may be retried. Design them to be idempotent:

1. **Use unique IDs as idempotency keys** (workflow ID, activity ID, or business ID)
2. **Check before acting**: Query state before making changes
3. **Make operations repeatable**: Calling twice produces the same result

```python
@activity.defn
async def charge_payment(order_id: str, amount: float) -> str:
    result = await payment_api.charge(
        amount=amount,
        idempotency_key=f"order-{order_id}",
    )
    return result.transaction_id
```

## Workflow-Level Error Wrapping

Wrap the entire pipeline so failures are always captured:

```python
@workflow.run
async def run(self, input: Input) -> Output:
    resource_id = None
    try:
        resource_id = await self._create_resource(input)
        return await self._execute_pipeline(input, resource_id)
    except Exception as e:
        if resource_id:
            await workflow.execute_activity(
                set_error, SetErrorInput(id=resource_id, error=str(e)), ...
            )
        raise
```
