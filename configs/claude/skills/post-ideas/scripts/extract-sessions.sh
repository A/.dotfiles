#!/usr/bin/env bash
# Extract user messages from Claude Code session logs, grouped by project.
# Usage: extract-sessions.sh [--days N]

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

# Find session logs modified within N days, excluding subagents
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
  # Convert path-encoded name to readable: -home-anton-Dev--A-notes -> @A/notes
  readable=$(echo "$project_name" | sed -E 's/^-home-anton-Dev--//; s/^-home-anton-//; s/--/\//g; s/-/\//g' | sed 's|^|/|')
  PROJECT_FILES["$readable"]+="$f"$'\n'
done

# Process each project
for project in $(echo "${!PROJECT_FILES[@]}" | tr ' ' '\n' | sort); do
  echo "## Project: $project"
  echo ""

  msg_count=0
  while IFS= read -r logfile; do
    [[ -z "$logfile" ]] && continue

    # Extract user messages that are NOT tool results and not meta
    # Filter out system tags (<system-reminder>, etc.) and interruption messages
    messages=$(jq -r '
      select(.type == "user" and (has("toolUseResult") | not))
      | .message.content
      | if type == "string" then .
        elif type == "array" then
          [.[] | select(.type == "text") | .text] | join("\n")
        else empty
        end
      | select(length > 0)
      | select(test("^\\s*<") | not)
      | select(test("^\\[Request interrupted") | not)
    ' "$logfile" 2>/dev/null) || continue

    while IFS= read -r msg; do
      [[ -z "$msg" ]] && continue
      msg_count=$((msg_count + 1))
      # Truncate very long messages
      if [[ ${#msg} -gt 500 ]]; then
        msg="${msg:0:500}..."
      fi
      echo "${msg_count}. ${msg}"
      echo ""
    done <<< "$messages"
  done <<< "${PROJECT_FILES[$project]}"

  if [[ $msg_count -eq 0 ]]; then
    echo "_No user messages found._"
    echo ""
  fi

  echo "---"
  echo ""
done
