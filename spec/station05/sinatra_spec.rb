require 'spec_helper'
require 'capybara/rspec'
require_relative '../../app.rb'

RSpec.describe 'sinatra を使って開発しよう' do
  before(:all) do
    start_server
  end

  after(:all) do
    stop_server
  end

  describe 'サーバーの起動テスト' do
    it 'localhost:4567にアクセスできること' do
      visit 'http://localhost:4567'
      expect(page.status_code).to eq(200)
    end

    it 'Hello World!が表示されること' do
      visit 'http://localhost:4567'
      expect(page.body).to include('Hello, World!')
    end
  end
end
