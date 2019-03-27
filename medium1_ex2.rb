# The Luhn formula is a simple checksum formula used to validate a variety of identification numbers, such
# as credit card numbers and Canadian Social Insurance Numbers.

# The formula verifies a number against its included check digit, which is usually appended to a partial
# number to generate the full number. This number must pass the following test:

#     Counting from rightmost digit (which is the check digit) and moving left, double the value of every
#     second digit.
#     For any digits that thus become 10 or more, subtract 9 from the result.
#         1111 becomes 2121.
#         8763 becomes 7733 (from 2×6=12 → 12-9=3 and 2×8=16 → 16-9=7).
#     Add all these digits together.
#         1111 becomes 2121 sums as 2+1+2+1 to give a checksum of 6.
#         8763 becomes 7733, and 7+7+3+3 is 20.

# If the total (the checksum) ends in 0 (put another way, if the total modulus 10 is congruent to 0),
# then the number is valid according to the Luhn formula; else it is not valid. So, 1111 is not valid
# (as shown above, it comes out to 6), while 8763 is valid (as shown above, it comes out to 20).

# Write a program that, given a number

#     Can check if it is valid per the Luhn formula. This should treat, for example, "2323 2005 7766 3554"
#     as valid.
#     Can return the checksum, or the remainder from using the Luhn method.
#     Can add a check digit to make the number valid per the Luhn formula and return the original number
#     plus that digit. This should give "2323 2005 7766 3554" in response to "2323 2005 7766 355".


# addends
# -------
# inputs:
# - int
# outputs:
# - arr (of ints)
# reqs:
# - given an int
# - modify the digits by (starting from the right)
#   - dbling every 2nd digit
#   - subtracting 9 from the result if the result is > 9
# - rtn an arr, consisting of the modified digits
# rules:
# - none
# struct:
# - arr
# algo:
# - convert the int to a str
# - reverse the str
# - split the str into an arr of chars
# - for each char in the arr
#   - convert the char back to a digit
#   - dble every 2nd digit
#   - subt 9 from the result if it is > 9
# - reverse the arr
# - rtn the arr


# create
# ------
# inputs:
# - int
# outputs:
# - int
# reqs:
# - for a given int, rtn a valid Luhn num
# rules:
# - remainder = 10 - checksum % 10
# struct:
# - numeric
# algo:
# - call Luhn::new on the input num
# - if the resulting luhn is not a valid Luhn
#   - append a 0 to the num
#     - num *= 10
#   - call Luhn::new on the revised num
#   - calc the checksum for the new luhn
#   - calc the chk_digit reqd to make the new luhn a valid Luhn
#   - replace the last digit of the num (a '0') with the chk_digit
#     - num += chk_digit
# - rtn the num


class Luhn
  def initialize(num)
    @num = num
  end

  def addends
    @num.to_s.reverse.chars.map.with_index do |char, ndx|
      digit = char.to_i
      digit *= 2 if ndx.odd?
      digit -= 9 if digit > 9
      digit
    end.reverse
  end

  def checksum
    self.addends.sum
  end

  def valid?
    (self.checksum % 10).zero?
  end

  def self.create(num)
    luhn = Luhn.new(num)
    unless luhn.valid?
      num *= 10
      luhn = Luhn.new(num)
      chk_digit = luhn.checksum % 10
      chk_digit = 10 - chk_digit unless chk_digit.zero?
      num += chk_digit
    end
    num
  end
end

# p Luhn.new(2323_2005_7766_355).addends
# p Luhn.new(2323_2005_7766_355).checksum
# p Luhn.new(2323_2005_7766_3554).valid?
# p Luhn.create(2323_2005_7766_355)

# p Luhn.new(123).addends
# p Luhn.new(123).checksum
# p Luhn.new(123).valid?
# p Luhn.create(123)


require 'minitest/autorun'
# require_relative 'luhn'

class LuhnTest < Minitest::Test
  def test_addends
    luhn = Luhn.new(12_121)
    assert_equal [1, 4, 1, 4, 1], luhn.addends
  end

  def test_too_large_addend
    # skip
    luhn = Luhn.new(8631)
    assert_equal [7, 6, 6, 1], luhn.addends
  end

  def test_checksum
    # skip
    luhn = Luhn.new(4913)
    assert_equal 22, luhn.checksum
  end

  def test_checksum_again
    # skip
    luhn = Luhn.new(201_773)
    assert_equal 21, luhn.checksum
  end

  def test_invalid_number
    # skip
    luhn = Luhn.new(738)
    refute luhn.valid?
  end

  def test_valid_number
    # skip
    luhn = Luhn.new(8_739_567)
    assert luhn.valid?
  end

  def test_create_valid_number
    # skip
    number = Luhn.create(123)
    assert_equal 1230, number
  end

  def test_create_other_valid_number
    # skip
    number = Luhn.create(873_956)
    assert_equal 8_739_567, number
  end

  def test_create_yet_another_valid_number
    # skip
    number = Luhn.create(837_263_756)
    assert_equal 8_372_637_564, number
  end
end
