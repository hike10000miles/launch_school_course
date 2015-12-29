require 'pry'

class Participant
  attr_accessor :cards

  def initialize
    @cards = []
  end

  def total
    value = 0
    @cards.each do |card|
      case card[1]
      when 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
        value += card[1]
      when 'J', 'Q', 'K'
        value += 10
      when 'A'
        if value <= 10
          value += 11
        elsif value > 10
          value += 1
        end
      end
    end
    value
  end
end

class Player < Participant
  attr_accessor :name

  def enter_name
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

class Deck
  SUITS = ['H', 'S', 'C', 'D']
  VALUES = ['A', 2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K']
  attr_accessor :cards
  def initialize
    @cards = SUITS.product(VALUES).shuffle
  end

  def deal
    @cards.pop
  end
end

class Game
  def initialize
    @new_deck = Deck.new
    @player = Player.new
    @dealer = Participant.new
  end

  def play
    welcome
    loop do
      deal_cards
      show_initial_cards
      player_turn
      dealer_turn
      show_result
      puts "Do you want to play again? y or n"
      answer = gets.chomp
      break if answer.downcase.start_with?('n')
      puts "Please enter a valid anser, y to play again, n to exit." unless ['y', 'n'].include? answer
      reset
    end
    goodbye
  end

  private

    def deal_cards
    2.times { @player.cards << @new_deck.deal }
    2.times { @dealer.cards << @new_deck.deal }
  end

  def hit(participant)
    participant.cards << @new_deck.deal
  end

  def busted?(participant)
    participant.total > 21
  end

  def show_initial_cards
    puts "#{@player.name} has #{@player.cards[0][1]} and #{@player.cards[1][1]}."
    puts "The dealer has #{@dealer.cards[0][1]} and an unknown card."
  end

  def dealer_hit?
    @dealer.total < 17
  end

  def player_turn
    puts "#{@player.name}'s turn, you have #{@player.total} point."
    answer = nil
    loop do
      puts "What would you like to do hit or stay"
      answer = gets.chomp.downcase

      break if answer == 'stay' || busted?(@player)

      puts 'Please enter hit or stay!' unless ['hit', 'stay'].include? answer

      if answer == 'hit'
        hit(@player)
        puts "#{@player.name} has #{@player.cards}, total is #{@player.total}."
      end

      if busted?(@player)
        puts "You are busted!"
        break
      end
    end
  end

  def dealer_turn
    puts "The dealer's turn."

    while dealer_hit?
      puts 'The dealer hit.'
      hit(@dealer)
    end

    if busted?(@dealer)
      puts "The dealer is busted."
    end

    puts "The dealer has: #{@dealer.cards}."
    puts "The dealer's turn ends."
  end

  def show_result
    puts "#{@player.name}'s total is #{@player.total}"
    puts "The dealer's total is #{@dealer.total}"
    compare_total
  end

  def compare_total
    if @player.total > @dealer.total && !busted?(@player) && !busted?(@dealer) ||
      busted?(@dealer) && !busted?(@player)
      puts "#{@player.name} won!"
    elsif @player.total < @dealer.total && !busted?(@player) && !busted?(@dealer) ||
      busted?(@player) && !busted?(@dealer)
      puts "The dealer won!"
    else
      puts "Tied game!"
    end
  end

  def reset
    @new_deck = Deck.new
    @player.cards = []
    @dealer.cards = []
  end

  def welcome
    puts 'welcome to the 21 points.'
    @player.enter_name
  end

  def goodbye
    puts 'Thanks for playing, see you next time.'
  end
end

Game.new.play
