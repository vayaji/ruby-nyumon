# Windows での環境構築手順

## 1. RubyInstaller のダウンロード

1. [RubyInstaller](https://rubyinstaller.org/downloads/) にアクセス
2. Ruby + Devkit の最新安定版（WITH DEVKIT）をダウンロード
   - 例：Ruby + Devkit 3.2.X (x64) を選択

## 2. RubyInstaller のインストール

1. ダウンロードしたインストーラーを実行
2. インストール時のオプション：
   - Add Ruby executables to your PATH にチェック
   - Associate .rb and .rbw files with Ruby にチェック
3. インストール完了後、ridk install のセットアップウィンドウが表示されたら：
   - 1, 2, 3 を順番に選択してインストール
   - すべて完了したらEnterキーを押して終了

## 3. インストールの確認

コマンドプロンプトまたは PowerShell を開き、ruby -v で確認

## 4. Bundler のインストール
```bash
gem install bundler を実行
```

## 5. 動作確認
下記を実行して Ruby が正しく動作することを確認
```bash
ruby -e "puts 'Hello, Ruby!'"
```
## 6. Gem のインストール
```bash
bundle install を実行
```

## トラブルシューティング

### SSL 証明書のエラーが発生する場合
下記を実行
```bash
gem update --system
```


### コマンドが認識されない場合
1. システム環境変数の PATH を確認
2. 以下のパスが含まれているか確認：
   - C:\Ruby32-x64\bin
   - パスが無い場合は手動で追加

### MSYS2 関連のエラーが発生する場合
コマンドプロンプトで下記を実行
```bash
ridk install
```

## 注意事項
- インストール時は管理者権限で実行することを推奨
- アンチウイルスソフトがインストールを妨げる場合は一時的に無効化
- システムの再起動が必要な場合があります
- プログラミング学習用のフォルダは、パスに日本語や空白を含まない場所に作成することを推奨
