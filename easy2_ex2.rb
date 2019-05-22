# score
# =====
# inputs:
# - str
# outputs:
# - int
# reqs:
# - compute the total of the values of the letters in a given word
# rules:
#   Letter                           Value
#   A, E, I, O, U, L, N, R, S, T       1
#   D, G                               2
#   B, C, M, P                         3
#   F, H, V, W, Y                      4
#   K                                  5
#   J, X                               8
#   Q, Z                               10
# struct:
# - hsh (to hold letter values)
# - arr (to hold word letters)
# algo:
# - create a hsh to hold letter values
# - set the word to '' if the word is equal to nil
# - upcase the word
# - split the word into an arr of chars
# - for each char in the arr
#   - if the char is alphabetic
#     - map the char value
#   - else
#     - map 0
# - sum the char values in the mapped arr
# - rtn the sum

HSH = {
  1 => %w(A E I O U L N R S T),
  2 => %w(D G),
  3 => %w(B C M P),
  4 => %w(F H V W Y),
  5 => %w(K),
  8 => %w(J X),
 10 => %w(Q Z)
}

class Scrabble
  def self.score(word)
    self.new(word).score
  end

  def initialize(word)
    word ||= '' # in case word is nil
    @word = word
  end

  # def score
  #   @word.upcase.chars.map do |char|
  #     if char =~ /[A-Z]/
  #       HSH.select { |value, letters| letters.include?(char) }.keys.first
  #     else
  #       0
  #     end
  #   end.sum
  # end

  def score
    @word.upcase.chars.map do |char|
      char =~ /[A-Z]/ ? HSH.select { |k, v| v.include?(char) }.keys.first : 0
    end.sum
  end
end


require 'minitest/autorun'
# require_relative 'scrabble_score'

class ScrabbleTest < Minitest::Test
  def test_empty_word_scores_zero
    # skip
    assert_equal 0, Scrabble.new('').score
  end

  def test_whitespace_scores_zero
    # skip
    assert_equal 0, Scrabble.new(" \t\n").score
  end

  def test_nil_scores_zero
    # skip
    assert_equal 0, Scrabble.new(nil).score
  end

  def test_scores_very_short_word
    # skip
    assert_equal 1, Scrabble.new('a').score
  end

  def test_scores_other_very_short_word
    # skip
    assert_equal 4, Scrabble.new('f').score
  end

  def test_simple_word_scores_the_number_of_letters
    # skip
    assert_equal 6, Scrabble.new('street').score
  end

  def test_complicated_word_scores_more
    # skip
    assert_equal 22, Scrabble.new('quirky').score
  end

  def test_scores_are_case_insensitive
    # skip
    assert_equal 41, Scrabble.new('OXYPHENBUTAZONE').score
  end

  def test_convenient_scoring
    # skip
    assert_equal 13, Scrabble.score('alacrity')
  end
end
