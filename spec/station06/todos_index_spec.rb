require 'spec_helper'
require 'capybara/rspec'

require_relative '../../app'

RSpec.describe '一覧画面を作成しよう' do
  def app
    Sinatra::Application
  end

  before(:all) do
    @server_thread = Thread.new { Sinatra::Application.run! host: 'localhost', port: 4567 }
    sleep 2
  end

  after(:all) do
    @server_thread.kill
  end

  describe 'GET /todos' do
    before { visit 'http://localhost:4567/todos' }

    context 'ルーティングとレスポンスの確認' do
      it 'ステータスコード200を返すこと' do
        puts "Response status: #{page.status_code}"  # デバッグ情報
        expect(page.status_code).to eq 200
      end

      it 'HTMLが返されること' do
        puts "Response content type: #{page.response_headers['Content-Type']}"  # デバッグ情報
        expect(page.response_headers['Content-Type']).to include 'text/html'
      end
    end

    context 'ビューの表示確認' do
      let(:todo_items) { page.all('*').map(&:text).map(&:strip).reject(&:empty?) }  # 空の項目を除外

      it 'TODO1が表示されていること' do
        expect(todo_items).to include('TODO1')
      end

      it 'TODO2が表示されていること' do
        expect(todo_items).to include('TODO2')
      end

      it 'TODO3が表示されていること' do
        expect(todo_items).to include('TODO3')
      end
    end
  end
end
