class Series
  def initialize(numbers)
    @numbers = numbers.chars.map(&:to_i)
  end
  
  def slices(n)
    fail ArgumentError, "Slice is longer than the number" if @numbers.size < n
    numbers_array = @numbers.dup
    numbers_array.each_cons(n).to_a
  end
  
end

