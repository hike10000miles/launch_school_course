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

def monthly_interest_rate(interest)
  interest.to_f / 12
end

def time(years)
  years.to_f * 12
end

def formula1(c, n, l)
  (1 + c)**n * c * l.to_f
end

def formula2(c, n)
  (1 + c)**n - 1
end

def formula3(input, input2)
  input / input2
end

prompt('Welcome to the mortgage calculator!')
prompt('What is your name?')
name = ''
loop do
  name = gets.chomp
  if name.empty?
    prompt('Please enter a valid name!')
  else
    break
  end
end
prompt("Hello #{name}")

loop do
  prompt('What is the APR?')
  apr = ''
  loop do
    apr = gets.chomp
    if validate_num?(apr)
      break
    else
      prompt('Please enter a valid number.')
    end
  end

  prompt('How many years do you plan to pay the mortgage?')
  loan_duration_years = ''
  loop do
    loan_duration_years = gets.chomp
    if validate_num?(loan_duration_years)
      break
    else
      prompt('please enter a valid number.')
    end
  end

  puts "What is the loan amount?"
  loan_amount = ''
  loop do
    loan_amount = gets.chomp
    if validate_num?(loan_amount)
      break
    else
      prompt('please enter a valid number.')
    end
  end

  C = monthly_interest_rate(apr)
  loan_duration_months = time(loan_duration_years)
  x1 = formula1(C, loan_duration_months, loan_amount)
  x2 = formula2(C, loan_duration_months)
  payment = formula3(x1, x2)
  prompt("The monthly payment of this mortgage is #{payment}")
  prompt("Do you want to do another calculation? Y for Yes")
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end
