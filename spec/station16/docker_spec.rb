require 'net/http'
require 'json'
require 'rspec'

RSpec.describe 'Docker環境でのRubyアプリケーション動作確認' do
  before(:all) do
    # Dockerコンテナを起動
    system('docker-compose up -d')

    # コンテナが起動するのを待つ
    sleep 5
  end

  after(:all) do
    # テスト後にコンテナを停止
    system('docker-compose down')
  end

  it 'Dockerコンテナが起動していること' do
    output = `docker ps`
    expect(output).to include('ruby_app') # コンテナ名が `ruby_app` であることを確認
  end

  it 'アプリケーションが 200 OK を返すこと' do
    uri = URI('http://localhost:4567/')
    response = Net::HTTP.get_response(uri)

    expect(response.code).to eq('200')
  end

  it 'アプリケーションのレスポンスが "Hello, world!" であること' do
    uri = URI('http://localhost:4567/')
    response = Net::HTTP.get(uri)

    expect(response).to eq('Hello, World!')
  end
end
