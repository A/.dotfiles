#!/usr/bin/env bash
# Extract tool usage, technologies, and file paths from Claude Code sessions.
# Usage: extract-topics.sh [--days N]

set -euo pipefail

DAYS=1
while [[ $# -gt 0 ]]; do
  case "$1" in
    --days) DAYS="$2"; shift 2 ;;
    *) DAYS="$1"; shift ;;
  esac
done

PROJECTS_DIR="$HOME/.claude/projects"

if [[ ! -d "$PROJECTS_DIR" ]]; then
  echo "No projects directory found at $PROJECTS_DIR" >&2
  exit 1
fi

mapfile -t LOG_FILES < <(find "$PROJECTS_DIR" -name "*.jsonl" -mtime "-${DAYS}" ! -path "*/subagents/*" 2>/dev/null | sort)

if [[ ${#LOG_FILES[@]} -eq 0 ]]; then
  echo "No session logs found in the last ${DAYS} day(s)." >&2
  exit 0
fi

# Group files by project directory
declare -A PROJECT_FILES
for f in "${LOG_FILES[@]}"; do
  project_dir=$(dirname "$f")
  project_name=$(basename "$project_dir")
  readable=$(echo "$project_name" | sed -E 's/^-home-anton-Dev--//; s/^-home-anton-//; s/--/\//g; s/-/\//g' | sed 's|^|/|')
  PROJECT_FILES["$readable"]+="$f"$'\n'
done

for project in $(echo "${!PROJECT_FILES[@]}" | tr ' ' '\n' | sort); do
  echo "## Project: $project"
  echo ""

  # Collect tool usage across all sessions for this project
  all_tools=""
  all_files=""

  while IFS= read -r logfile; do
    [[ -z "$logfile" ]] && continue

    # Extract tool names used
    tools=$(jq -r '
      select(.type == "assistant")
      | .message.content[]?
      | select(.type == "tool_use")
      | .name
    ' "$logfile" 2>/dev/null) || continue
    all_tools+="$tools"$'\n'

    # Extract file paths from tool inputs (Read, Edit, Write, Glob, Grep)
    files=$(jq -r '
      select(.type == "assistant")
      | .message.content[]?
      | select(.type == "tool_use")
      | .input
      | (.file_path // .path // .pattern // empty)
    ' "$logfile" 2>/dev/null) || continue
    all_files+="$files"$'\n'

  done <<< "${PROJECT_FILES[$project]}"

  # Summarize tools
  echo "### Tools Used"
  if [[ -n "$all_tools" ]]; then
    echo "$all_tools" | grep -v '^$' | sort | uniq -c | sort -rn | head -15 | while read -r count name; do
      echo "- $name ($count)"
    done
  else
    echo "_None_"
  fi
  echo ""

  # Summarize file paths - extract directories and extensions
  echo "### Files Touched"
  if [[ -n "$all_files" ]]; then
    echo "$all_files" | grep -v '^$' | sort -u | head -20 | while read -r fpath; do
      echo "- \`$fpath\`"
    done
  else
    echo "_None_"
  fi
  echo ""

  # Extract file extensions for technology detection
  echo "### Technologies (by file extension)"
  if [[ -n "$all_files" ]]; then
    echo "$all_files" | grep -v '^$' | grep -oP '\.[a-zA-Z0-9]+$' | sort | uniq -c | sort -rn | head -10 | while read -r count ext; do
      echo "- $ext ($count)"
    done
  else
    echo "_None_"
  fi
  echo ""

  echo "---"
  echo ""
done
