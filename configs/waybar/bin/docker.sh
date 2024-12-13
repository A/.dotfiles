#!/bin/sh

RUNNING_CONTAINERS=$(docker ps --format "{{.ID}} | {{.Names}}")
RUNNING_CONTAINERS_STR=$(printf "%s" "$RUNNING_CONTAINERS" | sed ':a;N;$!ba;s/\n/\\n/g; s/"/\\"/g')
NUMBER_RUNNING_CONTAINERS=$(printf "%s\n" "$RUNNING_CONTAINERS" | wc -l)
NUMBER_TOTAL_CONTAINERS=$(docker ps -qa | wc -l)

echo "{\"text\": \"${NUMBER_RUNNING_CONTAINERS}\", \"tooltip\": \"$RUNNING_CONTAINERS_STR\", \"alt\": \"\", \"class\": \"\" }"
