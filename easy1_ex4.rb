# this is the same problem as easy1_ex3, except BASE == 3 here

class Trinary
  BASE = 3

  def initialize(str)
    @str = str
  end

  def to_decimal
    @str.chars.map.with_index do |char, ndx|
      return 0 unless ('0'...BASE.to_s).include?(char)
      char.to_i * BASE**(@str.size - ndx - 1)
    end.sum
  end
end

# "102012"
#     1       0       2       0       1       2    # the number
# 1*3^5 + 0*3^4 + 2*3^3 + 0*3^2 + 1*3^1 + 2*3^0    # the value
#   243 +     0 +    54 +     0 +     3 +     2 =  302
p Trinary.new("102012").to_decimal == 302


require 'minitest/autorun'
# require_relative 'trinary'

class TrinaryTest < Minitest::Test
  def test_trinary_1_is_decimal_1
    # skip
    assert_equal 1, Trinary.new('1').to_decimal
  end

  def test_trinary_2_is_decimal_2
    # skip
    assert_equal 2, Trinary.new('2').to_decimal
  end

  def test_trinary_10_is_decimal_3
    # skip
    assert_equal 3, Trinary.new('10').to_decimal
  end

  def test_trinary_11_is_decimal_4
    # skip
    assert_equal 4, Trinary.new('11').to_decimal
  end

  def test_trinary_100_is_decimal_9
    # skip
    assert_equal 9, Trinary.new('100').to_decimal
  end

  def test_trinary_112_is_decimal_14
    # skip
    assert_equal 14, Trinary.new('112').to_decimal
  end

  def test_trinary_222_is_26
    # skip
    assert_equal 26, Trinary.new('222').to_decimal
  end

  def test_trinary_1122000120_is_32091
    # skip
    assert_equal 32_091, Trinary.new('1122000120').to_decimal
  end

  def test_invalid_trinary_is_decimal_0
    # skip
    assert_equal 0, Trinary.new('carrot').to_decimal
  end

  def test_invalid_trinary_with_digits_is_decimal_0
    # skip
    assert_equal 0, Trinary.new('0a1b2c').to_decimal
  end
end