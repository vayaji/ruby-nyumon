require 'spec_helper'
require 'rack/test'
require 'nokogiri'
require_relative '../../app'

RSpec.describe 'Station6: TODOリスト一覧表示機能' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe 'GET /todos' do
    before do
      get '/todos'
    end

    context 'ルーティングとレスポンスの確認' do
      it 'ステータスコード200を返すこと' do
        expect(last_response.status).to eq 200
      end

      it 'HTMLが返されること' do
        expect(last_response.content_type).to include 'text/html'
      end
    end

    context 'ビューの表示確認' do
      let(:doc) { Nokogiri::HTML(last_response.body) }
      let(:todo_items) { doc.css('li').map(&:text).map(&:strip) }

      it '3つのTODO項目が表示されていること' do
        expect(todo_items.size).to eq 3
      end

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

    context '@todosの確認' do
      it '@todosが配列であること' do
        # アプリケーション内の@todosを取得するためのヘルパーメソッド
        def get_instance_variable(name)
          last_request.env['sinatra.instance_variables'][name]
        end
        
        todos = get_instance_variable(:@todos)
        expect(todos).to be_an(Array)
        expect(todos).to eq(['TODO1', 'TODO2', 'TODO3'])
      end
    end
  end

  describe 'ビューファイルの存在確認' do
    it 'views/todos.erbが存在すること' do
      expect(File.exist?('views/todos.erb')).to be true
    end
  end
end
