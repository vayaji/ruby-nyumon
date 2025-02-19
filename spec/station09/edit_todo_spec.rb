require 'spec_helper'
require 'nokogiri'
require_relative '../../app'

RSpec.describe '編集画面を実装しよう' do
  include Capybara::DSL

  let(:test_todo_title) { 'テスト用TODO' }
  before(:each) do
    DB.execute('INSERT INTO todos (title) VALUES (?)', [test_todo_title])
    @todo_id = DB.last_insert_row_id
  end

  describe '編集画面の確認' do
    before { visit "/todos/#{@todo_id}" }

    it '編集画面にアクセスできること' do
       visit "/todos/#{@todo_id}"
      expect(page.status_code).to eq 200
    end

    it '編集フォームが存在すること' do
      visit "/todos/#{@todo_id}"
      expect(page).to have_selector('form')
      expect(page).to have_selector('form[method="POST"]')
      expect(page).to have_selector("form[action='/todos/#{@todo_id}']")
    end

    it '現在のTODOの内容が表示されていること' do
      expect(page.body).to include(test_todo_title)
    end

    it '入力フィールドに現在の値が設定されていること' do
      input_field = find('input[name="title"]')
      expect(input_field.value).to eq(test_todo_title)
    end

    it '戻るリンクが存在すること' do
      expect(page).to have_link('戻る', href: '/todos')
    end
  end
end 
