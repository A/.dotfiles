---
name: blogpost
description: End-to-end blog post creation for Hugo. Research, outline, draft, and polish technical posts about software engineering and AI/LLM topics. Invoke with /blogpost "topic" or triggered when the user asks to write a blog post.
user-invocable: true
allowed-tools:
  - Bash
  - Task(subagent_type=general-purpose)
  - WebSearch
  - WebFetch
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - AskUserQuestion
---

# Blog Post Skill

Write technical blog posts with a structured, repeatable process. Every post goes through research, outline, draft, and polish phases with human checkpoints between them.

## Arguments

`$ARGUMENTS` — the topic, title, or brief for the post.

## Voice & Style

Read the project's `CLAUDE.md` for voice and tone rules. If it doesn't exist, apply these defaults:

- **Direct and concise.** Short sentences. No filler. Get to the point.
- **Technically thorough.** Cover the topic properly. Show code. Explain trade-offs.
- **Active voice only.** "We built X," not "X was built."
- **Write like a senior engineer** explaining something to other engineers. Not dumbing down, not showing off.

### Banned Words

Never use these words or phrases. They signal generic AI output:

**Words:** delve, unleash, unlock, elevate, empower, leverage, utilize, harness, tapestry, landscape, paradigm, synergy, holistic, robust, seamless, transformative, game-changing, cutting-edge, groundbreaking, revolutionary, comprehensive, scalable, proactive, nuanced, intricate, pivotal, confluence, quintessential, myriad

**Phrases:** "In today's world," "In today's fast-paced," "It's worth noting that," "At the end of the day," "game-changer," "paradigm shift," "seamless integration," "works like magic," "first and foremost," "moreover," "furthermore," "in conclusion," "as we navigate," "the reality is," "let's face it"

**Hedge words to minimize:** quite, rather, somewhat, arguably, presumably, seemingly, apparently, essentially, basically, actually, honestly, literally

**Transitions to avoid:** "That said," "With that in mind," "Having said that," "It goes without saying"

If any of these slip into a draft, rewrite the sentence without them.

### Formatting Rules

- No em dashes (—). Use a comma, period, or restructure the sentence.
- No exclamation marks in body text. Reserve for code comments only if needed.
- Code blocks always have a language tag (```rust, ```python, etc.).
- Use H2 (`##`) for main sections, H3 (`###`) for subsections. No H1 in the body (title is H1).
- Keep paragraphs short. 2-4 sentences max.
- Prefer concrete examples over abstract explanations.

## Workflow

### Phase 1: Research

1. **Parse the topic** from `$ARGUMENTS`. Identify the core subject, target audience, and angle.
2. **Search existing content.** Use `Glob` and `Grep` to check if similar posts already exist in the content directory.
3. **Web research.** Use `WebSearch` to find current information, recent releases, documentation. Do not rely on training data for version numbers, API details, or release dates.
4. **Write research notes** to `research/[slug]-research.md` with findings, key points, and source URLs.

### Phase 2: Outline

1. **Create outline** at `outlines/[slug]-outline.md` with:
   - Working title
   - Hook (1-2 sentences that frame the problem or insight)
   - Section structure (H2/H3 hierarchy)
   - Key points per section
   - Code examples to include
   - Estimated word count (target: 800-1500 words unless the topic demands more)

2. **CHECKPOINT: Stop and ask the user to review the outline.**
   Show the outline and wait for approval or feedback. Do not proceed to drafting until the user says to continue.

### Phase 3: Draft

1. **Create the Hugo post** at `drafts/[slug].md` with proper frontmatter:

```yaml
---
title: "Post Title"
date: YYYY-MM-DDTHH:MM:SS+00:00
draft: true
tags: ["tag1", "tag2"]
description: "A one-sentence summary for SEO and social sharing."
---
```

2. **Write section by section.** Follow the approved outline. For each section:
   - Write the content
   - Check against banned words list
   - Verify code examples are complete and correct
   - Keep paragraphs short

3. **Self-review pass.** After completing the draft, read through and fix:
   - Passive voice
   - Banned words that slipped in
   - Paragraphs longer than 4 sentences
   - Missing code language tags
   - Weak openings ("In this post, we will...")

4. **CHECKPOINT: Stop and ask the user to review the draft.**
   Present the draft path and a brief summary of what was written. Wait for feedback.

### Phase 4: Polish

1. **Apply user feedback** from the checkpoint.
2. **Final checks:**
   - [ ] All claims are accurate and sourced where needed
   - [ ] Code examples run correctly (or are clearly pseudocode)
   - [ ] Frontmatter is complete (title, date, tags, description)
   - [ ] No banned words or phrases remain
   - [ ] Opening hook is strong (no "In this post" or "Today we'll")
   - [ ] Post has a clear ending (not a generic "In conclusion" summary)
   - [ ] Word count is in the target range
3. **Move to final** by copying to `final/[slug].md` or the user's Hugo content directory if specified.
4. **Report** the final file path, word count, and a one-line summary.

## Directory Structure

The skill creates working files in the project directory:

```
thoughts/
├── research/        # Research notes per post
├── outlines/        # Structural outlines
├── drafts/          # Work-in-progress drafts
└── final/           # Publication-ready posts
```

Create these directories as needed.

## Tips for Better Posts

- Start with the interesting part, not the setup. "Here's what broke" beats "Let me explain the architecture."
- Show the problem before the solution. Readers need to feel the pain.
- Use real code from real projects when possible, not toy examples.
- If a section feels like filler, cut it.
- End with something useful: a link, a command to try, a mental model to take away. Not a recap of what you just said.
