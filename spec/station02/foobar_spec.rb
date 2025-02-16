require 'spec_helper'
require_relative '../../foobar.rb'

RSpec.describe 'foobar' do
  describe '#foobar' do
    it '引数に1を渡すと、1が出力されること' do
      expect { foobar(1) }.to output("1\n").to_stdout
    end

    it '引数に3を渡すと、1,2,fooが出力されること' do
      expect { foobar(3) }.to output("1\n2\nfoo\n").to_stdout
    end

    it '引数に5を渡すと、1,2,foo,4,barが出力されること' do
      expect { foobar(5) }.to output("1\n2\nfoo\n4\nbar\n").to_stdout
    end

    it '引数に15を渡すと、3の倍数でfoo、5の倍数でbar、15でfoobarが出力されること' do
      expected_output = "1\n2\nfoo\n4\nbar\nfoo\n7\n8\nfoo\nbar\n11\nfoo\n13\n14\nfoobar\n"
      expect { foobar(15) }.to output(expected_output).to_stdout
    end

    it '引数が0以下の場合は何も出力されないこと' do
      expect { foobar(0) }.to output("").to_stdout
      expect { foobar(-1) }.to output("").to_stdout
    end
  end
end
