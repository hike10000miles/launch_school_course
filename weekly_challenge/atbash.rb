class Atbash
  BEFORE = ('a'..'z').to_a
  AFTER = ('a'..'z').to_a.reverse
  def self.encode(string)
    new_array = []
    string.downcase.chars.delete_if { |char| char == ' ' }.each do |char|
      if !char.match(/\d|\W/)
        new_array << AFTER.at(BEFORE.index(char))
      else
        new_array << char
      end
    end
    new_array.reject! { |char| char.match(/\W/) }
    if !new_array.size > 5
      new_array.join
    else
      new_array.join.scan(/.{1,5}/).join(' ')
    end
  end
end
