require 'pry'
class Robot
  VALID_DIRECTIONS = [:north, :south, :west, :east]
  def initialize
    @direction = :east
    @x = 0
    @y = 0
  end

  def bearing
    @direction
  end

  def orient(direction)
    raise ArgumentError, 'Invalid direction.' if !VALID_DIRECTIONS.include?(direction)
    @direction = direction
  end
  
  def turn_left
    case @direction
    when :east
      @direction = :north
    when :north
      @direction = :west
    when :west
      @direction = :south
    when :south
      @direction = :east
    end
  end

  def turn_right
    case @direction
    when :east
      @direction = :south
    when :south
      @direction = :west
    when :west
      @direction = :north
    when :north
      @direction = :east
    end
  end

  def at(x, y)
    @x = x
    @y = y
  end

  def coordinates
    [@x, @y]
  end

  def advance
    case @direction
    when :north
      @y += 1
    when :south
      @y -= 1
    when :east
      @x += 1
    when :west
      @x -= 1
    end
  end
end

class Simulator
  
  def instructions(commands)
    moves = []
    commands.chars.each do |command|
      moves << :turn_left if command == 'L'
      moves << :turn_right if command == 'R'
      moves << :advance if command == 'A'
    end
    moves
  end

  def place (robot, initial_position = { x: 0, y: 0, direction: :east })
    robot = robot
    robot.at(initial_position.values[0], initial_position.values[1])
    robot.orient(initial_position.values[2])
  end

  def evaluate(robot, commands)
    robot = robot
    commands_array = instructions(commands)
    commands_array.each do |todo|
      # binding.pry
      robot.send(todo)
    end
  end

end
