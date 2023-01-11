#!/bin/bash

cd $(dirname $0)

BASE_URL="https://api.line.me/v2/bot"
DATA_BASE_URL="https://api-data.line.me/v2/bot/richmenu"

source ./utils.sh

get_auth

echo -n "Channel Access Token is: "
echo_pass $CHANNEL_ACCESS_TOKEN

function list_rm () {
  curl -s -X GET $BASE_URL/richmenu/list \
    -H "Authorization: Bearer $CHANNEL_ACCESS_TOKEN"
}

function list_alias () {
  curl -s -X GET $BASE_URL/richmenu/alias/list \
    -H "Authorization: Bearer $CHANNEL_ACCESS_TOKEN"
}

function main () {
  list_rm | jq
  list_alias | jq
}

main
