#!/bin/bash --

TITLE=""
PRIORITY=""
TAGS=""
TOPIC="bft"
TEXT=""
HELP='
RUN: ntfy.sh [-t "My Title"] [-p "high"] [-a "tag1,tag2"] [--topic "bft"] Here goes my message

Params:
-t, --title,  [optional] a title for the alert
-p, --priority, [optional] The priorities are: min, low, default, high or urgent
-a, --tags,     [optional] one or more tags separate by comma with no spaces*
    --topic     [optional] the topic/channel on which the message will be sent to

List of emojis that can be used as tags: https://brunofontes.net:9795/docs/emojis/
'

[[ -z $1 ]] && echo -e "$HELP" && exit 1


while [[ $# -gt 0 ]]
do
    case $1 in
        -t|--title)
            #TITLE="-H \"Title: $2\""
            TITLE="$2"
            shift && shift
            ;;
        -p|--priority)
            PRIORITY="$2"
            shift && shift
            ;;
        -a|--tags)
            TAGS="$2"
            shift && shift
            ;;
        --topic)
            TOPIC="$2"
            shift && shift
            ;;
        -h|--help)
            echo -e "$HELP"
            exit 0
            ;;
        *)
            [[ -z $TEXT ]] && TEXT="$1" || TEXT="$TEXT $1"
            shift
            ;;
    esac
done

TOKEN=$(pass ntfy)
/usr/bin/curl -H "Authorization: Bearer $TOKEN" \
    -H "Title: $TITLE" \
    -H "Priority: $PRIORITY" \
    -H "Tags: $TAGS" \
    -d "$TEXT" \
    https://brunofontes.net:9795/$TOPIC
