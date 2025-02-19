require 'spec_helper'
require 'rack/test'
require 'json'
require_relative '../../app'

RSpec.describe 'API: TODOリスト取得' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  let(:test_todos) do
    [
      'テスト用TODO1',
      'テスト用TODO2',
      'テスト用TODO3'
    ]
  end

  before(:each) do
    test_todos.each do |title|
      DB.execute('INSERT INTO todos (title) VALUES (?)', [title])
    end
  end

  describe 'GET /api/todos' do
    before { get '/api/todos' }

    it 'ステータスコード200を返すこと' do
      expect(last_response.status).to eq 200
    end

    it 'JSON形式でレスポンスが返されること' do
      expect(last_response.content_type).to include('application/json')
    end

    it '全てのTODOが含まれていること' do
      todos = JSON.parse(last_response.body)
      expect(todos.map { |todo| todo[1] }).to match_array(test_todos)
    end
  end
end 
