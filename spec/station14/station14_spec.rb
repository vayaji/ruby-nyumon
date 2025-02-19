require 'spec_helper'
require 'rack/test'
require 'json'
require_relative '../../app'

RSpec.describe 'API: TODOリスト操作' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  let(:test_todo) { { title: 'テスト用TODO' } }
  let!(:todo_id) do
    DB.execute('INSERT INTO todos (title) VALUES (?)', [test_todo[:title]])
    DB.last_insert_row_id
  end

  describe 'GET /api/todos/:id' do
    it '指定したIDのTODOを取得できること' do
      # ここにテストを書く
    end
  end
end
