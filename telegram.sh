#!/bin/bash

echo "Disclaimer: based on the script at https://gist.github.com/dideler/85de4d64f66c1966788c1b2304b9caf1?permalink_comment_id=4327762#gistcomment-4327762"
echo "" && echo "source /path/to/telegram.sh then can call the function each time you want to send a message"
echo 'EXAMPLE: to_tg_bot 123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11 "RUNNING SERVICES" "$(systemctl list-units --type=service --state=running)" ' && echo ""

to_tg_bot () {
    if [ $# == 0 ]; then
    echo 'Usage: to_tg_bot TELEGRAM_BOT_TOKEN "MESSAGE_TITLE" "MESSAGE_TEXT"'
    echo "* TELEGRAM_BOT_TOKEN: Unique authentication token of your Telegram bot."
    echo "* MESSAGE_TITLE: Title of the message, will be printed in bold."
    echo "* MESSAGE_TEXT: Message content, has to be string." && echo ""
    echo "Instructions to create a Telegram bot: https://learn.microsoft.com/en-us/azure/bot-service/bot-service-channel-connect-telegram?view=azure-bot-service-4.0#create-a-new-telegram-bot-with-botfather"
    else
        TELEGRAM_BOT_TOKEN=$1
        CHAT_ID=$(curl -s https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/getUpdates | jq '.result[0].message.from.id')
        title="$2"
        timestamp="$(date -R)"
        msg="$title\n$timestamp\n\n$(echo "$3" | sed -z -e 's|\\|\\\\|g' -e 's|\n|\\n|g' -e 's|\t|\\t|g' -e 's|\"|\\"|g')"
        entities="[{\"offset\":0,\"length\":${#title},\"type\":\"bold\"},{\"offset\":$((${#title}+1)),\"length\":${#timestamp},\"type\":\"italic\"}]"
        data="{\"chat_id\":\"$CHAT_ID\",\"text\":\"$msg\",\"entities\":$entities,\"disable_notification\": true}"
        result=`curl -s -H 'Content-Type: application/json' -d "$data" -X POST https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage`
        if `jq '.ok' <<< "$result"`
            then echo 'message sent' 
            else echo 'failed to send' && echo "$result"
        fi
    fi
}
