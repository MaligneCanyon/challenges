# leverage courses/ruby/programming_foundations/exercises/medium1_ex5.rb

class Diamond
  ALPHABET = %w(A B C D E)

  def self.make_diamond(letter)
    str = ''
    rows = ALPHABET.index(letter) * 2 + 1
    center_row = (rows + 1) / 2
    (1..rows).each do |row|
      k = (row > center_row) ? rows - row : row - 1
      # ex. if letter = 'C', rows = 5, center_row = 3, k = 0,1,2,1,0
      lead_chars = (rows - 1) / 2 - k # leading spaces
      mid_chars = 2 * k - 1 # middle spaces
      str << ' ' * lead_chars + ALPHABET[k]
      str << ' ' * mid_chars + ALPHABET[k] if mid_chars > 0
      str << ' ' * lead_chars + "\n"
    end
    str
  end
end


require 'minitest/autorun'
# require_relative 'diamond'

class DiamondTest < Minitest::Test
  def test_letter_a
    # skip
    answer = Diamond.make_diamond('A')
    assert_equal "A\n", answer
  end

  def test_letter_c
    # skip
    answer = Diamond.make_diamond('C')
    string = "  A  \n"\
             " B B \n"\
             "C   C\n"\
             " B B \n"\
             "  A  \n"
    assert_equal string, answer
  end

  def test_letter_e
    # skip
    answer = Diamond.make_diamond('E')
    string = "    A    \n"\
             "   B B   \n"\
             "  C   C  \n"\
             " D     D \n"\
             "E       E\n"\
             " D     D \n"\
             "  C   C  \n"\
             "   B B   \n"\
             "    A    \n"
    assert_equal string, answer
  end
end
