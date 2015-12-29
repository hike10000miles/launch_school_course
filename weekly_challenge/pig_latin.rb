require 'pry'

class PigLatin
  VOWELS = %w(a e i o u)
  CANSONAT = %w(b c d f g h j k l m n o p q r s t v w x y z)
  
  def self.translate(string)
    pig_latin_translation = []
    string.split.each do |word|
      if word[0..1] == 'yt' || word[0..1] == 'xr'
        pig_latin_translation << self.translate_word(word)
      elsif CANSONAT.include?(word[0]) && word[1..2] == 'qu'
        pig_latin_translation << self.translate_word_start_with_a_cansonat_qu(word)
      elsif word[0..1] == 'qu'
        pig_latin_translation << self.translate_word_start_with_qu(word)
      else
        pig_latin_translation << self.normal_translate(word)
      end
    end
    pig_latin_translation.join(" ").to_s
  end

  def self.normal_translate(string)
    case
    when VOWELS.include?(string[0])
      return self.translate_word(string)
    when CANSONAT.include?(string[0]) && VOWELS.include?(string[1])
      return self.translate_word_start_with_a_cansonat(string)
    when CANSONAT.include?(string[0]) && CANSONAT.include?(string[1]) && VOWELS.include?(string[2])
      return self.translate_word_start_with_2_cansonats(string)
    when CANSONAT.include?(string[0]) && CANSONAT.include?(string[1]) && CANSONAT.include?(string[2]) && VOWELS.include?(string[3])
      return self.translate_word_start_with_3_cansonats(string)
    end
  end

  def self.translate_word(string)
    string + 'ay'
  end

  def self.translate_word_start_with_qu(string)
    first_two = string.slice!(0) + string.slice!(0)
    string = string + first_two
    return word = self.translate_word(string)
  end

  def self.translate_word_start_with_a_cansonat_qu(string)
    first_three = string.slice!(0) + string.slice!(0) + string.slice!(0)
    string = string + first_three
    return word = self.translate_word(string)
  end

  def self.translate_word_start_with_a_cansonat(string)
    cansonat = string.slice!(0)
    string = string + cansonat
    return word = self.translate_word(string)
  end

  def self.translate_word_start_with_2_cansonats(string)
    cansonats = string.slice!(0) + string.slice!(0)
    string = string +cansonats
    return word = self.translate_word(string)
  end

  def self.translate_word_start_with_3_cansonats(string)
    cansonats = string.slice!(0) + string.slice!(0) + string.slice!(0)
    string = string +cansonats
    return word = self.translate_word(string)
  end

end
