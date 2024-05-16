#/bin/bash

if pgrep -x "newsboat" > /dev/null; then
  cat ~/.tmp/newsboat-current
else
  current=$(newsboat -x print-unread | grep -o '[0-9]*')
  echo "$current" > ~/.tmp/newsboat-current
  
  cat ~/.tmp/newsboat-current
fi

