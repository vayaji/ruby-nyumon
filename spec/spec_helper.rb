require 'rspec'
require 'rack/test'
require 'capybara/rspec'
# db/todosファイルが存在する場合のみ読み込む
if File.exist?(File.expand_path('../db/todos.rb', __dir__))
  require_relative '../db/todos'
end


ENV['RACK_ENV'] = 'test'
Capybara.app_host = 'http://localhost:4567'  # ホストを指定

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.before(:suite) do
    # グローバル変数を使用して標準出力と標準エラー出力を保存
    $original_stdout = $stdout
    $original_stderr = $stderr
    $stdout = File.open(File::NULL, "w")
    $stderr = File.open(File::NULL, "w")
  end

  config.after(:suite) do
    $stdout = $original_stdout
    $stderr = $original_stderr
  end

  config.before(:each) do |example|
    if defined?(Sinatra::Application) && example.metadata[:require_sinatra] != false
      Sinatra::Application.set :views, File.join(File.dirname(__FILE__), '../views')
      Capybara.app = Sinatra::Application
      Capybara.default_max_wait_time = 5  # 待機時間を5秒に設定
    end
  end

  config.before(:each, clear_todos: true) do
    if defined?(DB)
      DB.execute('DELETE FROM todos')
    end
  end
end 
