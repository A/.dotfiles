#!/usr/bin/env bash

# Weather section
WEATHER_FILE="$HOME/.cache/weather_report"

awk '
  {
    printf "%-7s %-3s %-8s %s\n", $1, $2, $3, $4
  }
' "$WEATHER_FILE"

echo ""  # spacer line

# Currency section
CURRENCY_FILE="$HOME/.cache/currencies"
CURRENCY_TOTAL_WIDTH=24

while IFS= read -r line; do
  key="${line%%:*}"
  val="$(echo "$line" | awk '{print $2}')"
  pad_len=$((CURRENCY_TOTAL_WIDTH - ${#key} - ${#val}))
  dots=$(printf '%*s' "$pad_len" '' | tr ' ' '.')
  printf "%s%s%s\n" "$key" "$dots" "$val"
done < "$CURRENCY_FILE"
