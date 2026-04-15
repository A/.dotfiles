# Plan Template

Use this structure for all plans. Sections marked [REQUIRED] must always be present.

---

```markdown
# Plan: {Feature Name} [REQUIRED]

## Context [REQUIRED]

{2-4 paragraphs explaining:
- Current state: what exists today, what's missing or broken
- Motivation: why this change is needed
- Scope: what this plan covers and explicitly what it does NOT cover}

## Decisions [REQUIRED]

{Bullet list of every non-obvious decision made during design. Each entry:
- **{Topic}**: {Decision} — {1-sentence justification}}

Example:
- **Vector DB**: pgvector (PostgreSQL extension, no new container)
- **Keyword schema**: Typed entities `[{name, type}]` — enables filtering by entity type later

---

## Milestone N: {Title} [REQUIRED per milestone]

{1-2 sentence goal statement for this milestone.}

### N.1 — {Task Title}

**{New/Modified} files:**
- `path/to/file.py` — {what changes}
- `path/to/new_file.py` — {purpose}

{Code sketch if the implementation is non-obvious:}
```python
class NewThing:
    def method(self):
        ...
```

**Definition of Done:**
- [ ] {Specific, verifiable criterion}
- [ ] {Another criterion}
- [ ] Tests pass: `{exact test command}`

### N.2 — {Next Task}
...

### Verify (Milestone N)
{Exact commands to verify the milestone is complete:}
- `docker compose exec api just test path/to/relevant_spec.py`
- `docker compose exec api uv run ruff check .`

---

## Implementation Order [REQUIRED]

{ASCII dependency graph showing milestone relationships:}
```
M1 (foundation) ──┐
                  ├── M3 (integration)
M2 (parallel) ───┘
                        ↓
                  M4 (frontend)
                        ↓
                  M5 (cleanup)
```

{Brief explanation of which milestones can run in parallel.}

## Key Files Reference [REQUIRED]

| File | Role |
|------|------|
| `path/to/file.py` | {Why it matters for this plan} |
| `path/to/other.py:123` | {Specific line/function reference} |

## Status [REQUIRED]

Group by milestone with total SP, then task breakdown:

### M1: {Milestone Title} — {total SP} SP | pending

| Task | Description | SP | Status |
|------|-------------|----|--------|
| 1.1 | {Task description with key details} | {1-5} | pending |
| 1.2 | {Task description with key details} | {1-5} | pending |

### M2: {Milestone Title} — {total SP} SP | pending

| Task | Description | SP | Status |
|------|-------------|----|--------|
| 2.1 | {Task description with key details} | {1-5} | pending |

**Total: {sum} SP**

Story point scale:
- **1** — Simple text/config change, no risk
- **2** — Simple task, predictable, no risk
- **3** — Medium task, minor risks but predictable
- **4** — Complex task, medium risk, may need small research
- **5** — Research task, needs clarification before proceeding

## Deploy Checklist

{If the plan introduces new env vars, external services, or config changes:}

| Env Var / Config | docker-compose | terraform | CI workflow |
|-----------------|----------------|-----------|-------------|
| `NEW_VAR_NAME` | present | present | present |

{Omit this section if no infra changes are needed.}

## Security Checklist

{If the plan touches endpoints, views, or querysets:}

- [ ] Every queryset scopes to `request.user` (or is explicitly documented as public)
- [ ] Authorization is verified holistically — not just per-viewset but across the full API surface in scope
- [ ] No endpoint exposes data from other users/tenants

{Omit this section if the plan doesn't touch API endpoints.}

## Code Sketch Review

Before finalizing the plan, verify all code sketches:

- [ ] Method bodies use `...` — agents should implement from interfaces, not copy literal code
- [ ] Type annotations in signatures are accurate (agents copy them verbatim)
- [ ] File names and test names follow project conventions in CLAUDE.md, not existing code patterns

## Final Verification [REQUIRED]

- [ ] {End-to-end acceptance criterion}
- [ ] `docker compose exec api just test` — all tests pass
- [ ] `docker compose exec api uv run ruff check .` — no lint errors
- [ ] {Any other project-specific checks}
```
