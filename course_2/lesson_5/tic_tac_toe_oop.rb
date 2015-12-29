require 'pry'

class Board
  attr_reader :squares
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                  [[1, 5, 9], [3, 5, 7]] # diagonals
  def initialize
    @squares = {}
    reset
  end

  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end

  def []=(key, marker)
    @squares[key].marker = marker
  end

  def unmarked_square_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def at_risk_line
    squares_with_two_identical_markers = []
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if two_identical_markers?(squares)
        squares_with_two_identical_markers << squares
      end
    end
    squares_with_two_identical_markers.first
  end

  def at_risk_square
    line = at_risk_line
    square = line.select { |s| s.marker == Square::INITIAL_MARKER }
    @squares.select { |_, v| v == square[0] }
  end

  def full?
    unmarked_square_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  def two_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 2
    markers.min == markers.max
  end

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end
end

class Square
  INITIAL_MARKER = " "
  attr_accessor :marker
  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def to_s
    @marker
  end

  def marked?
    marker != INITIAL_MARKER
  end
end

class Player
  attr_accessor :winning, :marker, :name
  def initialize(marker)
    @marker = marker
    @winning = 0
  end

  def computer_name
    @name = ['R2D2', 'C3P0', 'Fembot', 'EVE', 'Optimus Prime', 'Data', 'Wall E'].sample
  end

  def human_name
    name = nil
    loop do
      puts 'Please enter your name.'
      name = gets.chomp
      break unless name.empty?
      puts 'You did not enter anything, it\'s empty.' 
    end
    @name = name
  end
end

class TTTGame
  DEFAULT_MARKER = 'X'
  COMPUTER_MARKER = 'O'
  FIRST_TO_MOVE = DEFAULT_MARKER

  attr_accessor :board

  def initialize
    @board = Board.new
    @human = Player.new(DEFAULT_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
    @current_marker = FIRST_TO_MOVE
    @rounds = 0
  end

  def play
    display_welcome_message
    set_name
    change_human_marker
    loop do
      @rounds += 1
      display_board
      loop do
        human_moves
        break if board.someone_won? || board.full?
        computer_moves
        clear_screen_and_display_board
        break if board.someone_won? || board.full?
      end
      display_result
      big_winner_message
      break unless play_again?
      reset
    end
    display_goodbye_message
  end

  private

  def system_clear
    system 'clear'
  end

  def display_welcome_message
    puts "Welcome to the Tic Tac Toe game."
  end

  def display_board
    puts "#{@human.name} are #{@human.marker}, #{@computer.name} is #{@computer.marker}."
    puts ""
    board.draw
    puts ""
  end

  def clear_screen_and_display_board
    system_clear
    display_board
  end

  def display_result
    display_board
    case board.winning_marker
    when @human.marker
      @human.winning += 1
      puts "You won!"
    when TTTGame::COMPUTER_MARKER
      @computer.winning += 1
      puts "The computer won!"
    end
    puts '----------'
    puts "#{@human.name} played #{@rounds}."
    puts "#{@human.name} won #{@human.winning}."
    puts "#{@computer.name} won #{@computer.winning}."
  end

  def play_again?
    answer = nil
    loop do
      puts "Do you want to play agian? (y or n)"
      answer = gets.chomp
      break if %w(y n).include? answer
      puts "Please enter y or n."
    end
    answer == 'y'
  end

  def display_goodbye_message
    puts "Thanks for playing the game, see you next time!"
  end

  def human_moves
    puts "Chose a square: #{board.unmarked_square_keys.join(', ')}"
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_square_keys.include?(square)
      puts "Please choose #{board.unmarked_square_keys.join(', ')}."
    end
    board[square] = @human.marker
  end

  def computer_moves
    if board.at_risk_line
      # smart move
      board[board.at_risk_square.keys[0]] = @computer.marker
    else
      # standard move
      board[board.unmarked_square_keys.sample] = @computer.marker
    end
  end

  def current_player_move
    if @current_marker == HUMAN_MARKER
      human_moves
      @current_marker = COMPUTER_MARKER
    else
      computer_moves
      @current_marker = HUMAN_MARKER
    end
  end

  def big_winner_marker
    return HUMAN_MARKER if @human.winning == 5
    return COMPUTER_MARKER if @computer.winning == 5
  end

  def reset_points
    @human.winning = 0
    @computer.winning = 0
    @rounds = 0
  end

  def big_winner_message
    case big_winner_marker
    when HUMAN_MARKER
      puts "#{@human.name} won 5 games, #{@human.name} are the big winner!"
      reset_points
    when COMPUTER_MARKER
      puts "#{@computer.name} won 5 games, #{@computer.name} is the big winner!"
      reset_points
    end
  end

  def change_human_marker
    marker = DEFAULT_MARKER
    loop do
      puts "Your default marker if #{DEFAULT_MARKER}, do you want to change it? (y or n)"
      answer = gets.chomp

      if answer.downcase == 'n'
        break
      elsif answer.downcase == 'y'
        loop do
          puts 'You can choose your own marker from typing a letter, number or symbel.'
          marker = gets.chomp
          break if marker.size == 1
          puts 'Please enter just one letter, number or symbel.'
        end
        break
      else
        puts 'Please enter just one letter, number or symbel.'
      end

      puts 'Please enter y or n.'
      
    end
    @human.marker = marker.upcase
  end

  def set_name
    @computer.computer_name
    @human.human_name
  end

  def reset
    board.reset
    system_clear
    @current_marker = FIRST_TO_MOVE
    puts "Let's play again!"
    puts " "
  end
end

game = TTTGame.new
game.play
