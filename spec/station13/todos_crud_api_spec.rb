require 'spec_helper'
require 'rack/test'
require 'json'
require_relative '../../app'

RSpec.describe 'API: TODOリスト操作', clear_db: true do
  include Rack::Test::Methods

  before(:all) do
    start_server
  end

  after(:all) do
    stop_server
  end

  let(:test_todo) { { title: 'テスト用TODO' } }
  let!(:todo_id) do
    DB.execute('INSERT INTO todos (title) VALUES (?)', [test_todo[:title]])
    DB.last_insert_row_id
  end

  describe 'GET /api/todos/:id' do
    it '指定したIDのTODOを取得できること' do
      get "/api/todos/#{todo_id}"
      expect(last_response.status).to eq 200
      todo = JSON.parse(last_response.body)
      expect(todo[1]).to eq(test_todo[:title])  # TODOのタイトルが表示されること
    end
  end

  describe 'POST /api/todos' do
    it '新しいTODOを作成できること' do
      post '/api/todos', test_todo
      expect(last_response.status).to eq 200
      created_todo = JSON.parse(last_response.body)
      expect(created_todo[1]).to eq(test_todo[:title])  # 作成したTODOが表示されること
    end
  end

  describe 'PUT /api/todos/:id' do
    it 'TODOを更新できること' do
      params = { id: test_todo[:id], title: '更新されたTODO' }
      put "/api/todos/#{todo_id}", params
      expect(last_response.status).to eq 200
      updated_response = JSON.parse(last_response.body)
      expect(updated_response[1]).to eq('更新されたTODO')  # 更新したTODOが表示されること
    end
  end

  describe 'DELETE /api/todos/:id' do
    it 'TODOを削除できること' do
      delete "/api/todos/#{todo_id}"
      expect(last_response.status).to eq 200
      response = JSON.parse(last_response.body)
      expect(response['message']).to eq('TODO deleted')  # 削除メッセージが表示されること
    end
  end
end
