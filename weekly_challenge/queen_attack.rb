require 'pry'
class Queens
  attr_accessor :white, :black, :board
  def initialize(white: [0, 3], black: [7, 3])
    raise ArgumentError, "queens cannot occupy same space" if white == black
    @board = Array.new(8) { Array.new(8, '_') }
    @white = white
    @black = black
  end

  def to_s
    board[white[0]][white[1]] = "W"
    board[black[0]][black[1]] = "B"
    board.map { |row| row.join(" ").strip }.join("\n").strip
  end
    
  def attack?
    attack_x? || attack_y? || attack_diagonal?
  end

  private
  def attack_x?
    white[0] == black[0]
  end

  def attack_y?
    white[1] == black[1]
  end

  def attack_diagonal?
    (white[0] - black[0]).abs == (white[1] - black[1]).abs
  end
end
