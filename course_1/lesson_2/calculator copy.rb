# Add a more easy to see pomp.
# Ask for the user's name.
# Greeting the user.
# Ask for the first number.
# Validate the first number.
# Ask again if not validated.
# Ask for the second number.
# Ask again if not validated.
# Ask for the kind of operation the user wants to perform.
# Give result.
# Ask the user if to exit.
require 'yaml'
MESSAGES = YAML.load_file('calculator_messages.yml')
LANGUAGE = 'en'

def messages(message, lang)
  MESSAGES[lang][message]
end

def prompt(message)
  puts "==>#{message}"
end

def integer?(input)
  input.to_i.to_s == input
end

def float?(input)
  input.to_f.to_s == input
end

def validate_num?(input)
  integer?(input) || float?(input)
end

def validate_operation?(num)
  %w(1 2 3 4).include?(num)
end


prompt(messages('welcome', LANGUAGE))
name = ''
loop do
  name = gets.chomp
  if name.empty?
    prompt(messages('valid_name'), LANGUAGE)
  else
    break
  end
end

  prompt("Hello! #{name}")

loop do
  prompt(messages('number_1', LANGUAGE))
  number1 = ''
  loop do
    number1 = gets.chomp
    if validate_num?(number1)
      break
    else
      prompt(messages('valid_number', LANGUAGE))
    end
  end
  prompt(messages('first_number', LANGUAGE))
  prompt("#{number1}.")

  prompt(messages('number_2', LANGUAGE))
  number2 = ''
  loop do
    number2 = gets.chomp
    if validate_num?(number2)
      break
    else
      prompt(messages('valid_number', LANGUAGE))
    end
  end
  prompt(messages('second_number', LANGUAGE))
  prompt("#{number2}.")

  operation_mesaage = <<-MSG
    What kind of operation you want to perform?
    1) Addition
    2) Subtraction
    3) Multiplication
    4) Divition
  MSG

  prompt(operation_mesaage)

  operation = ''
  loop do
    operation = gets.chomp
    if validate_operation?(operation)
      break
    else
      prompt(messages('valid_operation', LANGUAGE))
    end
  end

  result = case operation
           when '1'
             number1.to_i + number2.to_i
           when '2'
             number1.to_i - number2.to_i
           when '3'
             number1.to_i * number2.to_i
           when '4'
             number1.to_f / number2.to_f
           end

  prompt(messages('result', LANGUAGE))
  prompt("#{result}")
  prompt(messages('end', LANGUAGE))
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end
