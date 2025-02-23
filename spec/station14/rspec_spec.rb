require 'spec_helper'
require 'rack/test'
require 'json'
require_relative '../../app'

RSpec.describe 'RSpec を使用してテストを書こう', clear_db: true do
  it 'station14_spec.rbのテストが通ること' do
    expect { load 'spec/station14/station14_spec.rb' }.not_to raise_error
  end
end
