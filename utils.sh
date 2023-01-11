#!/bin/bash

## 便利機能を集約

## パスワードの先頭一部だけ表示する
function echo_pass () {
  show_char_n=6  # 6文字表示させる
  count_plus1=$(echo $1 | wc -m | xargs echo)
  astar_count=$(($count_plus1 - 1 - $show_char_n ))
  # show_char_n 文字残して パスワードの末尾を削除して表示
  echo -n $1 | sed -E "s/.{$astar_count}$//"
  ## 削除した個数分だけ '*' を表示
  for _ in $(seq 1 $astar_count); do
    echo -n '*'
  done
  echo
}

# CHANNEL_ACCESS_TOKEN を取得する
function get_auth () {
  read -sp "Channel Access Token: " CHANNEL_ACCESS_TOKEN
}

# 以下デバッグ用
# get_auth
# echo_pass $CHANNEL_ACCESS_TOKEN
