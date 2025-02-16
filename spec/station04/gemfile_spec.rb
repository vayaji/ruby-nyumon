require 'spec_helper'

RSpec.describe 'gem を知ろう' do
  let(:gemfile_path) { File.join(Dir.pwd, 'Gemfile') }
  let(:gemfile_lock_path) { File.join(Dir.pwd, 'Gemfile.lock') }

  describe 'Gemfileの確認' do
    it 'Gemfileが存在すること' do
      expect(File.exist?(gemfile_path)).to be true
    end

    it 'Gemfile内にsinatraのgemが記載されていること' do
      gemfile_content = File.read(gemfile_path)
      expect(gemfile_content).to match(/gem ['"]sinatra['"]/)
    end
  end

  describe 'Gemfile.lockの確認' do
    it 'Gemfile.lockが存在すること' do
      expect(File.exist?(gemfile_lock_path)).to be true
    end

    it 'Gemfile.lockにsinatraが含まれていること' do
      gemfile_lock_content = File.read(gemfile_lock_path)
      expect(gemfile_lock_content).to include('sinatra')
    end
  end
end
