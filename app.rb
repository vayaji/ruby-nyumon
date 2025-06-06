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
