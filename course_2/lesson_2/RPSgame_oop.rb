require 'colorize'

class Player
  attr_accessor :move, :name, :winning, :history
  def initialize
    @winning = 0
    @history = []
    set_name
  end

  def display_history
    puts "#{self.name}' history of move:"
    self.history.each do |move|
      puts "#{move}"
    end
  end
end

class Human < Player
  def set_name
    n = ''
    loop do
      puts 'What is your name?'
      n = gets.chomp
    break unless n.empty?
      puts 'please enter a name.'
    end
    self.name = n
  end

  def choose
    answer = nil
    loop do
      puts 'What is your chooses between rock, paper, scissors, lizard or Spock?'.colorize(:background => :red)
      answer = gets.chomp.downcase
    break if Move::VALUE.include? answer
      puts 'Please choose between rock, paper or scissors.'
    end
    self.move = Move.new(answer)
    self.history << self.move
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'C3P0', 'Fembot', 'EVE', 'Optimus Prime', 'Data', 'Wall E'].sample
  end

  def choose
    self.move = Move.new(Move::VALUE.sample)
    self.history << self.move
  end
end

class Move
  VALUE = ['rock', 'paper', 'scissors', 'lizard', 'spock']
  def initialize(value)
    @value = value
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def scissors?
    @value == 'scissors'
  end

  def lizard?
    @value == 'lizard'
  end

  def spock?
    @value == 'spock'
  end

  def >(other_move)
    (rock? && other_move.scissors?) ||
      (rock? && other_move.lizard?) ||
      (paper? && other_move.rock?) ||
      (paper? && other_move.spock?) ||
      (scissors? && other_move.paper?) ||
      (scissors? && other_move.lizard?) ||
      (lizard? && other_move.paper?) ||
      (lizard? && other_move.spock?) ||
      (spock? && other_move.scissors?) ||
      (spock? && other_move.rock?)
  end

  def <(other_move)
    (rock? && other_move.paper?) ||
      (rock? && other_move.spock?) ||
      (paper? && other_move.scissors?) ||
      (paper? && other_move.lizard?) ||
      (scissors? && other_move.rock?) ||
      (scissors? && other_move.spock?) ||
      (lizard? && other_move.scissors?) ||
      (lizard? && other_move.rock?) ||
      (spock? && other_move.paper?) ||
      (spock? && other_move.lizard?)
  end

  def to_s
    @value
  end
end

class RPSgame
  WINNER_SCORES = 10
  attr_accessor :human, :computer, :rounds, :history

  def initialize
    @human = Human.new
    @computer = Computer.new
    @rounds = 0
    @history = {}
  end

  def display_welcome_message
    puts 'Welcome to the rock, paper, scissors, lizard or Spock game.'
    puts "You are playing against #{computer.name}."
  end

  def display_goodbye_message
    puts 'Thanks for playing the rock, paper, scissors, lizard or Spock game.'
  end

  def display_winner
    if human.move > computer.move
      puts "#{human.name} won."
      human.winning += 1
    elsif human.move < computer.move
      puts "#{computer.name} won."
      computer.winning += 1
    else
      puts 'Tied game!'
    end
  end

  def display_move
    puts '----------------'
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}"   
  end

  def display_score
    puts "You have played #{@rounds} games."
    puts "You won #{human.winning} times."
    puts "#{computer.name} won #{computer.winning} times"
  end

  def winner
    if human.winning == WINNER_SCORES
      return "#{human.name}"
    elsif computer.winning == WINNER_SCORES
      return "#{computer.name}"
    end
  end

  def reach_to_score
    if winner == "#{human.name}"
      puts "You have won 10 games, you are the winner!"
      reset_score
    elsif winner == "#{computer.name}"
      puts "#{computer.name} has won 10 games, #{computer.name} is the winner!"
      reset_score
    end
  end

  def reset_score
    human.winning = 0
    computer.winning = 0
  end

  def play_again?
    answer = nil
    loop do
      puts 'Do you want to play another round? (y/n)'
      answer = gets.chomp
      break if ['y', 'n'].include? answer
      puts 'Please choose between y or n.'
    end
    return true if answer == 'y'
  end

  def play
    display_welcome_message
    loop do
      @rounds += 1
      human.choose
      computer.choose
      display_move
      display_winner
      display_score
      reach_to_score
      human.display_history
      computer.display_history
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSgame.new.play
