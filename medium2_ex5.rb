# inputs:
# - none
# outputs:
# - str (a blk of text)
# reqs:
# - build up a blk of text based on the provided str segments ("pieces")
# - rtn the text blk
# rules:
# - each verse is composed of a repeating pattern:
#   - 'This is ', plus
#   - the first sub_elem from the current arr elem, plus
#   - a newline char, plus
#   - the last sub_elem from the current arr elem, plus
#   - the first sub_elem from the previous arr elem, plus
#   - a newline char
# - the pattern is repeated until the last (single-elem) elem of the arr is
#   encountered
# - each verse v is composed of v + 1 lines
# - verses are separated by an additional newline char
# struct:
# - arr (to hold verses)
# - str (to hold lines in a verse)
# algo:
# - init an arr to []
# - calc the num of verses minus 1
# - for each verse v (from 0 to num)
#   - init verse to 'This is '
#   - for each line l in the verse (from 0 to v)
#     - unless l == 0
#       - append pieces[(num - 1) - v + l][1] to the verse
#       - append a ' ' to the verse
#     - append pieces[num - v + l][0] to the verse
#     - if l == v
#       - append a '.' to the verse
#     - append a '\n' to the verse
#   - add the verse to the arr
# - build a new_str by joining the elems of the arr w/ a '\n' separator
# - rtn the new_str

class House
  # def self.recite
  #   arr = []
  #   (0...pieces.size).each do |v| # build each verse
  #     verse = 'This is '
  #     (0..v).each do |l| # determine the current line and add it to the verse
  #       ndx = (pieces.size - 1) - v + l
  #       verse += pieces[ndx - 1][1] + ' ' unless l.zero?
  #       verse += pieces[ndx][0]
  #       verse += '.' if l == v
  #       verse += "\n"
  #     end
  #     arr << verse
  #   end
  #   arr.join("\n")
  # end

# size = 12
# v = 0; ndx = 11        ; l = 0
# v = 1; ndx = 10, 11    ; l = 0, 1
# v = 2; ndx =  9, 10, 11; l = 0, 1, 2

  # from the video solution ...
  def self.recite
    song = ""
    (1..pieces.size).each do |lines|
      song += combine_pieces(pieces.last(lines)) +"\n"
      song += "\n" unless lines == pieces.size
    end
    song
  end

  private

  def self.combine_pieces(pieces)
    verse = "This is "
    pieces.each do |piece|
      verse += piece[0]
      verse += ("\n" + piece[1] + ' ') if piece[1]
    end
    verse + '.'
  end

  def self.pieces
    [
      ['the horse and the hound and the horn', 'that belonged to'],
      ['the farmer sowing his corn', 'that kept'],
      ['the rooster that crowed in the morn', 'that woke'],
      ['the priest all shaven and shorn', 'that married'],
      ['the man all tattered and torn', 'that kissed'],
      ['the maiden all forlorn', 'that milked'],
      ['the cow with the crumpled horn', 'that tossed'],
      ['the dog', 'that worried'],
      ['the cat', 'that killed'],
      ['the rat', 'that ate'],
      ['the malt', 'that lay in'],
      ['the house that Jack built']
    ]
  end
end


require 'minitest/autorun'
# require_relative 'house'

# rubocop:disable Metrics/MethodLength
class HouseTest < Minitest::Test
  def test_rhyme
    expected = <<-RHYME
This is the house that Jack built.

This is the malt
that lay in the house that Jack built.

This is the rat
that ate the malt
that lay in the house that Jack built.

This is the cat
that killed the rat
that ate the malt
that lay in the house that Jack built.

This is the dog
that worried the cat
that killed the rat
that ate the malt
that lay in the house that Jack built.

This is the cow with the crumpled horn
that tossed the dog
that worried the cat
that killed the rat
that ate the malt
that lay in the house that Jack built.

This is the maiden all forlorn
that milked the cow with the crumpled horn
that tossed the dog
that worried the cat
that killed the rat
that ate the malt
that lay in the house that Jack built.

This is the man all tattered and torn
that kissed the maiden all forlorn
that milked the cow with the crumpled horn
that tossed the dog
that worried the cat
that killed the rat
that ate the malt
that lay in the house that Jack built.

This is the priest all shaven and shorn
that married the man all tattered and torn
that kissed the maiden all forlorn
that milked the cow with the crumpled horn
that tossed the dog
that worried the cat
that killed the rat
that ate the malt
that lay in the house that Jack built.

This is the rooster that crowed in the morn
that woke the priest all shaven and shorn
that married the man all tattered and torn
that kissed the maiden all forlorn
that milked the cow with the crumpled horn
that tossed the dog
that worried the cat
that killed the rat
that ate the malt
that lay in the house that Jack built.

This is the farmer sowing his corn
that kept the rooster that crowed in the morn
that woke the priest all shaven and shorn
that married the man all tattered and torn
that kissed the maiden all forlorn
that milked the cow with the crumpled horn
that tossed the dog
that worried the cat
that killed the rat
that ate the malt
that lay in the house that Jack built.

This is the horse and the hound and the horn
that belonged to the farmer sowing his corn
that kept the rooster that crowed in the morn
that woke the priest all shaven and shorn
that married the man all tattered and torn
that kissed the maiden all forlorn
that milked the cow with the crumpled horn
that tossed the dog
that worried the cat
that killed the rat
that ate the malt
that lay in the house that Jack built.
    RHYME
    House.recite
    # skip
    assert_equal expected, House.recite
  end
end
