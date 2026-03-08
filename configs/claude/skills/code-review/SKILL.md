---
name: code-review
description: Pre-commit code review for Python/Django, React/TypeScript, and Rust projects. Checks for bugs, security issues, performance problems, and code quality. Invoke manually with /code-review before committing.
---

# Code Review

Pre-commit review focused on bugs, security, performance, and quality for Python/Django, React/TypeScript, and Rust codebases.

## Workflow

### 1. Identify changes

Run `git diff --cached --stat` (staged) and `git diff --stat` (unstaged).
If nothing is staged, ask the user what to review.
List files to review grouped by language.

### 2. Review with independent sub-agent

Launch a Sonnet sub-agent via Task tool (`model: "sonnet"`, `subagent_type: "general-purpose"`).
Pass file paths and diffs only — do NOT share your own impressions.

Sub-agent prompt:

```
Review the following code changes. Read each file and its diff carefully.
For each issue found, report:
- Category: BUG / SECURITY / PERF / QUALITY
- File and line number
- Description of the issue
- Suggested fix

At the end, give a verdict: APPROVE or REQUEST_CHANGES.

Language-specific focus:
- Python/Django: SQL injection via raw queries, missing auth decorators, N+1 queries in views/serializers, unvalidated user input, missing migrations
- React/TypeScript: XSS via dangerouslySetInnerHTML, missing dependency arrays in hooks, unhandled promise rejections, prop type mismatches
- Rust: unwrap() in non-test code, missing error propagation, unsafe blocks without justification, unbounded allocations

Files to review:
<file list with paths>
```

### 3. Self-review (parallel)

While the sub-agent runs, independently review the same changes yourself with the same criteria.

### 4. Reconcile

Compare both sets of findings:
- **Both flagged** → report as confirmed
- **One flagged** → verify with additional context, include if valid
- **Conflicting** → investigate further, decide based on evidence

### 5. Report

Present findings to the user:

```markdown
## Code Review

**Verdict**: APPROVE | REQUEST_CHANGES

### Issues
| # | Severity | Category | Location | Issue | Suggestion |
|---|----------|----------|----------|-------|------------|

### Verified (no issues)
- <list of reviewed files with no problems>
```

Severity levels:
- **Critical** — must fix before commit (bugs, security vulnerabilities)
- **Warning** — should fix (performance, quality)
- **Note** — optional improvement

### 6. If REQUEST_CHANGES

Offer to fix critical issues automatically. After fixing, re-run review (max 2 iterations).
Do NOT commit — leave that to the user.
