require 'spec_helper'
require 'rack/test'
require 'nokogiri'
require_relative '../../app'

RSpec.describe 'Station9: TODOの編集画面' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  let(:db) { SQLite3::Database.new('db/todos.db') }
  let(:test_todo_title) { 'テスト用TODO' }
  let(:test_todo_id) { nil }

  before(:each) do
    # テストデータの準備
    db.execute('DELETE FROM todos')
    db.execute('INSERT INTO todos (title) VALUES (?)', [test_todo_title])
    @todo_id = db.last_insert_row_id
  end

  describe '一覧画面の編集リンク' do
    before { get '/todos' }

    it '編集リンクが存在すること' do
      doc = Nokogiri::HTML(last_response.body)
      edit_links = doc.css("a[href='/todos/#{@todo_id}/edit']")
      expect(edit_links).not_to be_empty
    end
  end

  describe '編集画面の表示' do
    before { get "/todos/#{@todo_id}/edit" }

    it '編集画面にアクセスできること' do
      expect(last_response.status).to eq 200
    end

    it '編集フォームが存在すること' do
      doc = Nokogiri::HTML(last_response.body)
      expect(doc.css('form')).not_to be_empty
      expect(doc.css('form').first['method']).to match(/post/i)
      expect(doc.css('form').first['action']).to eq("/todos/#{@todo_id}")
    end

    it '現在のTODOの内容が表示されていること' do
      expect(last_response.body).to include(test_todo_title)
    end

    it '入力フィールドに現在の値が設定されていること' do
      doc = Nokogiri::HTML(last_response.body)
      input_field = doc.css('input[name="title"]').first
      expect(input_field['value']).to eq(test_todo_title)
    end

    it '戻るリンクが存在すること' do
      expect(last_response.body).to include('<a href="/todos">戻る</a>')
    end
  end

  describe 'エラーハンドリング' do
    it '存在しないTODOのIDにアクセスした場合は404エラーを返すこと' do
      get '/todos/999999/edit'
      expect(last_response.status).to eq 404
    end
  end
end 
