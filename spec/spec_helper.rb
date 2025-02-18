require 'rspec'
require 'rack/test'
require 'capybara/rspec'

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

  config.before(:each) do
    Capybara.app = Sinatra::Application
    DB.execute('DELETE FROM todos') # テストごとにDBをクリア
  end
end 
