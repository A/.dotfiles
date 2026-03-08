# Skill: Analyze Project

Analyze a project for patterns, libraries, dependencies, solutions, and problems. Build comprehensive notes in the programming knowledge base for RAG retrieval.

## Configuration

- **Notes Directory**: `~/Dev/@A/notes/programming`
- **CLAUDE.md**: `~/Dev/@A/notes/CLAUDE.md`
- **RAG Collection**: `programming`

## Security

**NEVER read or access:**
- `.env` files
- `.env.*` files (`.env.local`, `.env.production`, etc.)
- Any file containing secrets, credentials, or API keys
- `credentials.json`, `secrets.yaml`, or similar

**NEVER save to notes:**
- Passwords, tokens, API keys, secrets
- IP addresses, hostnames, internal URLs
- Database connection strings
- Private keys, certificates
- Personal data (emails, names, phone numbers)
- Any credentials or authentication data

When extracting code examples, **sanitize** by replacing sensitive values with placeholders:
- `"sk-xxxxx"` → `"<API_KEY>"`
- `"192.168.1.100"` → `"<IP_ADDRESS>"`
- `"postgres://user:pass@host"` → `"<DATABASE_URL>"`
- `"user@example.com"` → `"<EMAIL>"`

## Usage

```
/analyze-project [path] [--focus=<area>] [--depth=<shallow|deep>]
```

**Arguments:**
- `path` - Project path (defaults to current directory)
- `--focus` - Focus area: patterns, dependencies, architecture, problems, all (default: all)
- `--depth` - Analysis depth: shallow (quick scan), deep (thorough analysis)

## Analysis Workflow

### Phase 0: Search Existing Knowledge

Before creating new notes, search existing knowledge base using MCP obsidian-rag:

```
mcp__obsidian-rag__search_vault(query="[pattern/library/solution name]", limit=5)
```

Use this to:
- Check if pattern documentation already exists
- Find related notes to link to
- Avoid duplicating existing content
- Extend existing notes instead of creating new ones

### Phase 1: Project Discovery

Scan the project to identify:

1. **Project Type & Stack**
   - Language(s): Check file extensions (.py, .ts, .js, .go, .rs, etc.)
   - Framework: Look for framework-specific files and patterns
   - Build system: Check for build configuration files

2. **Package Managers & Dependencies**
   - Python: `requirements.txt`, `Pipfile`, `pyproject.toml`, `setup.py`
   - Node.js: `package.json`, `package-lock.json`, `yarn.lock`
   - Go: `go.mod`, `go.sum`
   - Rust: `Cargo.toml`, `Cargo.lock`

3. **Configuration Files** (excluding secrets)
   - Docker: `Dockerfile`, `docker-compose.yml`
   - CI/CD: `.github/workflows/`, `.gitlab-ci.yml`
   - Linting: `.eslintrc`, `.prettierrc`, `ruff.toml`

### Phase 2: Code Analysis

Analyze the codebase for:

1. **Design Patterns** - Use Pattern Template checklist
2. **Architectural Patterns** - Layered, microservices, event-driven, etc.
3. **Libraries & Their Usage** - Purpose, integration, configuration
4. **Solutions & Approaches** - Auth, error handling, caching, etc.
5. **Test Design Knowledge** - Testing strategies, what's tested and how, reusable test patterns

### Phase 3: Note Generation

All notes go to: `~/Dev/@A/notes/programming/`

#### 3.1 Pattern Notes Structure

Patterns are split into **Theory** and **Examples**:

**Theory Note:** `~/Dev/@A/notes/programming/patterns/[Pattern Name].md`

```markdown
---
type: pattern
category: creational|structural|behavioral
complexity: low|medium|high
keywords: [searchable terms]
aliases: [alternative names]
---

# [Pattern Name]

## Intent
[What problem does this pattern solve - one paragraph]

## Problem
[Detailed problem description]

## Solution
[How the pattern solves it]

## When to Use
- Scenario 1
- Scenario 2

## When NOT to Use
- Anti-scenario 1
- Anti-scenario 2

## Structure

### Components
1. **Component1**: Role description
2. **Component2**: Role description

### Diagram
```
[ASCII or description]
```

## Simplified Example

### Python
```python
# Minimal, self-contained example demonstrating the pattern
# Keep it simple - 20-40 lines max
class Example:
    pass
```

### TypeScript
```typescript
// Minimal, self-contained example
class Example {}
```

## Advantages
- Pro 1
- Pro 2

## Disadvantages
- Con 1
- Con 2

## Related Patterns
- [[Pattern1]] - relationship
- [[Pattern2]] - relationship

## See Also
- [[Pattern Examples - ProjectName]] - Real-world implementations
```

**Examples Note:** `~/Dev/@A/notes/programming/patterns/examples/[Pattern Name] - [ProjectName].md`

