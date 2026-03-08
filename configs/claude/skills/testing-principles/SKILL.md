---
name: testing-principles
description: >
  Test design principles: what to test, what to skip, how to avoid fragile tests.
  Trigger: When designing tests, writing test files, or deciding test coverage strategy.
  Activated automatically when working on *_test.py, test_*.py, *.test.ts, *.spec.ts, or test files.
---

# Test Design Principles

## The #1 Rule: Test Behavior, Not Implementation

Tests must verify **what** a component does — not **how** it does it internally. A test coupled to implementation breaks on every refactor, even when behavior is unchanged.

**Ask before writing each test:** "If I refactor the internals but keep the same behavior, will this test still pass?" If no — rewrite it.

```
BAD:  service._validator.validate.assert_called_once_with("alice")
GOOD: assert repo.get("alice").name == "alice"
```

## What to Test

| Always test | Why |
|-------------|-----|
| Public API contracts (inputs → outputs) | Callers depend on these |
| State transitions | Core business logic |
| Error responses at system boundaries | User-facing behavior |
| Parsing and transformation results | Easy to break, easy to verify |
| Callback/hook execution | Side effects users depend on |
| Edge cases in business rules | Where real bugs hide |

## What NOT to Test

| Never test | Why |
|------------|-----|
| Private/internal methods | Locks you into implementation |
| Constructor assignment, getters without logic | Zero bug potential |
| Framework behavior (routing, ORM basics) | That's the framework's job |
| Third-party library correctness | That's their job |
| Log messages or debug output | Couples tests to observability |
| Every mock was called in exact order | Unless order IS the behavior |

## What to Test Sparingly

- Exact shape of large responses — assert only the fields this test cares about
- Thread timing — only in integration tests, with generous timeouts
- Call counts on mocks — only when delegation IS the behavior being tested

## AAA Structure: Arrange, Act, Assert

Every test has exactly three sections:

```
# ARRANGE — set up only what THIS test needs
# ACT — perform exactly ONE action
# ASSERT — verify the outcome, not the journey
```

Rules:
- **One action per test.** Two actions = two tests.
- **Assert on results, not on journey.** Don't verify which internal methods were called.
- **Minimal arrange.** Only set up what this specific test needs.

## Test Naming as Specification

Test names should read as behavior descriptions:

```
test_[component]_should_[expected_behavior]
test_[action]_[scenario]_[expected_outcome]
test_[action]_when_[condition]
```

Good: `test_executor_should_skip_cancelled_jobs`
Bad: `test_executor_3`, `test_it_works`

## Parametrize for Systematic Coverage

When the same logic needs testing with different inputs, use parametrize with named IDs instead of copy-pasting test bodies:

- Always provide `ids` — when a case fails, you must know which one instantly
- Group success and error cases in the same parametrize block when they test the same function
- Pattern for error cases: `expected_result=None, expected_error="message"`

## Mocking Strategy: Mock at Boundaries Only

**Mock external boundaries:**
- HTTP requests, subprocess calls, filesystem, time/clock, environment variables

**Keep internal objects real:**
- Your own services, data models, parsers, business logic

**Never mock what you're testing.** If you're testing ServiceA and it uses ServiceB, keep ServiceB real (with test config). Only mock ServiceB if it hits an external system.

When testing a delegation/proxy (service wraps a backend), mocks ARE appropriate — because the delegation itself is the behavior.

## Anti-Patterns to Avoid

### The Mockery
Mocking everything, then asserting every mock was called. You're testing the choreography of your mocks, not real behavior. If you have >3 mocks in a test, step back and reconsider.

### The Fragile Assertion
Asserting an entire 20-field response when you only care about `state`. Adding any field breaks the test. Assert only what this test verifies. Use `ANY` for non-deterministic fields (ids, timestamps) in contract tests.

### The Coverage Trap
Chasing 100% coverage by testing trivial code. Coverage shows which lines executed, not whether behavior was verified. A test with no assertions gives coverage but zero protection.

### The Implementation Mirror
Test structure mirrors the source code 1:1 — every private method has a test. This makes refactoring impossible because every internal change requires test changes. Test the public surface.

## Test Infrastructure: Base Classes for Component Families

When 3+ test files need identical setup (e.g., all CLI commands, all API controllers), create a shared base TestCase:

- Encapsulate setup/teardown (temp files, service creation, mock wiring)
- Provide hooks via Template Method for per-test customization
- Add helper methods for common operations (`write_config`, `replace_in_environ`)

## Integration vs Unit Test Choice

| Choose unit test when | Choose integration test when |
|----------------------|------------------------------|
| Testing pure logic/transformation | Testing component interactions |
| Fast feedback needed | Verifying full request/response contracts |
| External deps are easily mocked | Mock setup would be more complex than real setup |
| Testing a single class/function | Testing the wiring between layers |

## Language-Specific References

For concrete patterns, libraries, and idioms:

- See `python.md` for Python testing (pytest, unittest, testfixtures, responses, MockPopen)
- See `typescript.md` for TypeScript testing (vitest, jest, testing-library, msw)
