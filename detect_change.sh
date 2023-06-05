#!/bin/bash

# source telegram.sh to send notification when condition ini the loop is satisfied
source $1

until [[ `w` == *"pts/2"* ]]
do
    sleep 10
done

#set $TGBOTTOKEN as env/system wide variable
to_tg_bot $TGBOTTOKEN "$(hostname) SSH Users" "$(w)"
