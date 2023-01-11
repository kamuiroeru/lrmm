# LINE Rich Menu Manager

リッチメニューを楽にデプロイできるようにするスクリプト群

## Requirements
- bash
- jqコマンド
- [yqコマンド](https://github.com/kislyuk/yq)

## FYI
- [リッチメニューエンドポイント一覧](https://developers.line.biz/ja/reference/messaging-api/#rich-menu)

## How to Use
1. 適当なディレクトリにこのリポジトリをクローンしてください。
2. lrmm_**.sh が使えるように PATH を通すことをおすすめします。

### リッチメニュー登録方法
##### 1. リッチメニューの登録設定に必要なファイル用意し、タブごとにディレクトリ分けする。
最低限以下の3ファイルが必要（ `[something]` は任意の英数字が使用可能 ）。
デフォルトのリッチメニューに設定したい場合は `default.txt` という空ファイルを作成しておく。

- `alias_id.txt` : リッチメニューに付与する エイリアス ID が書いてあるテキストファイル
- `[something].png` : リッチメニューの背景画像 (PNG形式)
- `[something].yml` : リッチメニューの設定（[リッチメニューオブジェクト](https://developers.line.biz/ja/reference/messaging-api/#rich-menu-object) を YAML 形式にしたもの）


例. 日本語（デフォルト設定）、英語、ポルトガル語、ベトナム語 の 4つのタブがあるリッチメニューを設定する際のディレクトリ構成

```
.
├── .channel_access_token  # チャンネルアクセストークンが書かれたファイル（あると便利）
├── rich_menus
│   ├── ja
│   │   ├── alias_id.txt
│   │   ├── hc_rm_ja.png
│   │   ├── settings_ja.yml
│   │   └── default.txt
│   ├── en
│   │   ├── alias_id.txt
│   │   ├── hc_rm_en.png
│   │   └── settings_en.yml
│   ├── pt
│   │   ├── alias_id.txt
│   │   ├── hc_rm_pt.png
│   │   └── settings_pt.yml
└─ ├── vi
          ├── alias_id.txt
          ├── hc_rm_vi.png
          └── settings_vi.yml

```

##### 2. スクリプトを実行する。
チャンネルアクセストークン が書かれたファイル `.channel_access_token` がある場合。

```sh
cat .channel_access_token | lrmm_create.sh rich_menus/ja
cat .channel_access_token | lrmm_create.sh rich_menus/en
cat .channel_access_token | lrmm_create.sh rich_menus/pt
cat .channel_access_token | lrmm_create.sh rich_menus/vi
```

チャンネルアクセストークン のファイルがない場合

```sh
lrmm_create.sh rich_menus/ja
Channel Access Token: [ここにチャンネルアクセストークンをペーストする。見た目上表示されないが入力されているから気にせずEnter]
...
lrmm_create.sh rich_menus/en
Channel Access Token: [ここにチャンネルアクセストークンをペーストする。見た目上表示されないが入力されているから気にせずEnter]
...
lrmm_create.sh rich_menus/pt
Channel Access Token: [ここにチャンネルアクセストークンをペーストする。見た目上表示されないが入力されているから気にせずEnter]
...
lrmm_create.sh rich_menus/vi
Channel Access Token: [ここにチャンネルアクセストークンをペーストする。見た目上表示されないが入力されているから気にせずEnter]
...
```

##### 3. 作成されたリッチメニューを確認する
```sh
cat .channel_access_token | lrmm_show.sh
# 出力は省略
```

### リッチメニュー エイリアス 一括削除方法
削除したいリッチメニューのチャンネルアクセストークンをコピーしておく

```sh
lrmm_delete.sh
Channel Access Token: [ここにチャンネルアクセストークンをペーストする。見た目上表示されないが入力されているから気にせずEnter]
設定中のリッチメニューがすべて削除されます。よろしいですか？ (y/N): [y] と入力
# 削除処理
```

### リッチメニュー再登録方法
先に登録してあるリッチメニューを削除してから、再度上記のリッチメニュー登録を実施する。
