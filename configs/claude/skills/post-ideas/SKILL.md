---
description: Extract technical blog post ideas from recent Claude Code session logs
user-invocable: true
allowed-tools:
  - Bash(bash ~/.claude/skills/post-ideas/scripts/*)
  - Task(subagent_type=general-purpose)
---

# Post Ideas from Claude Code Sessions

Analyze recent Claude Code sessions to find interesting technical topics for blog posts.

## Arguments

`$ARGUMENTS` — number of days to look back (default: 1)

## Workflow

### Phase 1: Extract raw session data

Set days from arguments (default 1):

```bash
DAYS="${ARGUMENTS:-1}"
# Strip non-numeric
DAYS=$(echo "$DAYS" | grep -oP '\d+' | head -1)
DAYS="${DAYS:-1}"
```

Run both extraction scripts:

```bash
bash ~/.claude/skills/post-ideas/scripts/extract-sessions.sh --days "$DAYS"
```

```bash
bash ~/.claude/skills/post-ideas/scripts/extract-topics.sh --days "$DAYS"
```

### Phase 2: Analyze with sub-agent

Launch a **Sonnet sub-agent** (`subagent_type: "general-purpose"`, `model: "sonnet"`) with the combined output from both scripts. The sub-agent prompt should be:

> Analyze these Claude Code session logs. Identify recurring themes, interesting technical problems, and potential blog post topics.
>
> Look for:
> - Problems being solved and debugging sessions
> - Architectural decisions and trade-offs
> - Tool and technology integrations
> - Unique approaches or workarounds
> - Lessons learned from failures
>
> For each theme found, provide:
> - A short label
> - Which project(s) it appeared in
> - Key details and context from the messages
> - Why it would make an interesting post
>
> Group related messages into coherent topics. Skip trivial interactions.
>
> Raw session data:
> [paste both script outputs here]

### Phase 3: Synthesize final output

Using the sub-agent's analysis, produce **3-5 post ideas**, each with:

- **Title**: Concise, specific, compelling
- **Summary**: 2-3 sentences on what to cover
- **Angle**: What makes this interesting or useful to others

Prioritize:
- Unique approaches or solutions (not just "how to use X")
- Lessons learned from real problems
- Techniques that could help others facing similar challenges

### Phase 4: Save approved ideas

When the user approves post ideas, save each one as a markdown file in `~/Dev/@A/notes/PostIdeas/` with frontmatter (status: idea, tags, source) and structured sections (Core Story, Key Themes, Technical Details, Angle).

## Example Output

### 1. Step-Level Evaluation for LLM Pipelines
Building debug tooling to test individual pipeline steps with different prompts without re-running the entire pipeline. Covers step persistence, test endpoints, and dynamic config schemas.

### 2. Personal Knowledge RAG with MCP
Using Model Context Protocol to give Claude Code semantic search over personal notes. Architecture with Qdrant, local embeddings, and practical use cases.
