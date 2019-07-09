class RunLengthEncoding

# encode
# ======
# algo:
# - init a counter to 0
# - init a new_str to ''
# - convert the str to an arr of chars
# - for each char in the arr
#   - incr the counter
#   - if we are at the end of the arr or the current char != the next char
#     - if the counter > 1
#       - add the counter value to the new_str
#     - add the char to the new_str
#     - reset the counter to 0
# - rtn the new_str

  def self.encode(str)
    counter = 0
    new_str = ''
    arr = str.chars
    arr.each_with_index do |char, ndx|
      counter += 1
      if ndx + 1 == arr.size || char != arr[ndx + 1]
        new_str << counter.to_s if counter > 1
        new_str << char
        counter = 0
      end
    end
    new_str
  end

# decode
# ======
# rules:
# - encoded nums may be > 1 char in length
# algo:
# - init a new_str to ''
# - init a num_str to ''
# - split the str into an arr of chars
# - for each elem in the arr
#   - if the elem can be converted to an int
#     - save the elem to the num_str
#   - else
#     - convert the num_str to an int
#     - set the num_str to ''
#     - add the char (int times) to the new_str
# - rtn the new_str

  def self.decode(str)
    new_str = ''
    num_str = ''
    str.chars.each do |char|
      if char.to_i.to_s == char # the char is an int
        num_str << char
      else
        int = num_str.empty? ? 1 : num_str.to_i
        num_str = ''
        new_str << char * int
      end
    end
    new_str
  end
end


# Solution
# module RunLengthEncoding
#   def self.encode(input)
#     input.gsub(/(.)\1{1,}/) { |match| match.size.to_s + match[0] }
#   end

#   def self.decode(input)
#     input.gsub(/\d+\D/) { |match| match[-1] * match.to_i }
#   end
# end


require 'minitest/autorun'
# require_relative 'run_length_encoding'

class RunLengthEncodingTest < Minitest::Test
  def test_encode_simple
    # skip
    input = 'AABBBCCCC'
    output = '2A3B4C'
    assert_equal output, RunLengthEncoding.encode(input)
  end

  def test_decode_simple
    # skip
    input = '2A3B4C'
    output = 'AABBBCCCC'
    assert_equal output, RunLengthEncoding.decode(input)
  end

  def test_encode_with_single_values
    # skip
    input = 'WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWB'
    output = '12WB12W3B24WB'
    assert_equal output, RunLengthEncoding.encode(input)
  end

  def test_decode_with_single_values
    # skip
    input = '12WB12W3B24WB'
    output = 'WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWB'
    assert_equal output, RunLengthEncoding.decode(input)
  end

  def test_decode_encode_combination
    # skip
    input = 'zzz ZZ  zZ'
    output = 'zzz ZZ  zZ'
    assert_equal output,
                 RunLengthEncoding.decode(RunLengthEncoding.encode(input))
  end

  def test_encode_unicode
    # skip
    input = '⏰⚽⚽⚽⭐⭐⏰'
    output = '⏰3⚽2⭐⏰'
    assert_equal output, RunLengthEncoding.encode(input)
  end

  def test_decode_unicode
    # skip
    input = '⏰3⚽2⭐⏰'
    output = '⏰⚽⚽⚽⭐⭐⏰'
    assert_equal output, RunLengthEncoding.decode(input)
  end
end
