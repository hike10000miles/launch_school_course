require 'pry'

SUITS = ['H', 'S', 'D', 'C']
VALUES = ['A', 2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K']

def prompt(msg)
  puts "==> #{msg}"
end

def initilize_deck
  new_deck = SUITS.product(VALUES)
  new_deck.shuffle!
end

def first_hand!(deck, player, dealer)
  2.times do
    player << deck.pop
    dealer << deck.pop
  end
end

def total(cards)
  result = 0
  cards.each do |card|
    case card[1]
    when 2, 3, 4, 5, 6, 7, 8, 9, 10
      result += card[1]
    when 'J', 'Q', 'K'
      result += 10
    when 'A'
      if result <= 10
        result += 11
      elsif result > 10
        result += 1
      end
    end
  end
  result
end

def bust?(cards)
  result = total(cards)
  if result > 21
    true
  end
end

def show_cards_player(cards)
  prompt("You have:")
  cards.each do |card|
    prompt("#{card[1]}")
  end
end

def show_cards_dealer(cards)
  prompt('The dealer have:')
  cards.each do |card|
    prompt("#{card[1]}")
  end
end

def check_player?(player)
  if bust?(player)
    prompt('You have more than 21 points, you are busted.')
  end
end

def check_dealer?(dealer)
  if bust?(dealer)
    prompt('The dealer have more than 21 points, the dealer is busted.')
  end
end

def dealer_move!(hand, deck)
  if total(hand) < 17
    prompt('The dealer hits.')
    while total(hand) < 17
      hand << deck.pop
    end
  end
end

def compare(player, dealer)
  if total(player) > total(dealer)
    prompt('The player won!')
  elsif total(player) < total(dealer)
    prompt('The dealer won!')
  else
    prompt('Tied game!')
  end
end

prompt('Welcome to the 21 points!')

loop do
  # Game start
  deck = initilize_deck
  player_cards = []
  dealer_cards = []
  first_hand!(deck, player_cards, dealer_cards)

  prompt("You have #{player_cards[0][1]} and #{player_cards[1][1]}. Your total is #{total(player_cards)}.")
  prompt("The dealer has #{dealer_cards[0][1]} and an unknown card.")
  # Check to see if there is a winner or anyone gets busted.
  check_player?(player_cards)
  check_dealer?(dealer_cards)

  if !bust?(player_cards) && !bust?(dealer_cards)
    # If no one is busted than it's player's term.
    loop do
      prompt("Do you want to hit or stay?")
      answer = gets.chomp
      if answer.downcase.start_with?('h')
        player_cards << deck.pop
        show_cards_player(player_cards)
        prompt("Total: #{total(player_cards)}")
        break if bust?(player_cards)
      elsif answer.downcase.start_with?('s')
        break
      else
        prompt('Please enter hit or stay.')
      end
    end

    check_player?(player_cards)
    # if the player is not busted at the end of the player's term, than it's dealer's term.
    if !bust?(player_cards)
      dealer_move!(dealer_cards, deck)
      check_dealer?(dealer_cards)
    end

    show_cards_dealer(dealer_cards)
    prompt("Your total is #{total(player_cards)}, the dealer's total is #{total(dealer_cards)}")

    if total(player_cards) <= 21 && total(dealer_cards) <= 21
      compare(player_cards, dealer_cards)
    end

  elsif bust?(player_cards) && bust?(dealer_cards)
    prompt('Tied game')
  end

  prompt('Do you want to play another round? (yes or no)')
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt('Thanks for playing.')
