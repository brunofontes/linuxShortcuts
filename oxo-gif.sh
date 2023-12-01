#!/bin/sh -

[[ -z $1 ]] && echo "Missing filename to convert" && exit 1

file=$1
gif="${file%.*}.gif"
#gifski --fps 10 -Q 70 -H 2000 --repeat 0 -o "$gif" "$file"
gifski --fps 8 -Q 70 -H 2000 --repeat 0 -o "$gif" "$file"
notify-send -a 'Convert to .gif' "Convertion done: $gif"
