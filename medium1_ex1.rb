# inputs:
# - int or str
# outputs:
# - arr (of strs)
# reqs:
# - take an int (or a str) as an input
# - rtn an empty arr if the input is invalid
# - otherwise, rtn a list of strs based on the input
# rules:
# - decomposition of input value
#   1 = wink
#   10 = double blink
#   100 = close your eyes
#   1000 = jump
#   10000 = Reverse the order of the operations in the secret handshake.
# - valid input if
#   - decimal and in range 0..31
#   - str and str.size <= 5 and all str chars are '0' or '1'
# struct:
# - str
# algo:
# - define a constant arr w/ the secret cmds
# - init an arr to []
# - if the input is an int
#   - rtn [] unless (0..31).include?(int)
#   - convert the int to a str
# - else
#   - rtn [] if str.size > 5 or str =~ /[^01]/
# - reverse the str
# - for each char in the str
#   - if the char is a '1'
#     - if its the 5th char
#       - reverse the arr
#     - else
#       - add the appropriate sequence to the arr
#         - arr << constant_arr[ndx]
# - rtn the arr

class SecretHandshake
  CMDS = ["wink", "double blink", "close your eyes", "jump"].freeze

  def initialize(value)
    @value = value
  end

  def commands
    if @value.is_a?(Integer)
      return [] unless (0..31).include?(@value)
      str = @value.to_s(2)
    else
      # return [] unless @value.size <= 5 && @value.chars.all? { |char| char =~ /[01]/ }
      return [] if @value.size > 5 || @value =~ /[^01]/
      str = @value
    end

    arr = []
    str.reverse.chars.each_with_index do |char, ndx|
      if char == '1'
        if ndx == 4
          arr.reverse!
        else
          arr << CMDS[ndx]
        end
      end
    end
    arr
  end
end

handshake = SecretHandshake.new 9
p handshake.commands # => ["wink","jump"]

handshake = SecretHandshake.new "11001"
p handshake.commands # => ["jump","wink"]

handshake = SecretHandshake.new "11111111001"
p handshake.commands # => []

handshake = SecretHandshake.new "q2ep1"
p handshake.commands # => []


require 'minitest/autorun'
# require_relative 'secret_handshake'

class SecretHandshakeTest < Minitest::Test
  def test_handshake_1_to_wink
    handshake = SecretHandshake.new(1)
    assert_equal ['wink'], handshake.commands
  end

  def test_handshake_10_to_double_blink
    # skip
    handshake = SecretHandshake.new(2)
    assert_equal ['double blink'], handshake.commands
  end

  def test_handshake_100_to_close_your_eyes
    # skip
    handshake = SecretHandshake.new(4)
    assert_equal ['close your eyes'], handshake.commands
  end

  def test_handshake_1000_to_jump
    # skip
    handshake = SecretHandshake.new(8)
    assert_equal ['jump'], handshake.commands
  end

  def test_handshake_11_to_wink_and_double_blink
    # skip
    handshake = SecretHandshake.new(3)
    assert_equal ['wink', 'double blink'], handshake.commands
  end

  def test_handshake_10011_to_double_blink_and_wink
    # skip
    handshake = SecretHandshake.new(19)
    assert_equal ['double blink', 'wink'], handshake.commands
  end

  def test_handshake_11111_to_double_blink_and_wink
    # skip
    handshake = SecretHandshake.new(31)
    expected = ['jump', 'close your eyes', 'double blink', 'wink']
    assert_equal expected, handshake.commands
  end

  def test_valid_string_input
    # skip
    handshake = SecretHandshake.new('1')
    assert_equal ['wink'], handshake.commands
  end

  def test_invalid_handshake
    # skip
    handshake = SecretHandshake.new('piggies')
    assert_equal [], handshake.commands
  end
end
