# for any given char, it will be (x, y)
# for a char at (x, y), it's surronded by (x+1, y-1), (x+1, y), (x+1, y+1), (x, y-1)
# (x, y+1), (x-1, y-1), (x-1, y+1)
require 'pry'
class ValueError < StandardError; end
class Board
  def self.transform(input)
    validate_board(input)
    output = Array.new(input.size) { Array.new(input[0].size) }
    input.each_with_index do |row, x|
      row.chars.each_with_index do |char, y|
        # binding.pry
        if char == " "
          output[x][y] = number_of_surronding_mines(x, y, input).to_s
        else
          output[x][y] = char
        end
        output[x][y] = " " if output[x][y] == "0"
      end
    end
    output.map! { |row| row.join}
  end

  def self.number_of_surronding_mines(x, y, array)
    [array[x+1][y-1], array[x+1][y], array[x+1][y+1], array[x][y-1], array[x][y+1], array[x-1][y], array[x-1][y-1], array[x-1][y+1]].count("*")
  end

  def self.validate_board(board)
    if board.map(&:size).uniq.size !=1
      raise ValueError, 'Input rows has different length.'
    elsif !board[0].match(/\+-*\+/) || !board[-1].match(/\+-*\+/) || !board[1..-2].all? { |row| row.match(/\|(\ |\*)*\|/) }
      raise ValueError, 'Wrong board or invalid chars.'
    end
  end
  
end

#inp = ['+-+', '|*|', '| |', '|*|', '| |', '| |', '+-+']
#inp2 = ['+-----+', '| * * |', '|     |', '|   * |', '|  * *|',
#           '| * * |', '+-----+']

#puts Board.transform(inp)
# puts Board.transform(inp2)