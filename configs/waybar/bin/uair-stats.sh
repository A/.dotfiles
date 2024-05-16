#! /bin/bash
STATS_FILE=~/.tmp/pomodoro.log

PROJECTS=$(cat ~/.config/uair/uair.toml | perl -n -e'/id = \"(.*)\"/ && print "$1\n"')

RESULT=""
for PROJECT in $PROJECTS; do
  PROJECT_NUMBER=`cat ${STATS_FILE} | grep $(date '+%Y-%m-%d') | grep "@${PROJECT}" | wc -l`
  RESULT="${RESULT} <b>${PROJECT}</b>:${PROJECT_NUMBER}"
done;

echo ${RESULT}
