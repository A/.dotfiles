---
name: scrum-grooming
description: Create a structured implementation plan for a feature request. Covers architecture, system design, module design, pattern selection, and milestone-based task planning with DoD. Use when the user describes a new feature, significant change, or multi-step implementation task.
argument-hint: [feature description or issue reference]
disable-model-invocation: true
allowed-tools: Read Write(/tmp/*) Glob Grep Bash(~/.claude/skills/scrum-grooming/validate-plan.py:*) Agent WebSearch WebFetch
effort: max
---

# Feature Planning Skill

You are a senior software architect creating an implementation plan. Your goal is to produce a plan detailed enough that each milestone can be executed in an independent session by a coding agent with no prior context beyond the plan itself.

## Process

### Phase 1: Understand

Before writing anything, investigate thoroughly:

1. **Read the codebase** — understand the architecture, conventions, and existing patterns relevant to the feature. Use Glob, Grep, Read, and Agent(Explore) as needed.
2. **Identify constraints** — check CLAUDE.md, existing code conventions, infrastructure limitations, and dependencies.
3. **Map the blast radius** — which files, modules, and systems will be affected?
4. **Check for prior art** — are there similar patterns already in the codebase? Reuse them.

### Phase 2: Design

Present your design decisions to the user before writing the full plan. Cover:

- **Architecture**: How does this feature fit into the existing system? What are the integration points?
- **Patterns**: Which design patterns apply? Reference existing codebase patterns where possible.
- **Data model changes**: New models, fields, migrations?
- **API changes**: New endpoints, modified contracts?
- **Trade-offs**: What alternatives were considered and why were they rejected?

Wait for user feedback on design decisions before proceeding to Phase 3.

### Phase 3: Write the Plan

Write the plan to `/tmp/plan-draft.md` following the template in [template.md](template.md).

After writing, run the [quality checklist](quality-checklist.md) against your plan. Fix any violations.

#### Cross-validate with Gemini

Run the validation script to get independent feedback from Gemini:

```bash
~/.claude/skills/scrum-grooming/validate-plan.py /tmp/plan-draft.md
```

Read the feedback and address valid points by updating the plan draft. Not all feedback needs to be applied — use your judgement to skip suggestions that don't fit.

#### Finalize

Once feedback is addressed, move the plan to its final location:

```bash
cp /tmp/plan-draft.md ~/Claude/plans/yyyymmdd-{feature-name}.md
```

Commit to the `~/Claude` git repo:
```bash
cd ~/Claude && git add -A && git commit -m "plan: <feature-name>"
```

### Phase 4: Estimate and Decompose

After user agrees with the plan, **decompose tasks and add story point estimates**.

Story point scale (1-5):
- **1 SP** — Simple text/config change, no risk
- **2 SP** — Simple task, predictable, no risk
- **3 SP** — Medium task, minor risks but predictable overall
- **4 SP** — Complex task, medium risk, may need small research but clear enough
- **5 SP** — Research task, developer needs to clarify and decompose further before proceeding

Add estimates to each task in the plan's Status section, grouped by milestone:

```markdown
### M1: Event Model & Migration — 5 SP | pending

| Task | Description | SP | Status |
|------|-------------|----|--------|
| 1.1 | Event model class + migration | 2 | pending |
| 1.2 | Snippet FK + API serializer | 1 | pending |
| 1.3 | Model tests (creation, FK, status) | 2 | pending |

**Total: 27 SP**
```

This gives the user both the milestone-level picture and task-level detail to review estimates. Present to user for feedback. Adjust if they disagree.

### Phase 5: Register Sprint

After estimates are agreed upon, ask the user: **"What is the business goal this sprint contributes to?"** (e.g. "Working events system", "Faster digest pipeline"). This is distinct from the sprint title — it describes the user-facing outcome the sprint is trying to achieve.

Then update `~/Claude/sprints.md` with the new sprint entry.

## Plan File Naming

Use date-prefixed descriptive kebab-case names: `~/Claude/plans/yyyymmdd-{feature-name}.md`
Example: `~/Claude/plans/20260409-keyword-vector-digest.md`

## Sprint Tracking

Maintain `~/Claude/sprints.md` as the sprint registry:

```markdown
# Sprints

| Goal | Plan | SP | Status | Business Goal | Goal Status |
|------|------|----|--------|---------------|-------------|
| Event tracking system | plans/20260409-event-tracking-2.md | 62 | DONE | Working events system | SUCCESS |
| Pipeline eval tests | plans/20260410-pipeline-eval-tests.md | 18 | IN PROGRESS | Faster digest pipeline | |
```

**Status** — reflects technical sprint implementation:
- `PLANNED` — not started
- `IN PROGRESS` — actively being worked on
- `DONE` — all milestones complete
- `FAIL` — abandoned or blocked

**Goal Status** — reflects whether the business goal was achieved (filled in after the sprint):
- `SUCCESS` — goal achieved
- `FAIL` — goal not achieved despite implementation completing

## Post-Implementation Review

After a plan is fully implemented:

1. **Code review** — review the implementation for bugs, missed edge cases, and quality issues
2. **Write retrospective** — run `/scrum-retro <plan-file-path>` to generate a retrospective
3. **Extract lessons** — run `/scrum-lessons <retrospective-path>` to extract lessons and review skills for improvements

## Critical Rules

### Prohibited Content
The plan must NEVER contain:
- "TBD", "TODO", "implement later", "details to follow"
- "Similar to Task N" without specifying exactly what's similar
- Vague directives: "handle edge cases", "add error handling", "clean up"
- Unresolved decisions: "either X or Y" — pick one and justify
- Tasks that span multiple unrelated concerns (e.g., "add model + API + frontend")

### Task Granularity
- Each task should be completable in one focused session (15-60 minutes of agent work)
- Each task touches one concern: model, service, API, frontend, etc.
- Every task lists exact files to create or modify
- Every task has a concrete Definition of Done with checkboxes

### Validate External References
- Docker image names and tags must be verified (e.g., check Docker Hub or official docs for the correct image/tag)
- Package versions must be confirmed against the latest published release (check PyPI, npm, crates.io, etc.)
- API endpoints, CLI flags, and config options for third-party tools must be validated against current documentation
- Never assume a package version, image tag, or API exists — verify it

### Session Independence
- Each milestone must be executable in a fresh session with only the plan as context
- Include enough detail that an agent can start working without reading the entire codebase
- Reference specific file paths, line numbers (approximate), and function names
- Include code sketches for non-obvious implementations

### Progress Tracking
- The plan includes a Status table and checkbox-based DoD per task
- When executing tasks, the agent MUST mark checkboxes as done: `- [ ]` -> `- [x]`
- When a milestone is fully complete, mark it in the Status table: `| M1 | ... | pending |` -> `| M1 | ... | done |`
- Add ` DONE` suffix to the milestone heading when complete

## Presenting the Plan

After writing the plan file, present to the user:
1. A brief summary of the approach
2. The milestone overview with dependency graph
3. Story point estimates per milestone
4. The file path where the full plan is saved
5. Ask if they want to adjust anything before starting execution
