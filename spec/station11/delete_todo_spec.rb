require 'spec_helper'
require 'capybara/rspec'
require_relative '../../app'

RSpec.describe 'Station11: TODOの削除機能', clear_db: true do
  let(:test_todo_title) { 'テスト用TODO' }
  let(:todo_id) { nil }

  before(:each) do
    DB.execute('DELETE FROM todos')
    DB.execute('INSERT INTO todos (title) VALUES (?)', [test_todo_title])
    @todo_id = DB.last_insert_row_id
  end

  describe '削除フォームの確認' do
    before { visit "/todos/#{@todo_id}/edit" }

    it '削除フォームが存在すること' do
      expect(page).to have_selector("form[action='/todos/#{@todo_id}']")
      expect(page).to have_selector("form[method='POST']")
      expect(page).to have_selector("input[type='submit'][value='削除']")
    end
  end

  describe 'TODOの削除' do
    it 'DELETEリクエストでTODOを削除できること' do
      visit "/todos/#{@todo_id}/edit"
      click_button '削除'
      expect(current_path).to eq('/todos')
    end

    it 'データベースから該当のTODOが削除されていること' do
      visit "/todos/#{@todo_id}/edit"
      click_button '削除'
      result = DB.execute('SELECT * FROM todos WHERE id = ?', [@todo_id])
      expect(result).to be_empty
    end

    it '削除後に一覧画面にリダイレクトされること' do
      visit "/todos/#{@todo_id}/edit"
      click_button '削除'
      expect(current_path).to eq('/todos')
    end

    it '削除されたTODOが一覧に表示されないこと' do
      visit "/todos/#{@todo_id}/edit"
      click_button '削除'
      visit '/todos'
      expect(page).not_to have_content(test_todo_title)
    end
  end
end 
