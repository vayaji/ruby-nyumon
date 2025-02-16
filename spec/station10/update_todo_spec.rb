require 'spec_helper'
require 'rack/test'
require 'nokogiri'
require_relative '../../app'

RSpec.describe 'Station10: TODOの更新機能' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  let(:db) { SQLite3::Database.new('db/todos.db') }
  let(:test_todo_title) { 'テスト用TODO' }
  let(:updated_title) { '更新後のTODO' }

  before(:each) do
    # テストデータの準備
    db.execute('DELETE FROM todos')
    db.execute('INSERT INTO todos (title) VALUES (?)', [test_todo_title])
    @todo_id = db.last_insert_row_id
  end

  describe '編集フォームの確認' do
    before { get "/todos/#{@todo_id}/edit" }

    it 'フォームのmethod属性がPOSTであること' do
      doc = Nokogiri::HTML(last_response.body)
      expect(doc.css('form').first['method'].downcase).to eq('post')
    end

    it 'フォームのaction属性が正しいこと' do
      doc = Nokogiri::HTML(last_response.body)
      expect(doc.css('form').first['action']).to eq("/todos/#{@todo_id}")
    end

    it '_method=PUTの隠しフィールドが存在すること' do
      doc = Nokogiri::HTML(last_response.body)
      hidden_method = doc.css('input[type="hidden"][name="_method"][value="PUT"]')
      expect(hidden_method).not_to be_empty
    end
  end

  describe 'TODOの更新' do
    it 'PUTリクエストでTODOを更新できること' do
      put "/todos/#{@todo_id}", { title: updated_title }
      expect(last_response.status).to eq 302  # リダイレクトのステータスコード
    end

    it 'データベースの内容が更新されていること' do
      put "/todos/#{@todo_id}", { title: updated_title }
      updated_todo = db.execute('SELECT title FROM todos WHERE id = ?', [@todo_id]).first
      expect(updated_todo[0]).to eq(updated_title)
    end

    it '更新後に一覧画面にリダイレクトされること' do
      put "/todos/#{@todo_id}", { title: updated_title }
      follow_redirect!
      expect(last_request.path).to eq('/todos')
    end

    it '更新されたTODOが一覧に表示されること' do
      put "/todos/#{@todo_id}", { title: updated_title }
      get '/todos'
      expect(last_response.body).to include(updated_title)
    end
  end

  describe 'エラーハンドリング' do
    it '存在しないTODOの更新時は404エラーを返すこと' do
      put '/todos/999999', { title: updated_title }
      expect(last_response.status).to eq 404
    end

    it 'タイトルが空の場合は更新に失敗すること' do
      put "/todos/#{@todo_id}", { title: '' }
      expect(last_response.status).to eq 400
    end
  end
end 
