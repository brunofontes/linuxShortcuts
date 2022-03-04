#!/bin/bash
file="$1"
foldername="$(echo "$file" | sed 's/\(.*\)\..*/\1/')/"

if [ -f "$file" ] ; then
  case "$file" in
     *.tar.bz2)   tar xvjf "$file" -C "$foldername"     ;;
     *.tar.gz)    tar xvzf "$file" -C "$foldername"     ;;
     *.bz2)       bunzip2 "$file" "$foldername"         ;;
     *.rar)       unrar x "$file" "$foldername"         ;;
     *.gz)        gunzip "$file" "$foldername"          ;;
     *.tar)       tar xvf "$file" -C "$foldername"      ;;
     *.tbz2)      tar xvjf "$file" -C "$foldername"     ;;
     *.tgz)       tar xvzf "$file" -C "$foldername"     ;;
     *.zip)       unzip "$file" -d "$foldername"        ;;
     *.Z)         uncompress "$file" "$foldername"      ;;
     *.7z)        7z x "$file" -o "$foldername"         ;;
     *)           echo "'$file' cannot be extracted via >extract<" ;;
  esac
else
  echo "'$file' is not a valid file"
fi

