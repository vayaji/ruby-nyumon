require 'sinatra'
require 'sinatra/reloader' if development?
require './db/todos'

get '/' do
  'Hello, World!'
end

get '/todos' do
  @todos = DB.execute('SELECT * FROM todos')
  erb :todos
end

post '/todos' do
  DB.execute('INSERT INTO todos (title) VALUES (?)', params[:title])
  redirect '/'
end

get '/todos/:id/edit' do
  @todo = DB.execute('SELECT * FROM todos WHERE id = ?', params[:id]).first
  halt 404, 'Todo not found!' unless @todo
  erb :edit
end

put '/todos/:id' do
  DB.execute('UPDATE todos SET title = ? WHERE id = ?', [params[:title], params[:id]])
  redirect '/todos'
end

delete '/todos/:id' do
  DB.execute('DELETE FROM todos WHERE id = ?', params[:id])
  redirect '/todos'
end

# api

get '/api/todos' do
  content_type :json
  todos = DB.execute('SELECT * FROM todos')
  JSON.pretty_generate(todos)
end

post '/api/todos' do
  content_type :json

  DB.execute('INSERT INTO todos (title) VALUES (?)', params[:title])

  id = DB.execute('SELECT last_insert_rowid()')[0][0]

  todo = DB.execute('SELECT * FROM todos WHERE id = ?', id).first

  JSON.pretty_generate(todo)
end

get '/api/todos/:id' do
  content_type :json
  todo = DB.execute('SELECT * FROM todos WHERE id = ?', params[:id]).first
  halt 404, JSON.pretty_generate({ error: 'Todo not found!' }) unless todo
  JSON.pretty_generate(todo)
end

put '/api/todos/:id' do
  content_type :json

  DB.execute('UPDATE todos SET title = ? WHERE id = ?', [params[:title], params[:id]])

  todo = DB.execute('SELECT * FROM todos WHERE id = ?', params[:id]).first
  halt 404, JSON.pretty_generate({ error: 'Todo not found!' }) unless todo

  JSON.pretty_generate(todo)
end

delete '/api/todos/:id' do
  content_type :json

  DB.execute('DELETE FROM todos WHERE id = ?', params[:id])

  { message: 'TODO deleted' }.to_json
end
