#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 <command_to_execute> <string_2_compare_with_command_output>"
    echo "Example: $0 \"tail log.txt\" \"connected to localhost\""
    exit 1
fi

source telegram.sh

# until [[ `w -h | awk '{print $3}' | sort | uniq | wc -l` -gt 1 ]]
while [[ `$1` == *"$2"* ]]
do
    sleep 10
done

to_tg_bot $TGBOTTOKEN "$(hostname)" "command $1 doesn't contain $2 anymore!"
