# frozen_string_literal: true
def foobar(number)
  (1..number).each do |i|
    if (i % 3).zero? && (i % 5).zero?
      puts 'foobar'
    elsif (i % 3).zero?
      puts 'foo'
    elsif (i % 5).zero?
      puts 'bar'
    else
      puts i
    end
  end
end
