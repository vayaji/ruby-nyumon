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
