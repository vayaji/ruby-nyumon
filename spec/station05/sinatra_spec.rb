require 'spec_helper'
require 'rack/test'
require 'net/http'
require_relative '../../app.rb'

RSpec.describe 'sinatra を使って開発しよう' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe 'サーバーの起動テスト' do
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

    it 'localhost:4567にアクセスできること' do
      uri = URI('http://localhost:4567')
      response = Net::HTTP.get_response(uri)
      expect(response.code).to eq('200')
    end

    it 'Hello World!が表示されること' do
      uri = URI('http://localhost:4567')
      response = Net::HTTP.get_response(uri)
      expect(response.body).to eq('Hello World!')
    end
  end
end
