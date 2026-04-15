---
name: scrum-implement
description: Execute an implementation plan milestone-by-milestone. Reads the plan, reviews lessons, then implements tasks using agents for parallelizable work. Invoke with /scrum-implement <plan-file-path> or triggered when the user asks to implement/execute a plan.
argument-hint: [plan file path]
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
  - Agent
  - AskUserQuestion
  - TaskCreate
  - TaskUpdate
effort: max
---

# Plan Implementation Skill

Execute an implementation plan by working through milestones and tasks systematically.

## Arguments

`$ARGUMENTS` — path to the plan file. If omitted, ask the user.

## Workflow

### Phase 1: Review Plan and Lessons

1. **Read the plan file** from `$ARGUMENTS`. Extract: milestones, tasks, decisions, implementation order, key files.
2. **Read all files in `~/Claude/lessons/`**. For each lesson, check whether any plan decision or task conflicts with it. If a conflict is found, flag it to the user before proceeding — do NOT silently implement something that violates a known lesson.
3. **Read key files** listed in the plan to verify they exist and match the plan's assumptions. If the codebase has drifted since planning, flag discrepancies.

### Phase 2: Confirm Scope

Present to the user:
- Number of milestones and total SP
- Any lesson conflicts or codebase drift found
- Proposed execution order (from the plan's implementation order)
- Ask: "Ready to start, or adjust anything?"

Wait for confirmation before proceeding.

### Phase 3: Execute Milestones

Work through milestones in the order specified by the plan's dependency graph.

For each milestone:

1. **Create tasks** for each task in the milestone using TaskCreate.
2. **Execute tasks sequentially** within a milestone unless the plan explicitly marks them as parallelizable.
3. For each task:
   - Read the task's target files before modifying them
   - Implement exactly what the plan specifies — no extras, no "improvements"
   - Mark DoD checkboxes in the plan file as completed: `- [ ]` → `- [x]`
   - Update task status via TaskUpdate
   - Update the plan's status table: task status → `done`
4. **Run milestone verification** — execute the verify commands from the plan
5. **Mark milestone complete** in the plan's status table and add ` DONE` to the milestone heading
6. **Report milestone completion** to the user with a brief summary of what was done

#### Using Agents for Parallel Work

When the plan's dependency graph shows milestones that can run in parallel, use the Agent tool to execute them concurrently:

- Use `subagent_type: "be-dev"` for backend tasks (Python, Django, APIs, migrations)
- Use `subagent_type: "fe-dev"` for frontend tasks (React, TypeScript, components)
- Use `subagent_type: "manager"` when coordinating mixed backend/frontend milestones

When briefing agents, include:
- The full milestone section from the plan
- Relevant decisions from the plan's Decisions section
- Any applicable lessons from `~/Claude/lessons/`
- The key files they need to read

### Phase 4: Final Verification

After all milestones are complete:

1. Run the plan's **Final Verification** checks
2. Verify all DoD checkboxes are marked
3. Verify all milestone statuses are `done`
4. Report completion to the user

### Phase 5: Update Sprint Status

Update `~/Claude/sprints.md` — set the sprint status to `IN PROGRESS` when starting (if not already), or `DONE` when all milestones pass final verification.

## Rules

- **Never skip a task** — if a task seems unnecessary, ask the user rather than dropping it
- **Never add work** — implement what the plan says, nothing more
- **Stop on failure** — if a verification step fails, diagnose and fix before moving to the next milestone. If you can't fix it, ask the user
- **Lessons are load-bearing** — if you notice you're about to violate a lesson during implementation (not just at review time), stop and reconsider the approach
- **Mark progress as you go** — update the plan file after each task, not in bulk at the end
- **Flag unexpected behavior in tests** — when writing tests, if behavior looks like a bug (e.g., no user isolation, data leaking), flag it to the user rather than asserting it as expected. A comment documenting a bug is not a test.
- **Boy Scout Rule** — when verification reveals pre-existing failures (broken tests, lint errors, stale mocks) unrelated to the current work, report them to the user and ask whether to fix. Don't silently dismiss or silently fix.