```markdown
---
type: pattern-example
pattern: "[[Pattern Name]]"
project: [ProjectName]
language: [python|typescript|etc]
extracted: [ISO date]
keywords: [pattern name, project name, language, framework]
---

# [Pattern Name] in [ProjectName]

## Context
[Why this pattern was used in the project]

## Implementation

### File: `path/to/file.py`
```python
# Extracted code showing the pattern
# Include enough context to understand usage
# Reference line numbers for navigation
```

### File: `path/to/another.py`
```python
# Related code if pattern spans multiple files
```

## Analysis

### How It Differs from Canonical
[Variations, customizations, or deviations]

### Why This Approach
[Design decisions, trade-offs made]

### Integration Points
- Used by: `module1`, `module2`
- Depends on: `library1`, `library2`

## Lessons Learned
[What works well, what could be improved]

## Related
- [[Pattern Name]] - Theoretical reference
- [[ProjectName - Overview]] - Full project analysis
```

#### 3.2 Project Overview Note

Create: `~/Dev/@A/notes/programming/projects/[ProjectName] - Overview.md`

```markdown
---
type: project-analysis
project: [ProjectName]
analyzed: [ISO date]
stack: [languages, frameworks]
patterns: [list of identified patterns]
keywords: [project name, stack terms, domain terms]
tags: [project, analysis, stack-tags]
---

# [ProjectName] - Project Analysis

## Overview
[Brief project description]

## Tech Stack
| Category | Technology | Version | Purpose |
|----------|------------|---------|---------|
| Language | ... | ... | ... |
| Framework | ... | ... | ... |

## Architecture
[Architectural pattern description]

## Patterns Used
| Pattern | Location | Notes |
|---------|----------|-------|
| [[Pattern Name]] | `path/to/impl` | [[Pattern Examples - ProjectName]] |

## Dependencies
### Production
| Package | Version | Purpose |
|---------|---------|---------|

### Development
| Package | Version | Purpose |
|---------|---------|---------|

## Notable Solutions
- [[Solution - Topic]]: Brief description

## Cross-References
- Patterns: [[Pattern1]], [[Pattern2]]
- Similar: [[OtherProject - Overview]]
```

#### 3.3 Library Notes

Create: `~/Dev/@A/notes/programming/libraries/[LibraryName].md`

```markdown
---
type: library
language: [primary language]
category: [orm, http, testing, etc.]
keywords: [library name, category, language, use cases]
alternatives: [similar libraries]
---

# [LibraryName]

## Overview
[What it does, why use it]

## Installation
```bash
[install command]
```

## Basic Usage
```[language]
# Simple example
```

## Common Patterns

### Pattern 1: [Use Case]
```[language]
# Example
```

### Pattern 2: [Use Case]
```[language]
# Example
```

## Best Practices
- Practice 1
- Practice 2

## Common Pitfalls
- Pitfall 1
- Pitfall 2

## Project Usage
- [[Project1 - Overview]]: [how used]
- [[Project2 - Overview]]: [how used]
```

#### 3.4 Solution Notes

Create: `~/Dev/@A/notes/programming/solutions/[Category] - [Solution].md`

```markdown
---
type: solution
category: [auth, caching, error-handling, etc.]
languages: [applicable languages]
keywords: [problem terms, solution terms, category]
problem: [one-line problem statement]
---

# [Solution Title]

## Problem
[What problem does this solve]

## Solution
[High-level approach]

## Implementation

### Simple Example
```[language]
# Minimal example
```

### Production Example
See: [[Solution Examples - ProjectName]]

## When to Use
- Scenario 1
- Scenario 2

## Alternatives
- [[Alternative Solution 1]]
- [[Alternative Solution 2]]
```

### Phase 4: Cross-Reference with Existing Notes

Before finalizing, search existing notes and add cross-references:

```
mcp__obsidian-rag__search_vault(query="[topic]", limit=5)
```

- Link new notes to existing related notes
- Update existing notes with links to new content
- Ensure bidirectional linking

### Phase 5: Reindex for RAG

After generating all notes, run:

```bash
cd ~/Dev/@A/obsidian_rag_mcp && docker compose exec mcp uv run python -m mcp_server.indexer --clear
```

## Directory Structure

```
~/Dev/@A/notes/programming/
├── Index.md
├── patterns/
│   ├── Pattern Template.md
│   ├── Design Patterns.md
│   ├── [Pattern Name].md          # Theory + simplified examples
│   └── examples/
│       └── [Pattern] - [Project].md  # Extracted real code
├── projects/
│   ├── Index.md
│   └── [Project] - Overview.md
├── libraries/
│   ├── Index.md
│   └── [Library].md
└── solutions/
    ├── Index.md
    ├── [Solution].md              # Theory + simple examples
    └── examples/
        └── [Solution] - [Project].md
```

## Output Summary

```
## Analysis Complete: [ProjectName]

### Generated Notes
- Project Overview: programming/projects/[name].md
- Patterns: X theory notes, Y example notes
- Libraries: Z notes
- Solutions: N notes

### RAG Index
- Indexer executed successfully
```

## RAG Optimization

All notes include:
1. **YAML Frontmatter** with type, keywords, tags, aliases
2. **Structured Headings** for semantic chunking
3. **Code Blocks** with language tags
4. **Cross-References** using `[[wikilinks]]`
5. **Keywords section** in frontmatter for better search matching
