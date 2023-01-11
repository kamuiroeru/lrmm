#!/bin/bash

cd $(dirname $0)

BASE_URL="https://api.line.me/v2/bot"
DATA_BASE_URL="https://api-data.line.me/v2/bot/richmenu"

source ./utils.sh

get_auth

echo -n "Channel Access Token is: "
echo_pass $CHANNEL_ACCESS_TOKEN

read -p "設定中のリッチメニューがすべて削除されます。よろしいですか？ (y/N): " yn
case "$yn" in
  [yY]*) echo "Start";;
  *) exit 1;;
esac

function list_rm () {
  curl -s -X GET $BASE_URL/richmenu/list \
    -H "Authorization: Bearer $CHANNEL_ACCESS_TOKEN"
}

function list_alias () {
  curl -s -X GET $BASE_URL/richmenu/alias/list \
    -H "Authorization: Bearer $CHANNEL_ACCESS_TOKEN"
}

function delete_rm () {
  RICH_MENU_ID=$1
  curl -X DELETE $BASE_URL/richmenu/$RICH_MENU_ID \
    -H "Authorization: Bearer $CHANNEL_ACCESS_TOKEN"
}

function delete_alias () {
  ALIAS_ID=$1
  curl -X DELETE $BASE_URL/richmenu/alias/$ALIAS_ID \
    -H "Authorization: Bearer $CHANNEL_ACCESS_TOKEN"
}

function main () {
  for id in $(list_rm | jq -r ".richmenus[].richMenuId"); do
    echo $id
    delete_rm $id
  done

  for alias_id in $(list_alias | jq -r ".aliases[].richMenuAliasId"); do
    echo $alias_id
    delete_alias $alias_id
  done
}

main
