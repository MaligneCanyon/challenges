# inputs:
# - str (a word to test)
# - arr (list of possible anagrams)
# outputs:
# - arr (list of anagrams of the test word)
# reqs:
# - given a str and a list of possible anagrams, select the anagrams of the str
#   from the list and rtn the result
# rules:
# - case insensitive
# struct:
# - arr
# algo:
# - upcase! the input word
# - init a new_arr to []
# - for each of the possible anagrams (pa)
#   - save a copy of the pa
#   - upcase! the pa
#   - skip the pa if it is identical to the input word
#   - skip the pa unless it and the input word are the same size
#   - skip the pa if it is already in the new_arr
#   - split the pa into an arr of chars
#   - for each char in the input word
#     - if the pa contains the char
#       - del the first instance of the char from the pa
#   - if there no chars remaining in the pa
#     - add the copy of the pa to the new_arr
# - rtn the new_arr

# class Anagram
#   def initialize(word)
#     @word = word
#   end

#   def match(possible_anagrams)
#     @word.upcase!
#     new_arr = []
#     possible_anagrams.each do |pa|
#       pa_copy = pa.clone
#       pa.upcase!
#       next if @word == pa
#       next unless @word.size == pa.size
#       next if new_arr.map(&:upcase).include?(pa)
#       arr = pa.chars
#       @word.chars.each do |char|
#         arr.delete_at(arr.index(char)) if arr.include?(char)
#       end
#       new_arr << pa_copy if arr.empty?
#     end
#     new_arr
#   end
# end

class Anagram
  def initialize(word)
    @word = word.upcase # pre-process the word
  end

  def match(possible_anagrams)
    new_arr = []
    possible_anagrams.each do |pa|
      pa_copy = pa.clone
      pa.upcase!
      next if @word == pa || @word.size != pa.size || new_arr.map(&:upcase).include?(pa)
      new_arr << pa_copy if @word.chars.sort == pa.chars.sort
    end
    new_arr
  end
end


require 'minitest/autorun'
# require_relative 'anagram'

class AnagramTest < Minitest::Test
  def test_no_matches
    # skip
    detector = Anagram.new('diaper')
    assert_equal [], detector.match(%w(hello world zombies pants))
  end

  def test_detect_simple_anagram
    # skip
    detector = Anagram.new('ant')
    anagrams = detector.match(%w(tan stand at))
    assert_equal ['tan'], anagrams
  end

  def test_detect_multiple_anagrams
    # skip
    detector = Anagram.new('master')
    anagrams = detector.match(%w(stream pigeon maters))
    assert_equal %w(maters stream), anagrams.sort
  end

  def test_does_not_confuse_different_duplicates
    # skip
    detector = Anagram.new('galea')
    assert_equal [], detector.match(['eagle'])
  end

  def test_identical_word_is_not_anagram
    # # skip
    detector = Anagram.new('corn')
    anagrams = detector.match %w(corn dark Corn rank CORN cron park)
    assert_equal ['cron'], anagrams
  end

  def test_eliminate_anagrams_with_same_checksum
    # skip
    detector = Anagram.new('mass')
    assert_equal [], detector.match(['last'])
  end

  def test_eliminate_anagram_subsets
    # skip
    detector = Anagram.new('good')
    assert_equal [], detector.match(%w(dog goody))
  end

  def test_detect_anagram
    # skip
    detector = Anagram.new('listen')
    anagrams = detector.match %w(enlists google inlets banana)
    assert_equal ['inlets'], anagrams
  end

  def test_multiple_anagrams
    # skip
    detector = Anagram.new('allergy')
    anagrams =
      detector.match %w( gallery ballerina regally clergy largely leading)
    assert_equal %w(gallery largely regally), anagrams.sort
  end

  def test_anagrams_are_case_insensitive
    # skip
    detector = Anagram.new('Orchestra')
    anagrams = detector.match %w(cashregister Carthorse radishes)
    assert_equal ['Carthorse'], anagrams
  end
end
