require 'spec_helper'
require 'sqlite3'
require_relative '../../app'
require 'capybara/rspec'

Capybara.app = Sinatra::Application

RSpec.describe 'データベースと接続しよう' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  let(:db_file) { 'db/todos.db' }
  let(:db) { SQLite3::Database.new(db_file) }
  
  describe 'データベースの設定' do
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
    include Capybara::DSL  

    it '/todosにアクセスできること' do
      visit '/todos'  
      expect(page.status_code).to eq 200  
    end

    it 'データベースのTODOが表示されること' do
      visit '/todos'  
      expect(page).to have_content('TechTrain で Ruby を学ぶ')  
      expect(page).to have_content('SQLite の基本を理解する')  
      expect(page).to have_content('TODO アプリを完成させる')  
    end
  end
end 
