# Windows での環境構築手順

## 1. RubyInstaller のダウンロード

1. [RubyInstaller](https://rubyinstaller.org/downloads/) にアクセス
2. Ruby + Devkit の最新安定版（WITH DEVKIT）をダウンロード
   - 例：Ruby + Devkit 3.2.X (x64) を選択

## 2. RubyInstaller のインストール

1. ダウンロードしたインストーラーを実行する。
2. インストール時のオプションとして、下記にチェックを入れる。
   - Add Ruby executables to your PATH にチェック
   - Associate .rb and .rbw files with Ruby にチェック
3. インストール完了後、ridk install のセットアップウィンドウが表示されたら下記を行う。
   - 1、2、3 を順番に選択してインストール
   - すべて完了したら Enter キーを押して終了する

## 3. インストールの確認

コマンドプロンプトまたは PowerShell を開き、Ruby のインストールが正常にできているか確認します。※ ruby 3.2.2 のような数字が出ていれば ok です。
```ruby
ruby -v
```

## 4. Bundler のインストール
下記のコマンドを実行します。
```ruby
gem install bundler
```

## 5. 動作確認
下記を実行して Ruby が正しく動作することを確認します。
```ruby
ruby -e "puts 'Hello, Ruby!'"
```
## 6. Gem のインストール
下記のコマンドを必ず **ruby-nyumon リポジトリ配下**で実行します。
```ruby
bundle install
```

## トラブルシューティング

### SSL 証明書のエラーが発生する場合
下記のコマンドを実行します。
```ruby
gem update --system
```

### コマンドが認識されない場合
下記の手順を行います。
1. システム環境変数の PATH を確認する。
2. 以下のパスが含まれているか確認する。
   - C:\Ruby32-x64\bin
   - パスが無い場合は手動で追加

### MSYS2 関連のエラーが発生する場合
下記のコマンドを実行します。
```ruby
ridk install
```

## 注意事項
- インストール時は管理者権限で実行することを推奨
- アンチウイルスソフトがインストールを妨げる場合は一時的に無効化
- システムの再起動が必要な場合があります
- プログラミング学習用のフォルダは、パスに日本語や空白を含まない場所に作成することを推奨
