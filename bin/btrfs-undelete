#!/bin/bash
# btrfs-undelete
# Copyright (C) 2013 Jörg Walter <info@syntax-k.de>
# This program is free software; you can redistribute it and/or modify it under
# the term of the GNU General Public License as published by the Free Software
# Foundation; either version 2 of the License, or any later version.

if [ ! -b "$1" -o -z "$2" -o -z "$3" ]; then
	echo "Usage: $0 <dev> <file/dir> <dest>" 1>&2
	echo
	echo "This program tries to recover the most recent version of the"
	echo "given file or directory (recursively)"
	echo
	echo "<dev> must not be mounted, otherwise this program may appear"
	echo "to work but find nothing."
	echo
	echo "<file/dir> must be specified relative to the filesystem root,"
	echo "obviously. It may contain * and ? as wildcards, but in that"
	echo "case, empty files might be 'recovered'. If <file/dir> is a"
	echo "single file name, this program tries to recover the most"
	echo "recent non-empty version of the file."
	echo
	echo "<dest> must be a writable directory with enough free space"
	echo "to hold the files you're trying to restore."
	exit 1
fi
dev="$1"
file="$2"

file="${file#/}"
file="${file%/}"
regex="${file//\\/\\\\}"

# quote regex special characters
regex="${regex//./\.}"
regex="${regex//+/\+}"
regex="${regex//|/\|}"
regex="${regex//(/\(}"
regex="${regex//)/\)}"
regex="${regex//\[/\[}"
regex="${regex//]/\]}"
regex="${regex//\{/\{}"
regex="${regex//\}/\}}"

# treat shell wildcards specially
regex="${regex//\*/.*}"
regex="${regex//\?/.}"

# extract number of slashes in order to get correct number of closing parens
slashes="${regex//[^\/]/}"

# build final regex
regex="^/(|${regex//\//(|/}(|/.*${slashes//?/)}))\$"

roots="$(mktemp --tmpdir btrfs-undelete.roots.XXXXX)"
out="$(mktemp --tmpdir="$3" -d btrfs-undelete.XXXXX)"
cd $out

trap "rm $roots" EXIT
trap "rm -r $out &> /dev/null; exit 1" SIGINT

echo -ne "Searching roots..."
btrfs-find-root -a "$dev" 2>&1 \
	| grep ^Well \
	| sed -r -e 's/Well block ([0-9]+).*/\1/' \
	| sort -rn >$roots || exit 1
echo

i=0
max="$(wc -l <$roots)"

while read id; do
	((i+=1))
	echo -e "Trying root $id... ($i/$max)"
	btrfs restore -t $id --path-regex "$regex" "$dev" . &>/dev/null
	if [ "$?" = 0 ]; then
		found=$(find . -type f ! -size 0c | wc -l)
		if [ $found -gt 0 ]; then
			echo "Recovered $found non-empty file(s) into $out"
			exit 0
		fi
		find . -type f -size 0c -exec echo "Found {} but it's empty" \; -delete
	fi
done <$roots
rm -r $out
echo "Didn't find '$file'"
exit 1
