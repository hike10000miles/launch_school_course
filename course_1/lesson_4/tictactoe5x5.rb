require 'pry'

INITIAL_VALUE = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'
WINNING_LINES = [[1, 2, 3, 4, 5], [6, 7, 8, 9, 10], [11, 12, 13, 14, 15], [16, 17, 18, 19, 20], [21, 22, 23, 24, 25]] + # row
                [[1, 6, 11, 16, 21], [2, 7, 12, 17, 22], [3, 6, 9]] + # cols
                [[1, 5, 9], [3, 5, 7]]              # diagonls
FIRST_MOVE = ''

def prompt(msg)
  puts "==>#{msg}"
end

def joinor(array, determiner, word='or')
  array[-1] = "#{word} #{array.last}" if array.size > 1
  array.join(determiner)
end

def display_board(brd)
  system 'clear'
  puts "Board"
  puts "You are #{PLAYER_MARKER}. Computer is #{COMPUTER_MARKER}."
  puts "     |     |     |     |"
  puts "     |     |     |     |"
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}  |  #{brd[4]}  |  #{brd[5]}"
  puts "     |     |     |     |"
  puts "     |     |     |     |"
  puts "-----+-----+-----+-----+-----"
  puts "     |     |     |     |"
  puts "     |     |     |     |"
  puts "  #{brd[6]}  |  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}  |  #{brd[10]}"
  puts "     |     |     |     |"
  puts "     |     |     |     |"
  puts "-----+-----+-----+-----+-----"
  puts "     |     |     |     |"
  puts "     |     |     |     |"
  puts "  #{brd[11]}  |  #{brd[12]}  |  #{brd[13]}  |  #{brd[14]}  |  #{brd[15]}"
  puts "     |     |     |     |"
  puts "     |     |     |     |"
  puts "-----+-----+-----+-----+-----"
  puts "     |     |     |     |"
  puts "     |     |     |     |"
  puts "  #{brd[16]}  |  #{brd[17]}  |  #{brd[18]}  |  #{brd[19]}  |  #{brd[20]}"
  puts "     |     |     |     |"
  puts "     |     |     |     |"
  puts "-----+-----+-----+-----+-----"
  puts "     |     |     |     |"
  puts "     |     |     |     |"
  puts "  #{brd[21]}  |  #{brd[22]}  |  #{brd[23]}  |  #{brd[24]}  |  #{brd[25]}"
  puts "     |     |     |     |"
  puts "     |     |     |     |"
end

def initialize_board
  new_board = {}
  (1..25).each { |num| new_board[num] = ' ' }
  new_board
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == ' ' }
end

def player_move!(brd)
  move = ''
  loop do
    prompt("Your move, choose between squres NO. #{joinor(empty_squares(brd), ', ')}")
    move = gets.chomp.to_i
    break if empty_squares(brd).include?(move)
    prompt("Please choose an avilible squre.")
  end
  brd[move] = PLAYER_MARKER
end

def computer_move!(brd)
  move = nil

  # offense move
  WINNING_LINES.each do |line|
    move = find_at_risk_square(line, brd, COMPUTER_MARKER)
    break if move
  end

  # defense move
  if !move
    WINNING_LINES.each do |line|
      move = find_at_risk_square(line, brd, PLAYER_MARKER)
      break if move
    end
  end

  # take squre 5 if available
  if !move && empty_squares(brd).include?(5)
    move = 5
  end

  # standard move
  if !move
    move = empty_squares(brd).sample
  end

  brd[move] = COMPUTER_MARKER
end

def determine_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 3
      return 'Player'
    elsif brd.values_at(*line).count(COMPUTER_MARKER) == 3
      return 'Computer'
    end
  end
  nil
end

def find_at_risk_square(line, brd, marker)
  if brd.values_at(*line).count(marker) == 2
    return brd.select { |k, v| line.include?(k) && v == INITIAL_VALUE }.keys.first
  end
end

def one_side_won?(brd)
  !!determine_winner(brd)
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def display_score(game_rounds, player_r, computer_r)
  prompt("--------")
  prompt("You played #{game_rounds} games.")
  prompt("You won #{player_r} times.")
  prompt("Computer won #{computer_r} times.")
  if player_r >= 5
    prompt('-----You have won 5 times, you are the winner!-----')
  end
end

def first_player(setting)
  if setting == 'p'
    return 'player'
  elsif setting == 'c'
    return 'computer'
  end
end

def alternate_player(current)
  if current == 'player'
    return 'computer'
  elsif current == 'computer'
    return 'player'
  end
end

def place_piece!(brd, who)
  if who == 'player'
    player_move!(brd)
  elsif who == 'computer'
    computer_move!(brd)
  end
end

rounds = 0
player_won = 0
computer_won = 0

loop do
  board = initialize_board

  loop do
    prompt('Which side do you want to make the first move? Player or Computer?')
    who = gets.chomp
    if who.downcase.start_with?('p')
      FIRST_MOVE = 'p'
      break
    elsif who.downcase.start_with?('c')
      FIRST_MOVE = 'c'
      break
    else
      prompt('Please choose a side to make the first move.')
    end
  end

  current_player = first_player(FIRST_MOVE)

  loop do
    display_board(board)
    place_piece!(board, current_player)
    current_player = alternate_player(current_player)
    break if one_side_won?(board) || board_full?(board)
  end

  display_board(board)
  rounds += 1

  if determine_winner(board) == 'Player'
    player_won += 1
  elsif determine_winner(board) == 'Computer'
    computer_won += 1
  end

  if one_side_won?(board)
    prompt("#{determine_winner(board)} has won!")
    display_score(rounds, player_won, computer_won)
  else
    prompt("It's a tie")
  end

  prompt('Do you want to play again? (y or n)')
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt('Thank you for playing, goodbye!')
