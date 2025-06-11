require 'spec_helper'
require 'rack/test'
require 'json'
require_relative '../../app'

RSpec.describe 'API: TODOリスト操作', clear_db: true do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

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

      expect(last_response.status).to eq(200)

      response_body = JSON.parse(last_response.body)
      expect(response_body).to be_an(Array)

      expect(response_body.length).to eq(3)
      expect(response_body[0]).to eq(todo_id)
      expect(response_body[1]).to eq(test_todo[:title])
    end
  end
end
