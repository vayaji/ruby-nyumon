# macOS での環境構築手順

## 1. Homebrew のインストール

ターミナルを開き、下記のコマンドを実行します。
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## 2. rbenv のインストール

Homebrew を使用して rbenv をインストールします。
```ruby
brew install rbenv
```

下記 2つのコマンドで rbenv の初期化をします。
```bash
echo 'eval "$(rbenv init -)"' >> ~/.zshrc
```
```bash
source ~/.zshrc
```

## 3. Ruby のインストール

1. インストール可能な Ruby のバージョンを確認します。
```ruby
rbenv install -l
```

2. 最新の安定版をインストールします。（例：3.2.2）
```ruby
rbenv install 3.2.2
```

3. デフォルトの Ruby バージョンを設定します。
```ruby
rbenv global 3.2.2
```

4. インストールが正常にできているか確認します。※ ruby 3.2.2 のような数字が出ていれば ok です。
```ruby
ruby -v
```

## 4. Bundler のインストール
下記のコマンドを実行します。
```ruby
gem install bundler
```

## 5. 動作確認
下記のコマンドを実行して Ruby が正しく動作することを確認します。
```ruby
ruby -e "puts 'Hello, Ruby!'"
```

## 6. Gemのインストール
下記のコマンドを必ず **ruby-nyumon リポジトリ配下**で実行します。
※ VSCode で ruby-nyumon リポジトリを開いたあと、VSCode のターミナルを開くか、cd コマンドを使用して ruby-nyumon ディレクトリへ移動すること。

```ruby
bundle install
```

## トラブルシューティング

- コマンドが見つからない場合は、`~/.zshrc`に下記のパスが追加されているか確認してください。
```bash
export PATH="$HOME/.rbenv/bin:$PATH"
```

- rbenv コマンドが認識されない場合は、ターミナルを再起動してみてください。
