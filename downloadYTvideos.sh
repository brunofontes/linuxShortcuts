#!/bin/bash

URL=$1
yt-dlp -o "%(title)s/%(title)s [%(id)s].%(ext)s" -o "thumbnail:%(title)s/cover.%(ext)s" --write-thumbnail --convert-thumbnails jpg --write-description --embed-chapters --embed-metadata --write-subs "$URL"
