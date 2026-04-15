# Plan Quality Checklist

Run this checklist against every plan before presenting it to the user. Fix violations inline — do not present a plan that fails any check.

## Completeness

- [ ] **Context**: Explains current state, motivation, and explicit scope boundaries
- [ ] **Decisions**: Every non-obvious choice is documented with justification
- [ ] **File mapping**: Every task lists exact files to create or modify
- [ ] **Code sketches**: Non-obvious implementations include code examples
- [ ] **DoD**: Every task has checkboxes with specific, verifiable criteria
- [ ] **Verify blocks**: Every milestone has exact commands to verify completion
- [ ] **Dependency graph**: Implementation order shows which milestones can parallelize
- [ ] **Status table**: All milestones listed with `pending` status
- [ ] **Key files reference**: Important files listed with their role in the plan
- [ ] **Final verification**: End-to-end acceptance criteria defined
- [ ] **Deploy checklist**: Every new env var is present in docker-compose, terraform, and CI

## Prohibited Content Scan

Scan the plan for these patterns. If found, replace with concrete details:

- [ ] No "TBD", "TODO", "implement later", "details to follow", "to be determined"
- [ ] No "similar to Task N" without specifying exactly what
- [ ] No "handle edge cases" without listing the specific cases
- [ ] No "add error handling" without specifying which errors
- [ ] No "clean up" without specifying what changes
- [ ] No unresolved "either X or Y" — every decision is made
- [ ] No tasks combining unrelated concerns (model + API + frontend in one task)

## Task Quality

- [ ] Each task is one concern (model OR service OR API OR frontend)
- [ ] Each task is completable in one focused session (15-60 min agent work)
- [ ] Each task's DoD is independently verifiable without reading other tasks
- [ ] No task depends on context from the conversation — only from the plan itself

## Spec-to-Task Coverage

- [ ] Every requirement from the user's request maps to at least one task
- [ ] No requirement is partially covered — each is fully addressed or explicitly deferred with justification

## Consistency

- [ ] Function/class names used in one task match their definition in another
- [ ] File paths are consistent across all tasks
- [ ] Data structures (schemas, models) match between producer and consumer tasks

## SOLID + DRY Review

For each decision in the plan, check:

- [ ] **Single Responsibility**: No class has two distinct responsibilities (e.g., "single unified class for X and Y" is a red flag)
- [ ] **Open/Closed**: New variants (providers, backends, formats) can be added without modifying existing code
- [ ] **Dependency Inversion**: High-level modules depend on abstractions, not concretions
- [ ] **DRY**: No code sketch appears in 3+ tasks with "same pattern" — extract a shared helper before implementing
- [ ] **One type per concept**: No two types represent the same domain concept with conversion methods between them
- [ ] **Data format consistency**: Data formats are standardized before migration — no multi-format parsers that guess structure
- [ ] **Design-first replacement**: When replacing a module, the plan designs the target interface from SOLID principles first, then maps old code into it — not a 1:1 port of existing patterns
- [ ] **Deferred decisions tracked**: Every "not in scope" or "keep legacy for compat" has a concrete follow-up item in the plan's action items with what needs to change and why

## Lessons Check

Read all files in `~/Claude/lessons/`. For each lesson:

- [ ] No plan decision violates an existing lesson
- [ ] If a lesson applies to this domain, the plan explicitly addresses it
