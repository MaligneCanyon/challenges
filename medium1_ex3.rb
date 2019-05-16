# inputs:
# - str (one or more words)
# outputs:
# - str (one or more 'words')
# reqs:
# - translate the input str to a PigLatin str and output the result
# rules:
# - Rule 1: If a word begins with a vowel sound, add an "ay" sound to the end of the word.
#   - vowel sound if word begins w/
#     - a vowel
#     - 'yt'
#     - 'x' and another consonant
# - Rule 2: If a word begins with a consonant sound, move it to the end of the word, and then add an
#     "ay" sound to the end of the word.
#   - consonant sound includes the first letter (a consonant) and
#     - all subsequent consecutive consonants
#     - 'u' (when following a 'q')
# struct:
# - arr (to hold words from a phrase)
# - str (for individual words)
# algo:
# - split the str into an arr of words
# - for each word
#   - unless the word starts w/ a vowel or 'yt' or w/ 'x' and another consonant
#     - split off the first letter and all subsequent consecutive consonants
#     - if the last letter split off is a 'q'
#       - also split off the next letter if it is a 'u'
#     - append the split off letters to the remaining letters of the word
#   - append 'ay' to the word
# - join the revised words to form a new_str
# - rtn the new_str


class PigLatin
  def self.translate(str)
    str.split(' ').map do |word| # split phrases into an arr of words
      unless word.start_with?(/[aeiou]/i, /yt/i, /x[^aeiou]/i) # a consonant sound unless ...
        (0..word.size).each do |ndx|
          if word[ndx] =~ /[aeiou]/i # we found the first vowel
            ndx += 1 if word[(ndx - 1), 2] == 'qu'
            word = word[ndx..-1] + word[0...ndx] # re-arrange the word
            break
          end
        end
      end
      word += 'ay'
    end.join(' ')
  end
end


require 'minitest/autorun'
# require_relative 'pig_latin'

class PigLatinTest < Minitest::Test
  def test_word_beginning_with_a
    assert_equal 'appleay', PigLatin.translate('apple')
  end

  def test_other_word_beginning_e
    # skip
    assert_equal 'earay', PigLatin.translate('ear')
  end

  def test_word_beginning_with_p
    # skip
    assert_equal 'igpay', PigLatin.translate('pig')
  end

  def test_word_beginning_with_k
    # skip
    assert_equal 'oalakay', PigLatin.translate('koala')
  end

  def test_word_beginning_with_ch
    # skip
    assert_equal 'airchay', PigLatin.translate('chair')
  end

  def test_word_beginning_with_qu
    # skip
    assert_equal 'eenquay', PigLatin.translate('queen')
  end

  def test_word_with_consonant_preceding_qu
    # skip
    assert_equal 'aresquay', PigLatin.translate('square')
  end

  def test_word_beginning_with_th
    # skip
    assert_equal 'erapythay', PigLatin.translate('therapy')
  end

  def test_word_beginning_with_thr
    # skip
    assert_equal 'ushthray', PigLatin.translate('thrush')
  end


  def test_word_beginning_with_sch
    # skip
    assert_equal 'oolschay', PigLatin.translate('school')
  end

  def test_translates_phrase
    # skip
    assert_equal 'ickquay astfay unray', PigLatin.translate('quick fast run')
  end

  def test_word_beginning_with_ye
    # skip
    assert_equal 'ellowyay', PigLatin.translate('yellow')
  end

  def test_word_beginning_with_yt
    # skip
    assert_equal 'yttriaay', PigLatin.translate('yttria')
  end

  def test_word_beginning_with_xe
    # skip
    assert_equal 'enonxay', PigLatin.translate('xenon')
  end

  def test_word_beginning_with_xr
    # skip
    assert_equal 'xrayay', PigLatin.translate('xray')
  end
end
