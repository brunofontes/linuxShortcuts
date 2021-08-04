#!/bin/sh
echo "$1" > ~/.lastVideo
/usr/bin/vlc --started-from-file "$1" 2>/dev/null &
