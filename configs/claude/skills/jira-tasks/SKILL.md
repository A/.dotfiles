---
name: jira-tasks
description: Create Jira tasks from a planning document with clear, actionable descriptions
trigger: When the user asks to create Jira issues/tasks/stories from a planning document, spec, or list of work items. Also triggered when user provides a structured list of tasks and asks to put them in Jira.
---

## User Input

```text
$ARGUMENTS
```

## Overview

Parse the provided planning document and create Jira issues with clear, actionable descriptions that save engineers time.

## Critical Rule

**NEVER invent or assume requirements.** Use ONLY what's explicitly stated in the input document. If the input says "try/catching and retries", that's what goes in the description - don't expand it to "unified interface" or "plugin architecture" unless the document says that.

## Workflow

### 1. Gather Required Information

Before creating issues, clarify with the user:

**Project:**
- Ask for project key or name if not provided in the document

**Epic:**
- In this company, Epic = signed contract/fixed scope of work
- Usually one planning document = one Epic (one signed contract)
- If unclear from document, ask: "Should I create a new Epic for this scope, or link to an existing one?"

**Assignees (if needed):**
- Ask for assignee mapping (e.g., "developer tasks → user@example.com, devops → other@example.com")

### 2. Parse the Document

Extract:
- Epic name/goal (from document title or Goal section)
- Tasks with estimates (format: `[Xd]` or `[Xh]`)
- Subtasks if present
- Explicit DoD if provided

### 3. Evaluate Subtasks Need

Ask the user: "Do any of these tasks need to be split into Jira subtasks?"

**Create subtasks when:**
- Tasks can be developed separately by different people
- Tasks have sequential dependencies (one blocks another)
- Tasks represent distinct deliverables that need separate tracking

**DON'T create subtasks when:**
- Items are just parts of one focused work that developer handles together
- Splitting would create unnecessary overhead
- Items are already listed as work breakdown in the description

### 4. Handle Missing DoD

If a task has no explicit DoD in the original document:
- List the tasks/work items in the description
- Ask the user: "This task has no explicit DoD. Would you like to add one?"
- Suggest possible DoD items based on the task list (but let user decide)

### 5. Create Issues

- Create Epic first (if needed)
- Create child issues (Story/Task) linked to Epic
- Create subtasks only where confirmed with user

## Description Format

### When DoD is provided in original document:

```markdown
## Definition of Done

- [Copy DoD items exactly from original document]

## Tasks

- [Xh] Task description from original
- [Xh] Another task
```

### When no DoD is provided:

```markdown
## Tasks

- [Xh] Task description from original
- [Xh] Another task
```

Then ask user if they want to add DoD.

## DoD Writing Rules (when user provides DoD)

**DoD items MUST be:**
- Verifiable true/false statements (either done or not done)
- Concrete outcomes, not implementation details
- Copied from original document when available

**DoD items MUST NOT:**
- Be invented by you - only use what's in the source
- Include implicit requirements (unit tests, code review - these are process)

## Time Estimates

- Parse from document: `[3d]` = 3 days, `[4h]` = 4 hours
- Set `originalEstimate` field on each issue
- Format: "1d", "4h", "3d 4h"

## Issue Hierarchy

- **Epic**: Signed contract/fixed scope of work
- **Story/Task**: Deliverable feature or work item
- **Sub-task**: Only when explicitly needed (see "Evaluate Subtasks Need")

## Example Transformation

**Input:**
```markdown
- Simple Accounts (manual account creation):
    - DoD:
        - User accounts can be created by request
        - Users can login/logout to the accounts via login/password
        - Entities (transcripts/videos) are user-bound both on FE and BE
    - [1h] Configure drf AuthUser model
    - [2h] Update other models (Transcript, Element, etc) to use reference to the AuthUser model
    - [1h] Add JWT auth
    - [4h] Add auth on frontend (JWT auth, GET /me)
```

**Output:**
```markdown
## Definition of Done

- User accounts can be created by request
- Users can login/logout via login/password
- Entities (transcripts/videos) are user-bound both on FE and BE

## Tasks

- [1h] Configure DRF AuthUser model
- [2h] Update other models (Transcript, Element, etc) to use reference to AuthUser
- [1h] Add JWT auth
- [4h] Add auth on frontend (JWT auth, GET /me)
```

## Example: Task without explicit DoD

**Input:**
```markdown
- [3d] DevOps Tasks:
    - Setup GKE
    - Setup staging deployment
    - Setup production deployment
```

**Output:**
```markdown
## Tasks

- Setup GKE
- Setup staging deployment
- Setup production deployment
```

Then ask: "This task has no explicit DoD. Would you like to add one? For example:
- GKE cluster is provisioned and operational
- Staging environment is deployed and accessible
- Production environment is deployed and accessible"

## Checklist Before Creating Issues

1. Project key confirmed with user
2. Epic decision made (new or existing)
3. Subtask needs evaluated with user
4. DoD copied exactly from original (not invented)
5. Tasks listed with time estimates
6. Assignees set if mapping provided
7. Missing DoD flagged and user asked

## Sources

Based on best practices from:
- [Atlassian Community - How to write useful tickets](https://community.atlassian.com/forums/Jira-articles/How-to-write-a-useful-Jira-ticket/ba-p/2147004)
- [Cantina - Writing Better Jira Tickets](https://cantina.co/three-quick-tips-to-writing-better-jira-tickets/)
