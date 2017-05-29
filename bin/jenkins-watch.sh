#!/bin/bash

URL=$1
ITERATION=0
while [ $ITERATION -le 9 ]
do
  [ "`curl $1 | grep -c Took`" -gt "0" ] && osascript -e 'display notification "Jenkins job was finished"' && exit
  sleep 10
  [ $ITERATION -gt "360" ] && osascript -e 'display notification "Timeout for jenkins job was reached."'
  ((ITERATION++))
done
