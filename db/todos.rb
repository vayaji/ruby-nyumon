# frozen_string_literal: true

require 'sqlite3'

DB_PATHS = {
  'development' => 'db/development.sqlite3',
  'test' => 'db/test.sqlite3',
}.freeze
ENV['RACK_ENV'] ||= 'development'
DB = SQLite3::Database.new(DB_PATHS[ENV['RACK_ENV']])

DB.execute <<-SQL
  CREATE TABLE IF NOT EXISTS todos (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP
  );
SQL

if DB.execute('SELECT COUNT(*) FROM todos').first.first.zero?
  sample_todos = [
    'TechTrain で Ruby を学ぶ',
    'SQLite の基本を理解する',
    'TODO アプリを完成させる'
  ]
  sample_todos.each do |title|
    DB.execute('INSERT INTO todos (title) VALUES (?)', title)
  end
end
