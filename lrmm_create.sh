#!/bin/bash

BASE_URL="https://api.line.me/v2/bot"
DATA_BASE_URL="https://api-data.line.me/v2/bot/richmenu"

source $(dirname $0)/utils.sh

get_auth

echo -n "Channel Access Token is: "
echo_pass $CHANNEL_ACCESS_TOKEN


function validate () {
  curl -X POST $BASE_URL/richmenu/validate \
    -H "Authorization: Bearer $CHANNEL_ACCESS_TOKEN" \
    -H 'Content-Type: application/json' \
    -d "$1" \
    -o /dev/null -w '%{http_code}\n' -s
}

function create_rm () {
  curl -X POST $BASE_URL/richmenu \
    -H "Authorization: Bearer $CHANNEL_ACCESS_TOKEN" \
    -H 'Content-Type: application/json' \
    -d "$1"
}

function upload_png () {
  RICH_MENU_ID=$1
  PNG_FILE_PATH=$2
  curl -v -X POST $DATA_BASE_URL/$RICH_MENU_ID/content \
    -H "Authorization: Bearer $CHANNEL_ACCESS_TOKEN" \
    -H 'Content-Type: image/png' \
    -T "$PNG_FILE_PATH"
}

function create_alias () {
  RICH_MENU_ID=$1
  ALIAS_ID=$(cat $2 | xargs echo)
  JSON=`cat << EOS
    {
      "richMenuAliasId": "$ALIAS_ID",
      "richMenuId": "$RICH_MENU_ID"
    }
  EOS
  `

  curl -v -X POST $BASE_URL/richmenu/alias \
    -H "Authorization: Bearer $CHANNEL_ACCESS_TOKEN" \
    -H 'Content-Type: application/json' \
    -d "$JSON"
}

function set_default_rm () {
  RICH_MENU_ID=$1
  curl -v -X POST $BASE_URL/user/all/richmenu/$RICH_MENU_ID \
    -H "Authorization: Bearer $CHANNEL_ACCESS_TOKEN"
}

function main () {
  find $1
  check_exit0

  DIR=$1
  YML=$(find $DIR -type f -name "*.yml" | head -1)
  PNG=$(find $DIR -type f -name "*.png" | head -1)
  ALIAS=$(find $DIR -type f -name "alias_id.txt" | head -1)
  DEFAULT=$(find $DIR -type f -name "default.txt" | head -1)

  HTTP_STATUS=$(validate "$(yq -o json $YML)")
  if [ $HTTP_STATUS -ne 200 ]; then
    echo "[ERROR] Invalid YML. please check $YML"
    exit 1
  fi

  RICH_MENU_ID=$(create_rm "$(yq -o json $YML)" | jq -r ".richMenuId")
  upload_png $RICH_MENU_ID $PNG
  create_alias $RICH_MENU_ID $ALIAS

  # default.txt ファイルがある場合は デフォルトのリッチメニューに設定する
  if [ -n "$DEFAULT" ]; then
    set_default_rm $RICH_MENU_ID
  fi
}

main $1
