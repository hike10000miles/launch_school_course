VALID_CHOICES = { 'r' => 'rock', 'p' => 'paper', 's' => 'sciss', 'l' => 'lizard', 'sp' => 'Spock' }

def prompt(message)
  puts "==>#{message}"
end

def win?(first, second)
  (first == 'r' && second == 's') ||
  (first == 'r' && second == 'l') ||
  (first == 'p' && second == 'r') ||
  (first == 'p' && second == 'sp') ||
  (first == 's' && second == 'p') ||
  (first == 's' && second == 'l') ||
  (first == 'sp' && second == 'r') ||
  (first == 'sp' && second == 's') ||
  (first == 'l' && second == 'p') ||
  (first == 'l' && second == 'sp')
end

def display_results(rounds, player_win, computer_win, tied)
  prompt('The score:')
  prompt('----------')
  prompt("Total rounds played: #{rounds}.")
  prompt("You won: #{player_win}")
  prompt("The computer won: #{computer_win}")
  prompt("Tied rounds: #{tied}")
end

def winner(player_win, computer_win)
  if player_win >= 5
    prompt("****You won 5 rounds! You are the winner!****")
  elsif computer_win >= 5
    prompt("****Computer win 5 rounds! Computer is the winner!****")
  end
end

prompt('Welcome to the rock paper scissor lizard and Spock, you are playing against the computer!')

game_rounds = 0
player_winning_rounds = 0
computer_winning_rounds = 0
tied_rounds = 0

loop do
  player = ''
  computer = ''
  prompt("What is your choice between rock(r), paper(p), sciss(s), lizard or Spock(sp). Enter r, p, s, l or sp")

  loop do
    player = gets.chomp
    if VALID_CHOICES.keys.include?(player)
      break
    else
      prompt('That is not a valid choice!')
    end
  end

  computer = VALID_CHOICES.keys.sample

  prompt("Your choice is #{player}, the computer choose #{computer}.")

  if win?(player, computer)
    prompt('You won this round!')
    game_rounds += 1
    player_winning_rounds += 1
  elsif win?(computer, player)
    prompt('You lost!')
    game_rounds += 1
    computer_winning_rounds += 1
  else
    prompt('Tied game!')
    tied_rounds += 1
  end
 
  display_results(game_rounds, player_winning_rounds, computer_winning_rounds, tied_rounds)
  winner(player_winning_rounds, computer_winning_rounds)

  prompt('Do you want to play another round? Y for yes.')
  answer = gets.chomp
  if answer.downcase.start_with?('y')
    if player_winning_rounds >= 5 || computer_winning_rounds >= 5
      player_winning_rounds = 0
      computer_winning_rounds = 0
      tied_rounds = 0
    end
  else
    break
  end
end

