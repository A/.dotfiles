# TypeScript Testing Reference

## Framework: vitest (preferred) or jest

### vitest Conventions

```typescript
// File naming: *.test.ts or *.spec.ts (co-located next to source)
// Function naming: describe/it blocks with behavior descriptions

// vitest.config.ts
import { defineConfig } from 'vitest/config'
export default defineConfig({
  test: {
    globals: true,
    environment: 'node',  // or 'jsdom' for DOM tests
  },
})

// Run
// vitest              # Watch mode
// vitest run          # Single run
// vitest run --reporter=verbose
// vitest run src/utils/  # Specific directory
```

### Test Structure

```typescript
import { describe, it, expect, beforeEach, vi } from 'vitest'

describe('OrderService', () => {
  let service: OrderService

  beforeEach(() => {
    service = new OrderService(new InMemoryRepo()) // Real dep, not mock
  })

  it('should calculate total with discount', () => {
    const order = service.create([{ price: 100 }, { price: 50 }])
    const total = service.calculateTotal(order.id, { discount: 10 })
    expect(total).toBe(135)
  })

  it('should throw when order not found', () => {
    expect(() => service.calculateTotal('nonexistent')).toThrow('Order not found')
  })
})
```

### Parametrize with `it.each`

```typescript
it.each([
  { input: 'hello', expected: 'HELLO' },
  { input: '', expected: '' },
  { input: 'Hello World', expected: 'HELLO WORLD' },
])('should uppercase "$input" to "$expected"', ({ input, expected }) => {
  expect(toUpper(input)).toBe(expected)
})

// For testing API methods systematically
it.each<{
  method: string
  args: unknown[]
  endpoint: string
  httpMethod: string
  status: number
  response: unknown
  expected: unknown
}>([
  { method: 'getUser', args: [1], endpoint: '/users/1', httpMethod: 'GET', status: 200, response: { id: 1 }, expected: { id: 1 } },
  { method: 'getUser', args: [1], endpoint: '/users/1', httpMethod: 'GET', status: 404, response: { error: 'Not found' }, expected: null },
])('$method with status $status', async ({ method, args, endpoint, httpMethod, status, response, expected }) => {
  server.use(http[httpMethod.toLowerCase()](endpoint, () => HttpResponse.json(response, { status })))
  const result = await client[method](...args)
  expect(result).toEqual(expected)
})
```

## Mocking

### vitest mocks (vi)

```typescript
// Mock a module
vi.mock('./api-client', () => ({
  fetchUser: vi.fn().mockResolvedValue({ id: 1, name: 'Alice' }),
}))

// Spy on a method (keeps real implementation)
const spy = vi.spyOn(service, 'validate')
service.process(data)
expect(spy).toHaveBeenCalledWith(data) // Only when delegation IS the behavior

// Mock timers
vi.useFakeTimers()
vi.setSystemTime(new Date('2024-01-01'))
// ... test time-dependent code ...
vi.useRealTimers()

// Mock environment
vi.stubEnv('API_URL', 'http://test.local')
```

### MSW (Mock Service Worker) — HTTP Mocking

Preferred over mocking fetch/axios directly. Intercepts at the network level.

```typescript
import { setupServer } from 'msw/node'
import { http, HttpResponse } from 'msw'

const server = setupServer(
  http.get('/api/users/:id', ({ params }) => {
    return HttpResponse.json({ id: params.id, name: 'Alice' })
  }),
  http.post('/api/users', async ({ request }) => {
    const body = await request.json()
    return HttpResponse.json({ id: 1, ...body }, { status: 201 })
  }),
  http.delete('/api/users/:id', () => {
    return new HttpResponse(null, { status: 204 })
  }),
)

beforeAll(() => server.listen())
afterEach(() => server.resetHandlers())
afterAll(() => server.close())

// Override for specific test
it('should handle server error', async () => {
  server.use(
    http.get('/api/users/1', () => HttpResponse.json({ error: 'fail' }, { status: 500 }))
  )
  await expect(client.getUser(1)).rejects.toThrow()
})
```

## React Component Testing

### @testing-library/react

```typescript
import { render, screen, waitFor } from '@testing-library/react'
import userEvent from '@testing-library/user-event'

it('should submit form with entered data', async () => {
  const onSubmit = vi.fn()
  render(<LoginForm onSubmit={onSubmit} />)

  // Query by role/label — not by class or test-id
  await userEvent.type(screen.getByLabelText('Email'), 'alice@test.com')
  await userEvent.type(screen.getByLabelText('Password'), 'secret')
  await userEvent.click(screen.getByRole('button', { name: 'Log in' }))

  expect(onSubmit).toHaveBeenCalledWith({
    email: 'alice@test.com',
    password: 'secret',
  })
})

// Test loading and error states
it('should show error on failed fetch', async () => {
  server.use(http.get('/api/data', () => HttpResponse.json({}, { status: 500 })))
  render(<DataList />)

  await waitFor(() => {
    expect(screen.getByText('Failed to load')).toBeInTheDocument()
  })
})
```

**Key principle**: Query elements the way a user would find them — by label, role, text. Not by CSS class or data-testid (last resort only).

### Testing Hooks

```typescript
import { renderHook, waitFor } from '@testing-library/react'

it('should fetch and return data', async () => {
  const { result } = renderHook(() => useUsers())

  await waitFor(() => {
    expect(result.current.isLoading).toBe(false)
  })

  expect(result.current.data).toEqual([{ id: 1, name: 'Alice' }])
})
```

## Assertion Patterns

```typescript
// Exact equality
expect(result).toBe(42)                    // Primitives (===)
expect(result).toEqual({ id: 1 })          // Deep equality for objects

// Partial matching — assert only what matters
expect(result).toMatchObject({
  state: 'PENDING',
  command: 'echo 1',
})  // Ignores other fields — won't break when fields are added

// Use expect.any() for non-deterministic values
expect(result).toEqual({
  id: expect.any(Number),
  createdAt: expect.any(String),
  name: 'Echo',
})

// Arrays
expect(items).toHaveLength(3)
expect(items).toContainEqual({ id: 1, name: 'first' })

// Exceptions
expect(() => validate(bad)).toThrow('Invalid input')
await expect(asyncFn()).rejects.toThrow('Network error')

// Truthiness — use specific assertions, not just toBeTruthy
expect(result).toBeDefined()               // Not: toBeTruthy()
expect(result).toBeNull()                  // Not: toBeFalsy()
```

## Node.js / Backend Specifics

### Testing Express/Koa/Fastify

```typescript
import supertest from 'supertest'

const app = createApp(/* real services with test config */)
const request = supertest(app)

it('should create item', async () => {
  const res = await request
    .post('/api/items')
    .send({ name: 'test' })
    .expect(201)

  expect(res.body.data).toMatchObject({ name: 'test' })
})
```

### Testing with Real Database (integration)

```typescript
import { beforeEach } from 'vitest'

// Use test database, reset between tests
beforeEach(async () => {
  await db.migrate.latest()
  await db.seed.run()
})

afterEach(async () => {
  await db('users').truncate()
})
```
