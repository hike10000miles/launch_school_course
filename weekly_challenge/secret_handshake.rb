require 'pry'
class SecretHandshake
  attr_accessor :command_sequence

  ON = 'wink'  # 1
  ONOFF = 'double blink'  #10
  ONOFFOFF = 'close your eyes'  #100
  ONOFFOFFOFF = 'jump' #1000
  # 10000 = Reverse the order of the operations in the secret handshake.

  def initialize(number)
    if number.to_i != number
      @command_sequence = []
    else
      @command_sequence = number.to_s(2)
    end
  end
  
  def commands
    command = @command_sequence.dup
    action = []
    action << ON if command[-1] == '1'
    action << ONOFF if command[-2] == '1'
    action << ONOFFOFF if command[-3] == '1'
    action << ONOFFOFFOFF if command[-4] == '1'
    action.reverse! if command[-5] == '1'
    return action
  end
end

