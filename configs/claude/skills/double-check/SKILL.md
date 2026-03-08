---
name: double-check
description: Multi-model fact-checking. Opus checks independently, spawns a Sonnet sub-agent for a blind second review, then compares and reconciles both results into a consensus report.
---

# Double-Check (Multi-Model Verification)

Perform independent fact-checks of a document using multiple Claude models, then reconcile results.

## Procedure

### Step 1: Identify the target
- Determine the target document from conversation context
- If ambiguous, ask the user to clarify

### Step 2: Opus check (self)
- Read the target document thoroughly and fact-check for:
  - Technical accuracy (versions, APIs, config values, limits)
  - Numerical consistency (calculations, totals)
  - Internal contradictions (mismatches between sections)
  - Code example correctness
- Use WebSearch to verify against primary sources and cite evidence
- Classify each finding as: **Correct / Needs Fix / Improvement Suggested**

### Step 3: Sonnet sub-agent independent check
- Launch a Sonnet sub-agent via the Task tool (`model: "sonnet"`)
- Pass only the document path — do NOT share Opus findings (to ensure independence)
- Prompt:

```
Fact-check the following document.
Verify technical accuracy, numerical consistency, internal contradictions, and code example correctness.
Classify each finding as "Correct / Needs Fix / Improvement Suggested" with cited evidence.
Use WebSearch to verify against primary sources.

Target: <file path>
```

### Step 4: Compare and reconcile
- Cross-reference both sets of findings
- Agreed findings → adopt directly
- Found by only one reviewer → Opus performs additional verification
- Conflicting opinions → resolve with additional WebSearch, decide based on evidence

### Step 5: Consensus report
- Present the final report:

```markdown
## Double-Check Results

**Target**: <document name>
**Reviewers**: Claude Opus 4.6 + Claude Sonnet 4.5

### Needs Fix
| # | Section | Issue | Evidence |
|---|---------|-------|----------|

### Improvement Suggested
| # | Section | Issue | Evidence |
|---|---------|-------|----------|

### Verified (Correct)
<list of key verified items>
```
