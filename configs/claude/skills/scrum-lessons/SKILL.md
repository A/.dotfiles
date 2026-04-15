---
name: scrum-lessons
description: Extract lessons from a retrospective and review skills/agents for improvements. Creates lesson files in ~/Claude/lessons/ and suggests concrete changes to scrum skills. Invoke with /scrum-lessons <retrospective-path> or after running /scrum-retro.
argument-hint: [retrospective file path]
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash(ls *)
  - Bash(mkdir *)
  - Bash(cd ~/Claude && git *)
  - AskUserQuestion
---

# Lessons Extraction Skill

Extract actionable lessons from a retrospective and review the scrum skills/agents for improvements based on those lessons.

## Arguments

`$ARGUMENTS` — path to the retrospective file. If omitted, look for the most recent file in `~/Claude/retrospectives/` or ask the user.

## Workflow

### Phase 1: Read Retrospective and Existing Lessons

1. **Read the retrospective** from `$ARGUMENTS`. Extract: root causes, what went wrong, takeaways, and the "Lessons Review" section (if present).
2. **Read the plan file** referenced in the retrospective to understand the original decisions.
3. **Read all existing lesson files** in `~/Claude/lessons/` to avoid duplicates and understand current coverage.

### Phase 2: Extract Lessons

For each root cause and "new pattern not covered by lessons" from the retrospective:

1. **Generalize** — strip project-specific details. A lesson about `EXTRA_MODELS` becomes a lesson about dependency injection. A lesson about `LlmRequest` batch coupling becomes a lesson about SRP.
2. **Write as rules** — each lesson should be a concrete instruction Claude Code can follow, not a description of what went wrong.
3. **Add a check** — include a question or litmus test that can be applied during planning or implementation.

Lesson file format:

```markdown
# Lesson: [Title]

**Source**: [link to retrospective]

---

## Rules for Claude Code

### 1. [Rule name]

[1-3 sentences describing the rule.]

**Check**: [Question to ask or test to apply.]

### 2. [Rule name]
...
```

Save to `~/Claude/lessons/YYYYMMDD-title.md` using the retrospective's date.

### Phase 2b: Review CLAUDE.md for Needed Changes

Read the project's `CLAUDE.md`. For each extracted lesson, check:

1. **Should this become a CLAUDE.md convention?** Project-specific rules (naming conventions, queryset patterns, architectural constraints) belong in CLAUDE.md, not in lessons.
2. **Is an existing CLAUDE.md convention too vague?** If a lesson traces back to agents misinterpreting a CLAUDE.md rule, propose a more specific wording.
3. **Does CLAUDE.md contradict existing code?** If code patterns drift from CLAUDE.md, flag it — either the doc or the code needs updating.

Include CLAUDE.md changes in the confirmation step alongside lesson and skill changes.

### Phase 3: Review Skills and Agents

Read all scrum skill files:
- `~/.claude/skills/scrum-grooming/SKILL.md`
- `~/.claude/skills/scrum-grooming/quality-checklist.md`
- `~/.claude/skills/scrum-grooming/template.md`
- `~/.claude/skills/scrum-implement/SKILL.md`
- `~/.claude/skills/scrum-retro/SKILL.md`
- `~/.claude/skills/scrum-lessons/SKILL.md` (this skill — self-review)

Also read any other skills referenced in the retrospective or that were active during the sprint (e.g., `solid`, `code-review`, `testing-principles`).

For each extracted lesson, ask:

1. **Which skill should enforce this?** (scrum-grooming for planning-time issues, scrum-implement for execution-time issues, both for cross-cutting concerns)
2. **What concrete change would enforce it?** (new checklist item, new phase step, new rule, updated template section)
3. **Would an agent briefing template change help?** (e.g., scrum-implement agents should receive specific lessons in their prompt)

Present findings as a table:

```markdown
## Skill & Agent Improvements

| Lesson | Skill | Change | Description |
|--------|-------|--------|-------------|
| Design-first replacement | scrum-grooming/quality-checklist.md | Add checklist item | "Does the plan design the target interface before mapping old code?" |
| SRP for unified classes | scrum-grooming/quality-checklist.md | Add checklist item | "Does any proposed class have two distinct responsibilities?" |
| Lessons in agent briefs | scrum-implement/SKILL.md | Update agent briefing rules | Include applicable lesson rules when briefing agents |
```

### Phase 4: Confirm and Apply

Present to the user:
1. The lesson file that will be created (full content)
2. The skill/agent improvements table
3. Ask: "Save lessons? Apply skill changes? (y/n for each)"

- **Lessons**: save to `~/Claude/lessons/` on approval
- **Skill changes**: apply edits to the target skill files on approval
- **Commit**: after all changes are applied, commit to the `~/Claude` git repo:
  ```bash
  cd ~/Claude && git add -A && git commit -m "lessons: <retro-name>"
  ```

### Phase 5: Update Existing Lessons

Check if any existing lesson file should be **updated** (new rule added to an existing topic) rather than creating a duplicate file. If a new lesson overlaps with an existing one, merge them.

Check if any existing lesson is **outdated** — if the codebase has moved past the issue (e.g., the problematic pattern was already fixed), flag it for removal.

## Rules

- **Generalize, don't narrate** — lessons are rules for future behavior, not a summary of what happened
- **One file per theme** — group related rules into a single lesson file, don't create one file per rule
- **No duplicates** — if an existing lesson covers the same ground, update it instead
- **Skill changes need approval** — never modify skills without user confirmation
- **Check applicability** — before suggesting a skill change, verify the current skill text doesn't already cover it
- **Single location per lesson** — each piece of knowledge belongs in exactly one place. Don't duplicate across skills, lessons, and CLAUDE.md. Use this heuristic:
  - **Skills** (`~/.claude/skills/`) — methodology: how to plan, implement, review, run retros
  - **Lessons** (`~/Claude/lessons/`) — experience: knowledge extracted from sprint successes and failures, applicable across projects
  - **CLAUDE.md** — project-specific: conventions, architecture decisions, and rules tied to this codebase
