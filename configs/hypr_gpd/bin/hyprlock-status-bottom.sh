#!/bin/bash

song=""
_song="$(playerctl metadata --format '{{title}}')" 

if [ -n "$_song" ]; then
  song="$(playerctl metadata --format '   {{title}} - {{artist}}')" 
fi

echo "$song"


