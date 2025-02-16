require 'spec_helper'
require 'rack/test'
require 'json'
require_relative '../../app'

RSpec.describe 'Station13: TODO CRUD API' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  let(:db) { SQLite3::Database.new('db/todos.db') }
  let(:test_todo) { { title: 'テスト用TODO' } }
  
  before(:each) do
    db.execute('DELETE FROM todos')
  end

  describe 'POST /api/todos' do
    it 'TODOを作成できること' do
      post '/api/todos', test_todo.to_json, { 'CONTENT_TYPE' => 'application/json' }
      expect(last_response.status).to eq 201
      expect(JSON.parse(last_response.body)).to include('success' => true)
    end

    it '作成したTODOがデータベースに保存されていること' do
      post '/api/todos', test_todo.to_json, { 'CONTENT_TYPE' => 'application/json' }
      todos = db.execute('SELECT title FROM todos')
      expect(todos.first[0]).to eq test_todo[:title]
    end

    it 'タイトルが空の場合はエラーを返すこと' do
      post '/api/todos', { title: '' }.to_json, { 'CONTENT_TYPE' => 'application/json' }
      expect(last_response.status).to eq 400
    end
  end

  describe 'GET /api/todos/:id' do
    let!(:todo_id) do
      db.execute('INSERT INTO todos (title) VALUES (?)', [test_todo[:title]])
      db.last_insert_row_id
    end

    it '指定したIDのTODOを取得できること' do
      get "/api/todos/#{todo_id}"
      expect(last_response.status).to eq 200
      todo = JSON.parse(last_response.body)
      expect(todo['title']).to eq test_todo[:title]
    end

    it '存在しないIDの場合は404エラーを返すこと' do
      get '/api/todos/999999'
      expect(last_response.status).to eq 404
    end
  end

  describe 'PUT /api/todos/:id' do
    let!(:todo_id) do
      db.execute('INSERT INTO todos (title) VALUES (?)', [test_todo[:title]])
      db.last_insert_row_id
    end

    let(:updated_title) { 'Updated TODO' }

    it 'TODOを更新できること' do
      put "/api/todos/#{todo_id}", { title: updated_title }.to_json, { 'CONTENT_TYPE' => 'application/json' }
      expect(last_response.status).to eq 200
      expect(JSON.parse(last_response.body)).to include('success' => true)
    end

    it '更新後のTODOがデータベースに反映されていること' do
      put "/api/todos/#{todo_id}", { title: updated_title }.to_json, { 'CONTENT_TYPE' => 'application/json' }
      updated_todo = db.execute('SELECT title FROM todos WHERE id = ?', [todo_id]).first
      expect(updated_todo[0]).to eq updated_title
    end

    it '存在しないIDの場合は404エラーを返すこと' do
      put '/api/todos/999999', { title: updated_title }.to_json, { 'CONTENT_TYPE' => 'application/json' }
      expect(last_response.status).to eq 404
    end
  end

  describe 'DELETE /api/todos/:id' do
    let!(:todo_id) do
      db.execute('INSERT INTO todos (title) VALUES (?)', [test_todo[:title]])
      db.last_insert_row_id
    end

    it 'TODOを削除できること' do
      delete "/api/todos/#{todo_id}"
      expect(last_response.status).to eq 200
      expect(JSON.parse(last_response.body)).to include('success' => true)
    end

    it '削除後はデータベースから取得できないこと' do
      delete "/api/todos/#{todo_id}"
      remaining_todo = db.execute('SELECT * FROM todos WHERE id = ?', [todo_id])
      expect(remaining_todo).to be_empty
    end

    it '存在しないIDの場合は404エラーを返すこと' do
      delete '/api/todos/999999'
      expect(last_response.status).to eq 404
    end
  end
end 
