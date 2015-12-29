class Sieve 
  attr_accessor :numbers, :primes
  def initialize(limit)
    @numbers = (2..limit).to_a
    @primes = get_all_primes
  end
  
  private
  def get_all_primes
    all_numbers = @numbers
    all_numbers.each do |numbers|
      all_numbers.reject! { |num| num % numbers == 0 && !(num / numbers == 1)}
    end
    all_numbers
  end
  
end
