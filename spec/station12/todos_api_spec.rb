require 'spec_helper'
require 'rack/test'
require 'json'
require_relative '../../app'

RSpec.describe 'Station12: TODOリスト取得API' do
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
    # テストデータの準備
    db.execute('DELETE FROM todos')
    test_todos.each do |title|
      db.execute('INSERT INTO todos (title) VALUES (?)', [title])
    end
  end

  describe 'GET /api/todos' do
    before { get '/api/todos' }

    it 'ステータスコード200を返すこと' do
      expect(last_response.status).to eq 200
    end

    it 'Content-TypeがJSONであること' do
      expect(last_response.content_type).to include('application/json')
    end

    it 'JSONフォーマットで返されること' do
      expect { JSON.parse(last_response.body) }.not_to raise_error
    end

    it '全てのTODOが含まれていること' do
      todos = JSON.parse(last_response.body)
      expect(todos).to be_an(Array)
      expect(todos.size).to eq test_todos.size
      
      todo_titles = todos.map { |todo| todo['title'] }
      test_todos.each do |title|
        expect(todo_titles).to include(title)
      end
    end

    it '各TODOが必要な属性を持っていること' do
      todos = JSON.parse(last_response.body)
      todos.each do |todo|
        expect(todo).to have_key('id')
        expect(todo).to have_key('title')
        expect(todo['id']).to be_an(Integer)
        expect(todo['title']).to be_a(String)
      end
    end
  end
end 
