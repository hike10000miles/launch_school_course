require 'pry'

class Luhn
  def initialize(numbers)
    @numbers = numbers.to_s.chars.map(&:to_i)
  end

  def addends
    numbers = @numbers.dup
    transform!(numbers)
  end

  def checksum
    addends.reduce(:+)
  end

  def valid?
    self.checksum % 10 == 0 ? true : false
  end

  def self.create(numbers)
    numbers = numbers * 10
    luhn = Luhn.new(numbers)
    luhn.valid? ? numbers : numbers + (10 - luhn.checksum % 10)
  end

  private
    def transform!(array)
      size = array.size
      if size.even?
        index = 0
        while index <= size - 1
          array[index] = array[index] * 2
          index += 2
        end
      elsif size.odd?
        index = 1
        while index <= size - 1
          array[index] = array[index] * 2
          index += 2
        end 
      end
      array.map! { |num| num >= 10 ? num - 9 : num}
      array
    end
end
