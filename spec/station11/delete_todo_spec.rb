require 'spec_helper'
require 'rack/test'
require 'nokogiri'
require_relative '../../app'

RSpec.describe 'Station11: TODOの削除機能' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  let(:db) { SQLite3::Database.new('db/todos.db') }
  let(:test_todo_title) { 'テスト用TODO' }

  before(:each) do
    # テストデータの準備
    db.execute('DELETE FROM todos')
    db.execute('INSERT INTO todos (title) VALUES (?)', [test_todo_title])
    @todo_id = db.last_insert_row_id
  end

  describe '削除フォームの確認' do
    before { get '/todos' }

    it '削除フォームが存在すること' do
      doc = Nokogiri::HTML(last_response.body)
      delete_forms = doc.css("form[action='/todos/#{@todo_id}']")
      expect(delete_forms).not_to be_empty
    end

    it 'フォームのmethod属性がPOSTであること' do
      doc = Nokogiri::HTML(last_response.body)
      form = doc.css("form[action='/todos/#{@todo_id}']").first
      expect(form['method'].downcase).to eq('post')
    end

    it '_method=DELETEの隠しフィールドが存在すること' do
      doc = Nokogiri::HTML(last_response.body)
      form = doc.css("form[action='/todos/#{@todo_id}']").first
      hidden_method = form.css('input[type="hidden"][name="_method"][value="DELETE"]')
      expect(hidden_method).not_to be_empty
    end

    it '削除ボタンが存在すること' do
      doc = Nokogiri::HTML(last_response.body)
      form = doc.css("form[action='/todos/#{@todo_id}']").first
      submit_button = form.css('input[type="submit"], button[type="submit"]')
      expect(submit_button).not_to be_empty
    end
  end

  describe 'TODOの削除' do
    it 'DELETEリクエストでTODOを削除できること' do
      delete "/todos/#{@todo_id}"
      expect(last_response.status).to eq 302  # リダイレクトのステータスコード
    end

    it 'データベースから該当のTODOが削除されていること' do
      delete "/todos/#{@todo_id}"
      result = db.execute('SELECT * FROM todos WHERE id = ?', [@todo_id])
      expect(result).to be_empty
    end

    it '削除後に一覧画面にリダイレクトされること' do
      delete "/todos/#{@todo_id}"
      follow_redirect!
      expect(last_request.path).to eq('/todos')
    end

    it '削除されたTODOが一覧に表示されないこと' do
      delete "/todos/#{@todo_id}"
      get '/todos'
      expect(last_response.body).not_to include(test_todo_title)
    end
  end

  describe 'エラーハンドリング' do
    it '存在しないTODOの削除時は404エラーを返すこと' do
      delete '/todos/999999'
      expect(last_response.status).to eq 404
    end
  end
end 
