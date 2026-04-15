#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = [
#     "google-genai>=0.3.0",
# ]
# ///
"""Validate sprint plan using Gemini."""

import os
import sys
from pathlib import Path

import google.genai as genai


def validate_plan(plan_file: Path) -> int:
    """Get Gemini feedback on plan. Returns 0 for clean exit."""

    if not plan_file.exists():
        print(f"❌ Plan file not found: {plan_file}", file=sys.stderr)
        return 1

    plan_content = plan_file.read_text()
    api_key = os.environ.get("GEMINI_API_KEY")

    if not api_key:
        print("❌ GEMINI_API_KEY environment variable not set", file=sys.stderr)
        return 1

    # Prevent SDK from auto-picking GOOGLE_API_KEY
    os.environ.pop("GOOGLE_API_KEY", None)
    client = genai.Client(api_key=api_key)
    model = "gemini-3.1-pro-preview"

    prompt_text = f"""You are a Staff Software Engineer and Tech Lead reviewing a technical sprint plan or architecture document.

Your goal is to identify architectural blind spots, edge cases, and technical debt risks before execution begins. Balance strict technical rigor with actionable advice. Apply universal software engineering principles, as the stack may involve any modern ecosystem (e.g., Rust, React, Python, Go, distributed systems).

Review the provided document against the following criteria:
1. **State Management & Data Integrity:** Are transaction boundaries clear? Are there risks of orphaned data, cache invalidation bugs, or lifecycle mismatches (e.g., persistent database state vs. ephemeral cache/memory)?
2. **Concurrency & Resiliency:** What happens if a process fails midway, or if a service/function is triggered twice simultaneously? Are idempotency, race conditions, retries, and network boundaries explicitly handled?
3. **Coupling & Architecture:** Are there potential circular dependencies, leaky abstractions, or tight coupling between business logic and I/O / UI / external frameworks?
4. **Testability & Static Guarantees:** Are the Definitions of Done strictly verifiable? Are we maximizing the compiler/type-checker (e.g., strict typing, traits, interfaces) and static analysis tools to catch bugs early instead of relying solely on runtime tests?
5. **Design Patterns:** Are there better abstractions available (e.g., composition over inheritance, hook methods, dependency injection, or avoiding boilerplate)?

Format your response cleanly using markdown headings, bullet points, and brief pseudo-code or generalized code snippets if proposing a specific structural fix. Be concise, direct, and assume the reader is a Senior Engineer.

### Technical Document / Sprint Plan:
{plan_content}
"""

    try:
        response = client.models.generate_content(
            model=model,
            contents=prompt_text,
        )
        print(f"\n📋 Plan Validation: {plan_file.name}\n")
        print(response.text)
    except Exception as e:
        print(f"❌ Error: {e}", file=sys.stderr)
        return 1

    return 0


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: uv run validate-plan.py <plan-file-path>", file=sys.stderr)
        sys.exit(1)

    plan_path = Path(sys.argv[1]).expanduser()
    sys.exit(validate_plan(plan_path))
