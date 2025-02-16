require 'spec_helper'
require 'rack/test'
require_relative '../../app'

RSpec.describe 'Station8: TODOの作成機能' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe 'フォームの確認' do
    before do
      get '/todos'
    end

    it 'フォームが存在すること' do
      expect(last_response.body).to include('<form')
      expect(last_response.body).to include('method="POST"')
      expect(last_response.body).to include('action="/todos"')
    end

    it '入力フィールドが存在すること' do
      expect(last_response.body).to include('type="text"')
      expect(last_response.body).to include('name="title"')
    end

    it '送信ボタンが存在すること' do
      expect(last_response.body).to include('type="submit"')
    end
  end

  describe 'TODOの作成' do
    let(:db) { SQLite3::Database.new('db/todos.db') }
    
    before(:each) do
      # テスト前にテーブルをクリア
      db.execute('DELETE FROM todos')
    end

    it 'POSTリクエストでTODOを作成できること' do
      post '/todos', title: 'テストTODO'
      expect(last_response.status).to eq 302  # リダイレクトのステータスコード
    end

    it 'データベースに新しいTODOが保存されること' do
      post '/todos', title: 'テストTODO'
      todos = db.execute('SELECT title FROM todos')
      expect(todos).to include(['テストTODO'])
    end

    it '作成後にトップページにリダイレクトされること' do
      post '/todos', title: 'テストTODO'
      follow_redirect!
      expect(last_request.path).to eq '/'
    end

    it '作成したTODOが一覧に表示されること' do
      post '/todos', title: 'テストTODO'
      get '/todos'
      expect(last_response.body).to include('テストTODO')
    end
  end
end 
