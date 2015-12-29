class Octal
  def initialize(octal_num)
    @octal_number = octal_num.chars
  end
  
  def to_decimal
    if valid?
      octal_number = @octal_number.map(&:to_i).dup
      power = octal_number.size - 1
      octal_number.each_index { |i| octal_number[i] *= 8 ** (power - i)}
      octal_number.reduce(:+)
    else
      return 0
    end
  end

  private

  def valid?
    octal_number = @octal_number.dup
    octal_number == octal_number.map(&:to_i).map(&:to_s) &&
    !octal_number.map(&:to_i).any? { |num| num == 8 || num == 9 }
  end
end
