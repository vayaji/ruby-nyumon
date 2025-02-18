require 'spec_helper'
require 'capybara/rspec'
require_relative '../../app.rb'

Capybara.app = Sinatra::Application

RSpec.describe 'sinatra を使って開発しよう' do
  include Capybara::DSL

  before(:all) do
    # サーバーを別スレッドで起動
    @server_thread = Thread.new do
      Sinatra::Application.run! host: 'localhost', port: 4567
    end
    # サーバーの起動を待つ
    sleep 2
  end

  after(:all) do
    # サーバーを停止
    @server_thread.kill
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
