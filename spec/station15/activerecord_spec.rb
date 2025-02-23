require 'spec_helper'
require 'yaml'

RSpec.describe 'Active Record を使ってみよう', clear_db: true do
  describe 'Gemfileの設定' do
    let(:gemfile_content) { File.read('Gemfile') }

    it '必要なGemが追加されていること' do
      expect(gemfile_content).to include('sinatra-activerecord')
      expect(gemfile_content).to include('rake')
    end
  end

  describe 'データベース設定' do
    let(:database_config_path) { 'config/database.yml' }
    
    it 'database.ymlが存在すること' do
      expect(File.exist?(database_config_path)).to be true
    end

    it '正しい環境設定が含まれていること' do
      config = YAML.load_file(database_config_path)
      
      ['development', 'test', 'production'].each do |env|
        expect(config[env]).to include(
          'adapter' => 'sqlite3',
          'pool' => 5,
          'timeout' => 5000
        )
        expect(config[env]['database']).to include("#{env}.sqlite3")
      end
    end
  end

  describe 'モデルの実装' do
    let(:model_path) { 'models/todo.rb' }
    
    it 'Todoモデルが存在すること' do
      expect(File.exist?(model_path)).to be true
    end

    it 'ActiveRecord::Baseを継承していること' do
      model_content = File.read(model_path)
      expect(model_content).to match(/class Todo < ActiveRecord::Base/)
    end

    it 'バリデーションが設定されていること' do
      model_content = File.read(model_path)
      expect(model_content).to include('validates :title, presence: true')
    end
  end

  describe 'マイグレーションファイル' do
    let(:migration_files) { Dir.glob('db/migrate/*_create_todos.rb') }
    
    it 'マイグレーションファイルが存在すること' do
      expect(migration_files).not_to be_empty
    end
  end

  describe 'アプリケーションの設定' do
    let(:app_content) { File.read('app.rb') }

    it '必要なライブラリが読み込まれていること' do
      expect(app_content).to include("require 'sinatra/activerecord'")
      expect(app_content).to include("require './models/todo'")
    end
  end

  describe 'データベースの存在確認' do
    it '開発用データベースが作成されていること' do
      expect(File.exist?('db/development.sqlite3')).to be true
    end

    it 'テスト用データベースが作成されていること' do
      expect(File.exist?('db/test.sqlite3')).to be true
    end
  end
end
