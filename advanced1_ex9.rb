class RailFenceCipher

# encode
# ======
# inputs:
# - str (to encode)
# - int (num of rails)
# outputs:
# - str (encoded)
# reqs:
# - encode a str
# rules:
# - none
# struct:
# - arr (w/ str elems for each rail)
# algo:
# - create an arr w/ 'rails' empty strs
# - set a flag to indicate whether we are moving down or up between rails
# - init an ndx to 0
# - for each char in the decoded str
#   - copy the char to the str elem at the current ndx
#   - if the num of rails is > 1
#     - if we are moving down
#       - incr the ndx
#     - else
#       - decr the ndx
#     - if the ndx is now pointing to the last or the first rail
#       - flip the value of the flag (so that we can move in the other dir)
# - join the encoded str elems to form a newstr
# - rtn the (encoded) newstr

  def self.encode(str, rails)
    # puts
    @@arr = Array.new(rails) { '' }
    # p @@arr

    # moving_down = true
    # ndx = 0
    # str.each_char do |char|
    #   # p "char == #{char}, ndx == #{ndx}, moving_down == #{moving_down}"
    #   @@arr[ndx] << char
    #   if rails > 1
    #     if moving_down
    #       ndx += 1
    #     else
    #       ndx -= 1
    #     end
    #     moving_down = moving_down ? false : true if ndx == rails - 1 || ndx == 0
    #   end
    # end
    # p @@arr.join
    # @@arr.join
    stringy(str, rails, true)
  end

# decode
# ======
# algo:
# - since encode populates the @@arr, and since the encoded and decoded strs
#   are the same length, we can call encode to determine how many chars come
#   from each rail (from each @@arr elem)
# - make a copy of the encoded str
# - for each elem in @@arr
#   - set the elem equal to the first elem.size chars sliced from the copy of
#     the encoded str
# - init a newstr to ''
# - set a flag to indicate whether we are moving down or up between rails
# - init an ndx to 0
# - for each char in the encoded str
#   - slice the first char of the @@arr elem at the current ndx
#   - append the char to the newstr
#   - if the num of rails is > 1
#     - if we are moving down
#       - incr the ndx
#     - else
#       - decr the ndx
#     - if the ndx is now pointing to the last or the first rail
#       - flip the value of the flag (so that we can move in the other dir)
# - rtn the (decoded) newstr

  def self.decode(str, rails)
    # puts
    encode(str, rails)
    strcpy = str.clone
    # p "strcpy == #{strcpy}"
    @@arr.map! { |elem| strcpy.slice!(0, elem.size) }
    # p @@arr

    # newstr = ''
    # moving_down = true
    # ndx = 0
    # str.each_char do |char|
    #   # p "char == #{char}, ndx == #{ndx}, moving_down == #{moving_down}"
    #   newstr << @@arr[ndx].slice!(0)
    #   if rails > 1
    #     if moving_down
    #       ndx += 1
    #     else
    #       ndx -= 1
    #     end
    #     moving_down = moving_down ? false : true if ndx == rails - 1 || ndx == 0
    #   end
    # end
    # # p newstr
    # newstr
    stringy(str, rails, false)
  end

  def self.stringy(str, rails, cipher)
    newstr = ''
    moving_down = true
    ndx = 0
    str.each_char do |char|
      # p "char == #{char}, ndx == #{ndx}, moving_down == #{moving_down}"
      if cipher
        @@arr[ndx] << char
      else
        newstr << @@arr[ndx].slice!(0)
      end
      if rails > 1
        if moving_down
          ndx += 1
        else
          ndx -= 1
        end
        moving_down = moving_down ? false : true if ndx == rails - 1 || ndx == 0
      end
    end
    cipher ? @@arr.join : newstr
  end
end


require 'minitest/autorun'
# require_relative 'rail_fence_cipher'

# rubocop:enable all
class RailFenceCipherTest < Minitest::Test
  def test_encode_with_empty_string
    # skip
    assert_equal '', RailFenceCipher.encode('', 4)
  end

  def test_encode_with_one_rail
    # skip
    assert_equal 'One rail, only one rail',
                 RailFenceCipher.encode('One rail, only one rail', 1)
  end

  def test_encode_with_two_rails
    # skip
    assert_equal 'XXXXXXXXXOOOOOOOOO',
                 RailFenceCipher.encode('XOXOXOXOXOXOXOXOXO', 2)
  end

  def test_encode_with_three_rails
    # skip
    assert_equal 'WECRLTEERDSOEEFEAOCAIVDEN',
                 RailFenceCipher.encode('WEAREDISCOVEREDFLEEATONCE', 3)
  end

  def test_encode_with_ending_in_the_middle
    # skip
    assert_equal 'ESXIEECSR', RailFenceCipher.encode('EXERCISES', 4)
  end

  def test_encode_with_less_letters_than_rails
    # skip
    assert_equal 'More rails than letters',
                 RailFenceCipher.encode('More rails than letters', 24)
  end

  def test_decode_with_empty_string
    # skip
    assert_equal '', RailFenceCipher.decode('', 4)
  end

  def test_decode_with_one_rail
    # skip
    assert_equal 'ABCDEFGHIJKLMNOP',
                 RailFenceCipher.decode('ABCDEFGHIJKLMNOP', 1)
  end

  def test_decode_with_two_rails
    # skip
    assert_equal 'XOXOXOXOXOXOXOXOXO',
                 RailFenceCipher.decode('XXXXXXXXXOOOOOOOOO', 2)
  end

  def test_decode_with_three_rails
    # skip
    assert_equal 'THEDEVILISINTHEDETAILS',
                 RailFenceCipher.decode('TEITELHDVLSNHDTISEIIEA', 3)
  end
end
