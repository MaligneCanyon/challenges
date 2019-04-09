# number
# ======
# inputs:
# - str
# outputs:
# - str
# reqs:
# - format the input str as a str of 10 digits and rtn the str
# rules:
#     If the phone number is less than 10 digits assume that it is bad number
#     If the phone number is 10 digits assume that it is good
#     If the phone number is 11 digits and the first number is 1, trim the 1 and use the last 10 digits
#     If the phone number is 11 digits and the first number is not 1, then it is a bad number
#     If the phone number is more than 11 digits assume that it is a bad number
# struct:
# - str
# - arr
# algo:
# - split the str into an arr of chars
# - select all alphanumeric chars
# - save the selected chars to the arr
# - if any of the chars are alphabetical or
#   the arr size < 10 or > 11 or
#   the arr size == 11 and the first elem is not a '1'
#   - return '0' * 10
# - else
#   - if the arr size == 11 (the first elem is a '1')
#     - discard the first elem
#   - join the elems to form a new_str
#   - rtn the new_str

class PhoneNumber
  def initialize(str)
    @str = str
  end

  def number
    arr = @str.chars.select { |char| /[0-9a-zA-Z]/ =~ char }
    arr_size = arr.size
    if arr.any? { |char| /[a-zA-Z]/ =~ char } ||
      arr_size < 10 || arr_size > 11 || (arr_size == 11 && arr.first != '1')
      '0' * 10
    else
      arr.shift if arr_size == 11
      arr.join
    end
  end

  def area_code
    self.number[0..2]
  end

  def to_s
    phone = self.number
    format("(%3s) %3s-%4s", phone[0..2], phone[3..5], phone[6..9])
  end
end

# phone_num = PhoneNumber.new('(123) 456-7890')
# p phone_num.number
# p phone_num.area_code
# puts phone_num # calls PhoneNumber.to_s


require 'minitest/autorun'
# require_relative 'phone_number'

class PhoneNumberTest < Minitest::Test
  def test_cleans_number
    # skip
    number = PhoneNumber.new('(123) 456-7890').number
    assert_equal '1234567890', number
  end

  def test_cleans_a_different_number
    # skip
    number = PhoneNumber.new('(987) 654-3210').number
    assert_equal '9876543210', number
  end

  def test_cleans_number_with_dots
    # skip
    number = PhoneNumber.new('456.123.7890').number
    assert_equal '4561237890', number
  end

  def test_invalid_with_letters_in_place_of_numbers
    # skip
    number = PhoneNumber.new('123-abc-1234').number
    assert_equal '0000000000', number
  end

  def test_invalid_when_9_digits
    # skip
    number = PhoneNumber.new('123456789').number
    assert_equal '0000000000', number
  end

  def test_valid_when_11_digits_and_first_is_1
    # skip
    number = PhoneNumber.new('19876543210').number
    assert_equal '9876543210', number
  end

  def test_valid_when_10_digits_and_area_code_starts_with_1
    # skip
    number = PhoneNumber.new('1234567890').number
    assert_equal '1234567890', number
  end

  def test_invalid_when_11_digits
    # skip
    number = PhoneNumber.new('21234567890').number
    assert_equal '0000000000', number
  end

  def test_invalid_when_12_digits_and_first_is_1
    # skip
    number = PhoneNumber.new('112345678901').number
    assert_equal '0000000000', number
  end

  def test_invalid_when_10_digits_with_extra_letters
    # skip
    number = PhoneNumber.new('1a2a3a4a5a6a7a8a9a0a').number
    assert_equal '0000000000', number
  end

  def test_area_code
    # skip
    number = PhoneNumber.new('1234567890')
    assert_equal '123', number.area_code
  end

  def test_different_area_code
    # skip
    number = PhoneNumber.new('9876543210')
    assert_equal '987', number.area_code
  end

  def test_pretty_print
    # skip
    number = PhoneNumber.new('5551234567')
    assert_equal '(555) 123-4567', number.to_s
  end

  def test_pretty_print_with_full_us_phone_number
    # skip
    number = PhoneNumber.new('11234567890')
    assert_equal '(123) 456-7890', number.to_s
  end
end
