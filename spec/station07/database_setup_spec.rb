require 'spec_helper'
require 'sqlite3'
require_relative '../../app'
require 'capybara/rspec'
require 'rack/test'

RSpec.describe 'データベースと接続しよう', clear_db: true do
  include Rack::Test::Methods
  include Capybara::DSL

  def app
    Sinatra::Application
  end

  describe 'データベースの設定' do
    it 'todosテーブルが存在すること' do
      tables = DB.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='todos'")
      expect(tables).not_to be_empty
    end

    it 'todosテーブルが正しい構造であること' do
      table_info = DB.table_info('todos')
      columns = table_info.map { |col| col['name'] }

      expect(columns).to include('id')
      expect(columns).to include('title')
      expect(columns).to include('created_at')
    end

    it 'サンプルデータが存在すること' do
      todos = DB.execute('SELECT title FROM todos')
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
    
    before(:all) do
      start_server
    end

    after(:all) do
      stop_server
    end
    
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
