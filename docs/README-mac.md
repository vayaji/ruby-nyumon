# macOSでのRuby環境構築手順

## 1. Homebrewのインストール

ターミナルで以下のコマンドを実行します：

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

## 2. rbenvのインストール

Homebrewを使用してrbenvをインストールします：

brew install rbenv

rbenvの初期化：

echo 'eval "$(rbenv init -)"' >> ~/.zshrc
source ~/.zshrc

## 3. Rubyのインストール

1. インストール可能なRubyのバージョンを確認：

rbenv install -l

2. 最新の安定版をインストール（例：3.2.2）：

rbenv install 3.2.2

3. デフォルトのRubyバージョンを設定：

rbenv global 3.2.2

4. インストールの確認：

ruby -v

## 4. Bundlerのインストール

gem install bundler

## 5. 動作確認

以下のコマンドを実行してRubyが正しく動作することを確認：

ruby -e "puts 'Hello, Ruby!'"

## 6. Gemのインストール

bundle install


## トラブルシューティング

- コマンドが見つからない場合は、`~/.zshrc`に以下のパスが追加されているか確認：

export PATH="$HOME/.rbenv/bin:$PATH"

- rbenvコマンドが認識されない場合は、ターミナルを再起動してください。
