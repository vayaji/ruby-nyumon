require 'spec_helper'
require 'nokogiri'
require_relative '../../app'

RSpec.describe '編集機能を実装しよう', clear_db: true do
  let(:test_todo_title) { 'テスト用TODO' }
  let(:updated_title) { '更新後のTODO' }
  before(:each) do
    DB.execute('INSERT INTO todos (title) VALUES (?)', [test_todo_title])
    @todo_id = DB.last_insert_row_id
  end


  it 'PUTリクエストでTODOを更新できること' do
    visit "/todos/#{@todo_id}/edit"
    fill_in 'title', with: updated_title
    click_button '更新'
    expect(current_path).to eq('/todos')
  end

  it 'データベースの内容が更新されていること' do
    visit "/todos/#{@todo_id}/edit"
    fill_in 'title', with: updated_title
    click_button '更新'
    updated_todo = DB.execute('SELECT title FROM todos WHERE id = ?', [@todo_id]).first
    expect(updated_todo[0]).to eq(updated_title)
  end

  it '更新後に一覧画面にリダイレクトされること' do
    visit "/todos/#{@todo_id}/edit"
    fill_in 'title', with: updated_title
    click_button '更新'
    expect(current_path).to eq('/todos')
  end

  it '更新されたTODOが一覧に表示されること' do
    visit "/todos/#{@todo_id}/edit"
    fill_in 'title', with: updated_title
    click_button '更新'
    visit '/todos'
    expect(page).to have_content(updated_title)
  end
end 
