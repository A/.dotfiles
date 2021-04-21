#!/bin/bash

declare -A engines

# Search engines
engines[arch]="https://wiki.archlinux.org/index.php?search=%s"
engines[mdn]="https://developer.mozilla.org/en-US/search?q=%s"
engines[gh]="https://github.com/search?q=%s"
engines[un]="https://unsplash.com/s/photos/%s"
engines[w]="https://en.wikipedia.org/w/index.php?search=%s"
engines[ddg]="https://duckduckgo.com/?q=%s"

for key in "${!engines[@]}"; do
  engine_keys+="!${key} "
done
echo "Engines: ${engine_keys}"

if [ "$@" != "" ]; then
  arg=$@
  engine=$(echo "${arg}" | sed -r 's/.*!([a-z]*).*/\1/g')
  query=$(echo "${arg}" | sed -r 's/![a-z]*?\s?//g')

  if [ ! -z "${engines[$engine]}" ]; then
    url=$(echo "${engines[$engine]}" | sed -r "s/%s/$query/g")
    firefox --new-tab ${url} &
    exit 0
  fi
fi
