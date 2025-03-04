# macOS での環境構築手順

## 1. Homebrew のインストール

ターミナルで以下のコマンドを実行します：

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

## 2. rbenv のインストール

Homebrew を使用して rbenv をインストールします：
```bash
brew install rbenv
```

rbenvの初期化：
```bash
echo 'eval "$(rbenv init -)"' >> ~/.zshrc
source ~/.zshrc
```

## 3. Ruby のインストール

1. インストール可能な Ruby のバージョンを確認：
```bash
rbenv install -l
```

2. 最新の安定版をインストール（例：3.2.2）：
```bash
rbenv install 3.2.2
```

3. デフォルトの Ruby バージョンを設定：
```bash
rbenv global 3.2.2
```

4. インストールの確認：
```bash
ruby -v
```

## 4. Bundler のインストール
```bash
gem install bundler
```

## 5. 動作確認

以下のコマンドを実行して Ruby が正しく動作することを確認：
```bash
ruby -e "puts 'Hello, Ruby!'"
```

## 6. Gemのインストール
```bash
bundle install
```

## トラブルシューティング

- コマンドが見つからない場合は、`~/.zshrc`に以下のパスが追加されているか確認：
```bash
export PATH="$HOME/.rbenv/bin:$PATH"
```

- rbenv コマンドが認識されない場合は、ターミナルを再起動してください。
