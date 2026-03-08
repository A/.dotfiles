---
name: commit
description: Commit, push, and update PR with a clean workflow. Checks for out-of-scope files before committing.
disable-model-invocation: true
argument-hint: [optional commit message]
---

# Commit, Push & Update PR

Follow these steps exactly in order.

## Step 1: Check git remotes

Run `git remote -v` to list all configured remotes.

- **If there is exactly one remote:** use it for push and PR operations.
- **If there are multiple remotes:** **stop and ask the user explicitly** which remote to push to before proceeding. Do NOT assume.

Remember the chosen remote for Steps 3 and 4.

## Step 2: Check for out-of-scope changes

Run `git status` and `git diff --stat` to see all changed files (staged + unstaged + untracked).

Determine which files are **in scope** (related to the current task/branch) and which are **out of scope** (unrelated changes, config tweaks, leftover experiments, etc.).

If there are any files that look out of scope, **stop and ask the user explicitly** what to do with each one:
- Include them in this commit
- Ignore them (leave unstaged)

Do NOT silently include or exclude files. Always confirm with the user when ambiguous.

## Step 3: Create the commit

Stage only the confirmed files. Write a concise commit message:

- If `$ARGUMENTS` is provided, use it as the commit message
- Otherwise, analyze the changes and write a message: short subject line (imperative mood), optional body explaining "why" not "what"
- Do NOT add Co-Authored-By lines

Commit the changes.

## Step 4: Push

Push the current branch to the remote. If no upstream is set, push with `-u` to set tracking.

## Step 5: Update the PR

Check if a PR already exists for this branch using `gh pr view`.

- **If PR exists:** Update the PR description using `gh pr edit` to reflect the current state of all changes on the branch (not just this commit). Use `git log <base>..HEAD` to review all commit messages on the branch.
- **If no PR exists:** Create a new PR using `gh pr create`.

### PR description format

Use this format for the PR body — keep it focused on what changed, no test plans:

```
## Summary

- Bullet points describing the changes across all commits on the branch
- Focus on what was added/changed/removed and why
- Group related changes together
```

IMPORTANT rules for writing PR descriptions:

1. Never include test plans, testing instructions, or "how to test" sections. Only describe the changes.
2. **Describe the final state, not the journey.** The PR description should reflect what the base branch will receive after merging — not internal intermediate steps between commits on the branch. If something was introduced and then renamed/refactored within the same branch, only describe the final result. For example, if env vars were added in commit 1 and renamed in commit 2, just describe them by their final names without mentioning the rename.
