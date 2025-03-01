require 'spec_helper'
require_relative '../../app'

RSpec.describe '作成機能を実装しよう', clear_db: true do
  include Rack::Test::Methods
  
  before(:all) do
    start_server
  end

  after(:all) do
    stop_server
  end

  describe 'フォームの確認' do
    before do
      visit '/todos'
    end

    it 'フォームが存在すること' do
      expect(page).to have_selector('form')
      expect(page).to have_selector('form[method="POST"]')
      expect(page).to have_selector('form[action="/todos"]')
    end

    it '入力フィールドが存在すること' do
      expect(page).to have_selector('input[type="text"][name="title"]')
    end

    it '追加ボタンが存在すること' do
      expect(page).to have_selector('input[type="submit"]')
    end
  end

  describe 'TODOの作成' do
    it 'データベースに新しいTODOが保存されること' do
      visit '/todos'
      fill_in 'title', with: 'テストTODO'
      click_button '追加'
      db = SQLite3::Database.new('db/todos.db')
      todos = db.execute('SELECT title FROM todos')
      expect(todos).to include(['テストTODO'])
    end

    it '作成後にトップページにリダイレクトされること' do
      visit '/todos'
      fill_in 'title', with: 'テストTODO'
      click_button '追加'
      expect(current_path).to eq '/todos'
    end

    it '作成したTODOが一覧に表示されること' do
      visit '/todos'
      fill_in 'title', with: 'テストTODO'
      click_button '追加'
      visit '/todos'
      expect(page).to have_content('テストTODO')
    end
  end
end 
