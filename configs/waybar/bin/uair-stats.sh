#! /bin/bash
STATS_FILE=~/.tmp/pomodoro.log

F=`cat ${STATS_FILE} | grep $(date '+%Y-%m-%d') | grep F | wc -l`
R=`cat ${STATS_FILE} | grep $(date '+%Y-%m-%d') | grep R | wc -l`
P=`cat ${STATS_FILE} | grep $(date '+%Y-%m-%d') | grep P | wc -l`

echo "F:${F} R:${R} P:${P}"
