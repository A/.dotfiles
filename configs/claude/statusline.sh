#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract values using jq
model=$(echo "$input" | jq -r '.model.display_name // "Unknown"')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0')
remaining_pct=$(echo "$input" | jq -r '.context_window.remaining_percentage // 100')
total_input=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
total_output=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
context_size=$(echo "$input" | jq -r '.context_window.context_window_size // 0')

# Current usage (from last API call)
current_input=$(echo "$input" | jq -r '.context_window.current_usage.input_tokens // 0')
current_output=$(echo "$input" | jq -r '.context_window.current_usage.output_tokens // 0')
cache_read=$(echo "$input" | jq -r '.context_window.current_usage.cache_read_input_tokens // 0')
cache_write=$(echo "$input" | jq -r '.context_window.current_usage.cache_creation_input_tokens // 0')

# Progress bar (20 chars wide)
bar_width=20
filled=$(printf "%.0f" "$(echo "$used_pct * $bar_width / 100" | bc -l 2>/dev/null || echo 0)")
[ "$filled" -gt "$bar_width" ] 2>/dev/null && filled=$bar_width
[ "$filled" -lt 0 ] 2>/dev/null && filled=0
empty=$((bar_width - filled))

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
RESET='\033[0m'

# Bar color based on usage
if [ "$(echo "$used_pct < 50" | bc -l 2>/dev/null)" = "1" ]; then
    BAR_COLOR=$GREEN
elif [ "$(echo "$used_pct < 75" | bc -l 2>/dev/null)" = "1" ]; then
    BAR_COLOR=$YELLOW
else
    BAR_COLOR=$RED
fi

# Build progress bar string
bar="["
for ((i=0; i<filled; i++)); do bar+="\xe2\x96\x88"; done
for ((i=0; i<empty; i++)); do bar+="\xe2\x96\x91"; done
bar+="]"

# Format token counts (K for thousands, M for millions)
fmt_tokens() {
    local n=$1
    if [ "$n" -ge 1000000 ] 2>/dev/null; then
        printf "%.1fM" "$(echo "$n / 1000000" | bc -l)"
    elif [ "$n" -ge 1000 ] 2>/dev/null; then
        printf "%.1fK" "$(echo "$n / 1000" | bc -l)"
    else
        printf "%d" "$n"
    fi
}

input_fmt=$(fmt_tokens "$total_input")
output_fmt=$(fmt_tokens "$total_output")
context_fmt=$(fmt_tokens "$context_size")

# Output status line
printf "${CYAN}${model}${RESET} | "
printf "${BAR_COLOR}${bar}${RESET} "
printf "${MAGENTA}%.0f%%${RESET} used | " "$used_pct"
printf "${BLUE}in:${input_fmt}${RESET} "
printf "${GREEN}out:${output_fmt}${RESET} "
printf "/ ${context_fmt} | "

# Add cache info if present
if [ "$cache_read" -gt 0 ] 2>/dev/null || [ "$cache_write" -gt 0 ] 2>/dev/null; then
    cache_read_fmt=$(fmt_tokens "$cache_read")
    cache_write_fmt=$(fmt_tokens "$cache_write")
    printf "${YELLOW}cache:${RESET} "
    [ "$cache_read" -gt 0 ] 2>/dev/null && printf "r:${cache_read_fmt} "
    [ "$cache_write" -gt 0 ] 2>/dev/null && printf "w:${cache_write_fmt}"
else
    printf "${YELLOW}%.0f%%${RESET} remaining" "$remaining_pct"
fi
