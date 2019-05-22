# inputs:
# - str (a phrase)
# outputs:
# - hash (w/ str keys and int values)
# reqs:
# - count the occurences of each word in a phrase
# rules:
# - words are sets of contiguous alphanumeric chars (possibly with apostrophes)
# - words are case-insensitive
# - ignore quotes surrounding quoted words
# struct:
# - arr (to hold individual words)
# - hsh (for output of word counts)
# algo:
# - init a hsh to {}
# - downcase the phrase
# - split the phrase into an arr of words
#   - split on chars that are not apostrophes, digits, or lowercase letters
# - for each word in the arr
#   - extract the word from enveloping quotes if the word is quoted
#   - if the word exists as a key in the hsh
#     - incr the value for that key
#   - else
#     - create a new key value pair w/ the word as the key and the value == 1
# - rtn the hsh

class Phrase
  def initialize(phrase)
    @phrase = phrase
  end

  # this doesn't work for words ending w/ an apostrophe, ex. Louis' ...
  # def word_count
  #   hsh = Hash.new(0)
  #   arr = @phrase.downcase.scan(/\w+'\w|\w+/) # scan for patterns like xxx'x or xxxx
  #   arr.each { |word| hsh[word] += 1 }
  #   hsh
  # end

  # ... but this does
  # def word_count
  #   hsh = Hash.new(0)
  #   arr = @phrase.downcase.split(/[^'0-9a-z]+/)
  #   arr.each do |word|
  #     word = word[1..-2] if word[0] == "'" && word[-1] == "'"
  #     hsh[word] += 1
  #   end
  #   hsh
  # end

  def word_count
    arr = @phrase.downcase.split(/[^'0-9a-z]+/)
    arr.each_with_object(Hash.new(0)) do |word, hsh|
      word = word[1..-2] if word[0] == "'" && word[-1] == "'" # ignore quotes on quoted words
      hsh[word] += 1
    end
  end
end


require 'minitest/autorun'
# require_relative 'word_count'

class PhraseTest < Minitest::Test
  def test_count_one_word
    # skip
    phrase = Phrase.new('word')
    counts = { 'word' => 1 }
    assert_equal counts, phrase.word_count
  end

  def test_count_one_of_each
    # skip
    phrase = Phrase.new('one of each')
    counts = { 'one' => 1, 'of' => 1, 'each' => 1 }
    assert_equal counts, phrase.word_count
  end

  def test_count_multiple_occurrences
    # skip
    phrase = Phrase.new('one fish two fish red fish blue fish')
    counts = { 'one' => 1, 'fish' => 4, 'two' => 1, 'red' => 1, 'blue' => 1 }
    assert_equal counts, phrase.word_count
  end

  def test_count_everything_just_once
    # skip
    phrase = Phrase.new('all the kings horses and all the kings men')
    phrase.word_count # count it an extra time
    counts = {
      'all' => 2, 'the' => 2, 'kings' => 2,
      'horses' => 1, 'and' => 1, 'men' => 1
    }
    assert_equal counts, phrase.word_count
  end

  def test_ignore_punctuation
    # skip
    phrase = Phrase.new('car : carpet as java : javascript!!&@$%^&')
    counts = {
      'car' => 1, 'carpet' => 1, 'as' => 1,
      'java' => 1, 'javascript' => 1
    }
    assert_equal counts, phrase.word_count
  end

  def test_handles_cramped_lists
    # skip
    phrase = Phrase.new('one,two,three')
    counts = { 'one' => 1, 'two' => 1, 'three' => 1 }
    assert_equal counts, phrase.word_count
  end

  def test_handles_expanded_lists
    # skip
    phrase = Phrase.new("one,\ntwo,\nthree")
    counts = { 'one' => 1, 'two' => 1, 'three' => 1 }
    assert_equal counts, phrase.word_count
  end

  def test_include_numbers
    # skip
    phrase = Phrase.new('testing, 1, 2 testing')
    counts = { 'testing' => 2, '1' => 1, '2' => 1 }
    assert_equal counts, phrase.word_count
  end

  def test_normalize_case
    # skip
    phrase = Phrase.new('go Go GO')
    counts = { 'go' => 3 }
    assert_equal counts, phrase.word_count
  end


  def test_with_apostrophes
    # skip
    phrase = Phrase.new("First: don't laugh. Then: don't cry.")
    counts = {
      'first' => 1, "don't" => 2, 'laugh' => 1,
      'then' => 1, 'cry' => 1
    }
    assert_equal counts, phrase.word_count
  end

  def test_with_quotations
    # skip
    phrase = Phrase.new("Joe can't tell between 'large' and large.")
    counts = {
      'joe' => 1, "can't" => 1, 'tell' => 1,
      'between' => 1, 'large' => 2, 'and' => 1
    }
    assert_equal counts, phrase.word_count
  end

  def test_more_apostrophes
    # skip
    phrase = Phrase.new("Louis O'Leary can't tell between 'large' and large: it's Louis'.")
    counts = {
      'louis' => 1, "o'leary" => 1, "can't" => 1, 'tell' => 1, 'between' => 1, 'large' => 2,
      'and' => 1, "it's" => 1, "louis'" => 1
    }
    assert_equal counts, phrase.word_count
  end
end
