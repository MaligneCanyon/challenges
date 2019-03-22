# inputs:
# - str (octal value)
# outputs:
# - int (decimal value)
# reqs:
# - convert a str rep of an octal num to a decimal num
# rules:
# - multiply each octal char by 8**(str.size - ndx - 1)
#   where ndx is the char''s l-to-r position in the octal str
#   - ex. 233 # octal
#     = 2*8^2 + 3*8^1 + 3*8^0
#     = 2*64  + 3*8   + 3*1
#     = 128   + 24    + 3
#     = 155
# - valid octal digits are 0..7
# struct:
# - arr
# - num
# algo:
# - split the str into an arr of chars
# - for each char at position ndx
#   - return 0 if char is not in range '0'..'7'
#   - convert the char to an int
#   - mult the int by 8**(str.size - ndx - 1)
#   - map the result back to the arr
# - sum the arr values
# - rtn the sum

class Octal
  def initialize(str)
    @str = str
  end

  def to_decimal
    @str.chars.map.with_index do |char, ndx|
      return 0 unless ('0'..'7').include?(char)
      char.to_i * 8**(@str.size - ndx - 1)
    end.sum
  end
end

p Octal.new('233').to_decimal == 155


require 'minitest/autorun'
# require_relative 'octal'

class OctalTest < Minitest::Test
  def test_octal_1_is_decimal_1
    assert_equal 1, Octal.new('1').to_decimal
  end

  def test_octal_10_is_decimal_8
    # skip
    assert_equal 8, Octal.new('10').to_decimal
  end

  def test_octal_17_is_decimal_15
    # skip
    assert_equal 15, Octal.new('17').to_decimal
  end

  def test_octal_11_is_decimal_9
    # skip
    assert_equal 9, Octal.new('11').to_decimal
  end

  def test_octal_130_is_decimal_88
    # skip
    assert_equal 88, Octal.new('130').to_decimal
  end

  def test_octal_2047_is_decimal_1063
    # skip
    assert_equal 1063, Octal.new('2047').to_decimal
  end

  def test_octal_7777_is_decimal_4095
    # skip
    assert_equal 4095, Octal.new('7777').to_decimal
  end

  def test_octal_1234567_is_decimal_342391
    # skip
    assert_equal 342_391, Octal.new('1234567').to_decimal
  end

  def test_invalid_octal_is_decimal_0
    # skip
    assert_equal 0, Octal.new('carrot').to_decimal
  end

  def test_8_is_seen_as_invalid_and_returns_0
    # skip
    assert_equal 0, Octal.new('8').to_decimal
  end

  def test_9_is_seen_as_invalid_and_returns_0
    # skip
    assert_equal 0, Octal.new('9').to_decimal
  end

  def test_6789_is_seen_as_invalid_and_returns_0
    # skip
    assert_equal 0, Octal.new('6789').to_decimal
  end

  def test_abc1z_is_seen_as_invalid_and_returns_0
    # skip
    assert_equal 0, Octal.new('abc1z').to_decimal
  end

  def test_valid_octal_formatted_string_011_is_decimal_9
    # skip
    assert_equal 9, Octal.new('011').to_decimal
  end
end
