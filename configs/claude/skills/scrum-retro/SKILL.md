---
name: scrum-retro
description: Generate a sprint retrospective from a plan file and tech lead feedback. Analyzes what was planned vs what was built, identifies root causes, and produces actionable takeaways. Invoke with /scrum-retro <plan-file-path> or triggered when the user asks to create a retrospective.
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash(git log *)
  - Bash(git diff *)
  - Bash(git show *)
  - Bash(ls *)
  - Bash(mkdir *)
  - WebSearch
  - AskUserQuestion
---

# Sprint Retrospective Skill

Generate focused, actionable retrospectives by comparing what was planned against what was actually built and the feedback received.

## Arguments

`$ARGUMENTS` — path to the plan file for the sprint being reviewed. If omitted, ask the user.

## Output Location

Save retrospectives to `~/Claude/retrospectives/YYYYMMDD.md` using today's date.

## Workflow

### Phase 1: Gather Context

1. **Read the plan file** from `$ARGUMENTS`. Extract: sprint goal, key decisions, milestones, and scope boundaries.
2. **Read the current code** that was produced. Use `Glob` and `Grep` to find the files the plan targeted. Understand what was actually built.
3. **Check git history** for the branch. Use `git log --oneline` and `git diff main...HEAD --stat` to understand the scope of changes.
4. **Collect feedback** — if the user provides tech lead feedback or review comments (in the conversation or as a file), incorporate them. If no feedback is available, ask: "Do you have review feedback or notes on what needs to change?"

### Phase 2: Analyze Gaps

For each piece of feedback or identified issue, trace it back to a specific plan decision:

- **Was it planned but executed poorly?** (implementation gap)
- **Was it explicitly deferred?** (scope gap — was the deferral justified?)
- **Was it never considered?** (blind spot)
- **Was it a pre-existing issue that got carried forward?** (migration debt)

Group findings into root causes. Look for patterns:
- Porting old patterns instead of redesigning
- Scope conservatism that kicked problems down the road
- Missing SOLID analysis at plan time
- Accepting existing data/config patterns without questioning them

### Phase 3: Write the Retrospective

Use this structure:

```markdown
# Sprint Retrospective: [Sprint Name]

**Date**: YYYY-MM-DD
**Sprint goal**: [one line]
**Plan**: [path to plan file]
**Branch**: [git branch name]

---

## What went well

Concrete wins. What was achieved, what worked as designed. Keep it brief — 3-5 bullet points with specifics, not vague praise.

---

## What went wrong

For each issue:

### [Issue title]

**What happened**: Factual description of the problem.
**Why**: Trace to the plan decision or blind spot that caused it.
**Impact**: What does this cost now (rework, tech debt, user confusion)?

---

## Root causes

Synthesize the "why" lines from above into 2-4 underlying patterns. These should be general enough to apply to future sprints.

---

## Action items

| # | Action | Owner | Status |
|---|--------|-------|--------|
| 1 | Specific, actionable task | Next sprint / Person | Planned |

---

## Takeaways for future sprints

3-5 concrete behavioral changes. Not platitudes ("communicate better") — specific heuristics ("when replacing a module, design the new interface before mapping old code to new structure").
```

### Phase 3b: Review CLAUDE.md Impact

Read the project's `CLAUDE.md`. Check whether any convention or instruction in it contributed to issues found in Phase 2:

- Did a vague convention lead to agents making the wrong choice?
- Did a missing convention leave agents without guidance?
- Did agents follow existing code patterns that contradicted CLAUDE.md?

Include findings in the retrospective under "What went wrong" or "Root causes" as appropriate. Do NOT modify CLAUDE.md — that's the lessons skill's job. Just analyze the impact.

### Phase 4: Review Against Existing Lessons

Read all files in `~/Claude/lessons/`. For each problem identified in Phase 2:

1. **Was there already a lesson that should have prevented this?** If yes, note it — this means the lesson isn't being applied effectively (needs reinforcement or the grooming skill needs a check for it).
2. **Is this a new pattern not covered by existing lessons?** If yes, flag it for lesson extraction.

Add a section to the retrospective:

```markdown
## Lessons Review

### Existing lessons that applied
- [lesson file]: [which rule] — [was it followed or violated, and why]

### New patterns not covered by lessons
- [description] — candidate for new lesson
```

### Phase 5: Self-Review

Before saving, check:

- [ ] Every "what went wrong" item has a traceable cause (plan decision, blind spot, or carried debt)
- [ ] Root causes are patterns, not just restatements of individual issues
- [ ] Action items are specific and actionable (not "improve testing")
- [ ] Takeaways are heuristics a developer could actually apply next sprint
- [ ] "What went well" is honest — not inflated to balance criticism
- [ ] No blame language — focus on decisions and processes, not people
- [ ] Lessons review section is present and cross-references existing lesson files

### Phase 6: Save

Write retrospective to `~/Claude/retrospectives/YYYYMMDD.md`. Create directory if needed.

After saving, commit to the `~/Claude` git repo:
```bash
cd ~/Claude && git add -A && git commit -m "retro: <sprint-name>"
```

Report the file path and a one-line summary of the key takeaway.

After the retrospective is saved, suggest running `/scrum-lessons <retrospective-path>` to extract lessons and review skills/agents.

## Anti-Patterns to Avoid

- **Vague praise**: "Good teamwork" tells you nothing. Be specific: "ModelRef round-trip parsing works correctly for all 30+ model strings."
- **Blame**: "X should have done Y." Focus on what decision led to the outcome.
- **Laundry lists**: Don't enumerate every small issue. Group into themes and root causes.
- **Missing the systemic**: Individual bugs aren't retro material. Patterns that produce bugs are.
- **Happy-path retrospectives**: If the tech lead gave substantial feedback, the retro should reflect that honestly.
- **Generic takeaways**: "Write more tests" is useless. "Add a SOLID review step to the plan before implementation" is actionable.
