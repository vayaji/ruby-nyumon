require 'spec_helper'
require 'sqlite3'
require_relative '../../app'

RSpec.describe 'Station7: データベースセットアップ' do
  describe 'Gemfileの設定' do
    let(:gemfile_content) { File.read('Gemfile') }

    it 'sqlite3のgemが追加されていること' do
      expect(gemfile_content).to match(/gem ['"]sqlite3['"]/)
    end
  end

  describe 'データベースの設定' do
    let(:db_file) { 'db/todos.db' }
    let(:db) { SQLite3::Database.new(db_file) }

    it 'データベースファイルが存在すること' do
      expect(File.exist?(db_file)).to be true
    end

    it 'todosテーブルが存在すること' do
      tables = db.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='todos'")
      expect(tables).not_to be_empty
    end

    it 'todosテーブルが正しい構造であること' do
      table_info = db.table_info('todos')
      columns = table_info.map { |col| col['name'] }
      
      expect(columns).to include('id')
      expect(columns).to include('title')
      expect(columns).to include('created_at')
    end

    it 'サンプルデータが存在すること' do
      todos = db.execute('SELECT title FROM todos')
      expect(todos.size).to be >= 3
      
      sample_titles = [
        "TechTrain で Ruby を学ぶ",
        "SQLite の基本を理解する",
        "TODO アプリを完成させる"
      ]
      
      todos_titles = todos.map(&:first)
      sample_titles.each do |title|
        expect(todos_titles).to include(title)
      end
    end
  end

  describe 'アプリケーションの動作' do
    include Rack::Test::Methods

    def app
      Sinatra::Application
    end

    it '/todosにアクセスできること' do
      get '/todos'
      expect(last_response.status).to eq 200
    end

    it 'データベースのTODOが表示されること' do
      get '/todos'
      expect(last_response.body).to include('TechTrain で Ruby を学ぶ')
      expect(last_response.body).to include('SQLite の基本を理解する')
      expect(last_response.body).to include('TODO アプリを完成させる')
    end

    it '@todosにデータベースの内容が設定されていること' do
      get '/todos'
      todos = last_request.env['sinatra.instance_variables'][:@todos]
      expect(todos).to be_an(Array)
      expect(todos).not_to be_empty
      expect(todos.first).to respond_to(:[])  # 配列またはハッシュのようなアクセスが可能
    end
  end
end 
