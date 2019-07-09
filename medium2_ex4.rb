class Crypto
  def initialize(str)
    @str = str.downcase
  end

  def normalize_plaintext
    @str.delete!('^a-z0-9')
  end

  def size
    self.normalize_plaintext
    Math.sqrt(@str.size).ceil
  end

# plaintext_segments
# ==================
# inputs:
# - str (output from Crypto#normalize_plaintext)
# - int (output from Crypto#size)
# outputs:
# - arr (of encrypted strs)
# reqs:
# - take a str and an int
# - split the str in substrs that are int chars long
# - place the substrs in an arr
# - rtn the arr
# rules:
# - last substr may be < int chars long
# struct:
# - str
# algo:
# - init an arr to []
# - while the str.size is > 0
#   - if the str.size is < the int
#     - segment_size equals the str.size
#   - else
#     - segment_size equals the int
#   - slice segment_size chars from the beginning of the str
#   - save the sliced chars in the arr
# - rtn the arr

  def plaintext_segments
    # split_size = self.size
    # arr = []
    # until @str.empty?
    #   segment_size = [@str.size, split_size].min
    #   arr << @str.slice!(0, segment_size)
    # end
    # arr

    normalize_plaintext.scan(/.{1,#{size}}/) # from various solutions
  end

# cipher
# ======
# inputs:
# - str
# outputs:
# - arr
# reqs:
# - convert the input str into an arr of encoded newstrs
#   - break up the input str into substrs
#   - while at least one of the substrs contains chars
#     - build a newstr by taking (chopping off) the first char of each substr
#       and adding it to the newstr
#     - save the newstr in a newarr
# rules:
# - none
# struct:
# - arr (of unencoded substrs)
# - str (encoded)
# - arr (of encoded strs)
# algo:
# - break the input str into an arr of substrs using plaintext_segments
# - init a newarr to []
# - while any arr elem (substr) has chars left in it
#   - init a newstr to ''
#   - for each arr elem (substr)
#     - strip off the first char of the substr
#     - add the char to the newstr
#   - add the newstr to the newarr
# - rtn the newarr

  def cipher
    arr = self.plaintext_segments
    newarr = []
    loop do
      newstr = ''
      arr.map! do |substr|
        if substr
          newstr << substr.chr
          substr[1..-1]
        else
          nil
        end
      end
      break unless arr.any? { |substr| substr }
      newarr << newstr
    end
    newarr
  end

  def ciphertext
    cipher.join
  end

  def normalize_ciphertext
    cipher.join(' ')
  end
end


require 'minitest/autorun'
# require_relative 'crypto_square'

class CryptoTest < Minitest::Test
  def test_normalize_strange_characters
    # skip
    crypto = Crypto.new('s#$%^&plunk')
    assert_equal 'splunk', crypto.normalize_plaintext
  end

  def test_normalize_uppercase_characters
    # skip
    crypto = Crypto.new('WHOA HEY!')
    assert_equal 'whoahey', crypto.normalize_plaintext
  end

  def test_normalize_with_numbers
    # skip
    crypto = Crypto.new('1, 2, 3 GO!')
    assert_equal '123go', crypto.normalize_plaintext
  end

  def test_size_of_small_square
    # skip
    crypto = Crypto.new('1234')
    assert_equal 2, crypto.size
  end

  def test_size_of_slightly_larger_square
    # skip
    crypto = Crypto.new('123456789')
    assert_equal 3, crypto.size
  end

  def test_size_of_non_perfect_square
    # skip
    crypto = Crypto.new('123456789abc')
    assert_equal 4, crypto.size
  end

  def test_size_is_determined_by_normalized_plaintext
    # skip
    crypto = Crypto.new('Oh hey, this is nuts!')
    assert_equal 4, crypto.size
  end

  def test_plaintext_segments
    # skip
    crypto = Crypto.new('Never vex thine heart with idle woes')
    expected = %w(neverv exthin eheart withid lewoes)
    assert_equal expected, crypto.plaintext_segments
  end

  def test_other_plaintext_segments
    # skip
    crypto = Crypto.new('ZOMG! ZOMBIES!!!')
    assert_equal %w(zomg zomb ies), crypto.plaintext_segments
  end

  def test_ciphertext
    # skip
    crypto = Crypto.new('Time is an illusion. Lunchtime doubly so.')
    assert_equal 'tasneyinicdsmiohooelntuillibsuuml', crypto.ciphertext
  end

  def test_another_ciphertext
    # skip
    crypto = Crypto.new('We all know interspecies romance is weird.')
    assert_equal 'wneiaweoreneawssciliprerlneoidktcms', crypto.ciphertext
  end

  def test_normalized_ciphertext
    # skip
    crypto = Crypto.new('Vampires are people too!')
    assert_equal 'vrel aepe mset paoo irpo', crypto.normalize_ciphertext
  end

  def test_normalized_ciphertext_spills_into_short_segment
    # skip
    crypto = Crypto.new('Madness, and then illumination.')
    expected = 'msemo aanin dnin ndla etlt shui'
    assert_equal expected, crypto.normalize_ciphertext
  end

  def test_another_normalized_ciphertext
    # skip
    crypto = Crypto.new(
      'If man was meant to stay on the ground god would have given us roots',
    )
    expected = 'imtgdvs fearwer mayoogo anouuio ntnnlvt wttddes aohghn sseoau'
    assert_equal expected, crypto.normalize_ciphertext
  end

  def test_normalized_ciphertext_with_punctuation
    # skip
    crypto = Crypto.new('Have a nice day. Feed the dog & chill out!')
    expected = 'hifei acedl veeol eddgo aatcu nyhht'
    assert_equal expected, crypto.normalize_ciphertext
  end

  def test_normalized_ciphertext_when_just_less_then_a_full_square
    # skip
    crypto = Crypto.new('I am')
    assert_equal 'im a', crypto.normalize_ciphertext
  end
end
