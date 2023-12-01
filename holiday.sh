#!/bin/bash --

tomorrow=$(date --date='tomorrow' +%Y-%m-%d)

while read row
do
    holiday=$(echo "$row" | cut -d , -f 1)
    if [[ "$holiday" == "$tomorrow" ]]
    then
        echo "$row" | cut -d , -f 2
        exit 1
    fi
done </home/bruno/.feriados

exit 0
