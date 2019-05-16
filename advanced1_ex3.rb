class Cipher
  ALPHABET = ('a'..'z').to_a.freeze

  def initialize(key_str=nil)
    if key_str
      raise ArgumentError if key_str.empty?
      raise ArgumentError unless key_str.chars.all? { |char| ALPHABET.include?(char) }
      @key_str = key_str
    else # Step 3: if no key is supplied, gen a random key
      @key_str = ''
      100.times { @key_str << ALPHABET.sample }
    end
  end

  def key
    @key_str
  end

# process
# =======
# inputs:
# - str (a str to encode or decode)
# - str (a key as an instance var)
# - a blk (containing a flag to indicate encoding or decoding)
# outputs:
# - str (encoded or decoded)
# reqs:
# - rotate chars in the encodable str by the num of ordinal spaces specified
#   by the key str
# - need to determine the position of each char in the alphabet
# rules:
# - num is the ndx of the key char in the alphabet
#   - num = -num when decoding
#   - new_position = (old_position + num) % 26
# struct:
# - arr
# algo:
# - split the encodable str into an arr of chars
# - for each char in the arr
#   - map the encodable char as follows
#     - if it is an alphachar
#       - gen a key if no key_str is supplied
#       - calc the ndx of the key char
#       - calc the encodable char old_position
#       - calc the encodable char new_position
#       - calc the delta_position
#         - new_position - old_position
#       - get the ordinal value of the encodable char
#       - add the delta_position to the ordinal value
#       - covert the new ordinal value to a new_char
#     - else
#       - use the existing char
# - join the encodable chars to form a new str
# - rtn the new str

  def process(str)
    str.chars.map.with_index do |char, ndx|
      # p "char == #{char}"
      if ALPHABET.include?(char)
        # Step 1: num == 3 for the basic CaesarCipher encryption
        # num = @key_str ? ALPHABET.index(@key_str[ndx]) : 3
        # Step 3: we gen a random key in #initialize if one is not supplied
        num = ALPHABET.index(@key_str[ndx])
        num = -num if yield == :decode
        old_ndx = ALPHABET.index(char)
        delta_ndx = (old_ndx + num) % 26 - old_ndx
        (char.ord + delta_ndx).chr
      else
        char
      end
    end.join
  end

  def encode(str)
    process(str) { :encode }
  end

  def decode(str)
    process(str) { :decode }
  end
end

# Step 1:
@cipher = Cipher.new
p @cipher.encode("iamapandabear") #=> "ldpdsdqgdehdu"
p @cipher.decode("ldpdsdqgdehdu") #=> "iamapandabear"


# Step 2:
@cipher = Cipher.new("aaaaaaaaaaaaaaaaaa")
p @cipher.encode("iamapandabear") #=> "iamapandabear"
@cipher = Cipher.new("ddddddddddddddddd")
p @cipher.encode("imapandabear")  #=> "lpdsdqgdehdu"

# Step 3:
@cipher = Cipher.new
p @cipher.key #=> "duxrceqyaimciuucnelkeoxjhdyduucpmrxmaivacmybmsdrzwqxvbxsygzsabdjmdjabeorttiwinfrpmpogvabiofqexnohrqu"


require 'minitest/autorun'
# require_relative 'simple_cipher'

class RandomKeyCipherTest < Minitest::Test
  def setup
    @cipher = Cipher.new
  end

  def test_cipher_key_is_letters
    # skip
    assert_match(/\A[a-z]+\z/, @cipher.key)
  end

  # Here we take advantage of the fact that plaintext of "aaa..." doesn't
  # output the key. This is a critical problem with shift ciphers, some
  # characters will always output the key verbatim.
  def test_cipher_encode
    # skip
    plaintext = 'aaaaaaaaaa'
    # p @cipher.key[0, 10]
    assert_equal(@cipher.key[0, 10], @cipher.encode(plaintext))
  end

  def test_cipher_decode
    # skip
    plaintext = 'aaaaaaaaaa'
    assert_equal(plaintext, @cipher.decode(@cipher.key[0, 10]))
  end

  def test_cipher_reversible
    # skip
    plaintext = 'abcdefghij'
    assert_equal(plaintext, @cipher.decode(@cipher.encode(plaintext)))
  end
end

class IncorrectKeyCipherTest < MiniTest::Test
  def test_cipher_with_caps_key
    # skip
    assert_raises ArgumentError do
      Cipher.new('ABCDEF')
    end
  end

  def test_cipher_with_numeric_key
    # skip
    assert_raises ArgumentError do
      Cipher.new('12345')
    end
  end

  def test_cipher_with_empty_key
    # skip
    assert_raises ArgumentError do
      Cipher.new('')
    end
  end
end

class SubstitutionCipherTest < MiniTest::Test
  def setup
    @key = 'abcdefghij'
    @cipher = Cipher.new(@key)
  end

  def test_cipher_key_is_as_submitted
    # skip
    assert_equal(@cipher.key, @key)
  end

  def test_cipher_encode
    # skip
    plaintext = 'aaaaaaaaaa'
    ciphertext = 'abcdefghij'
    assert_equal(ciphertext, @cipher.encode(plaintext))
  end

  def test_cipher_decode
    # skip
    plaintext = 'aaaaaaaaaa'
    ciphertext = 'abcdefghij'
    assert_equal(plaintext, @cipher.decode(ciphertext))
  end

  def test_cipher_reversible
    # skip
    plaintext = 'abcdefghij'
    assert_equal(plaintext, @cipher.decode(@cipher.encode(plaintext)))
  end

  def test_double_shift_encode
    # skip
    plaintext = 'iamapandabear'
    ciphertext = 'qayaeaagaciai'
    assert_equal(ciphertext, Cipher.new('iamapandabear').encode(plaintext))
  end

  def test_cipher_encode_wrap
    # skip
    plaintext = 'zzzzzzzzzz'
    ciphertext = 'zabcdefghi'
    assert_equal(ciphertext, @cipher.encode(plaintext))
  end
end

class PseudoShiftCipherTest < MiniTest::Test
  def setup
    @cipher = Cipher.new('dddddddddd')
  end

  def test_cipher_encode
    # skip
    plaintext = 'aaaaaaaaaa'
    ciphertext = 'dddddddddd'
    assert_equal(ciphertext, @cipher.encode(plaintext))
  end

  def test_cipher_decode
    # skip
    plaintext = 'aaaaaaaaaa'
    ciphertext = 'dddddddddd'
    assert_equal(plaintext, @cipher.decode(ciphertext))
  end

  def test_cipher_reversible
    # skip
    plaintext = 'abcdefghij'
    assert_equal(plaintext, @cipher.decode(@cipher.encode(plaintext)))
  end
end
