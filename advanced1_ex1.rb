# convert
# -------
# inputs:
# - str (as heredoc)
# outputs:
# - str (str rep of the input text as an int)
# reqs:
# - convert the input text into an arr of OCR chars
# - convert the arr of OCR chars into a str rep of an int
# rules:
# - input str contains 4 rows, 3 cols (max) per row
# struct:
# - arr (to hold OCR chars)
# algo:
# - convert (possibly multiline) input text to an arr of OCR chars
#   - call build_ocr_arr
# - init an output str to ''
# - for each OCR char in the ocr_arr
#   - convert the OCR char into a str rep of an int digit
#     - test for a valid OCR char
#       - raise an err if the OCR char is invalid
#     - compare the OCR char to a char_arr of known OCR char patterns
#       - if the ORC char matches one of the patterns
#         - if the ORC char is a comma
#           - add a comma to the output str
#         - else
#           - add a str rep the ndx of the char_arr to the output str
#       - else
#         - add '?' to the output str (the OCR char did not translate to a
#           recognized char)
# - rtn the output str


# build_ocr_arr
# -------------
# inputs:
# - str (as heredoc)
# outputs:
# - arr (of OCR chars)
# reqs:
# - convert the multiline input str into a arr of OCR chars
# rules:
# - input str (may) contain
#   - multiple lines of OCR chars
#     - separated by a blank line
#   - multiple OCR chars in a single line
#   - a single OCR char
# - each line of OCR chars is made up of multiple rows of chars
#   - if there is more than 1 OCR char on a particular line
#     - each row will contain segments from mulitiple ORC chars
#     - trailing blank chars (padding) may separate OCR char segments w/i a row
# - each OCR char contains 4 rows, 3 cols (max) per row
#   - the 4th row is always blank
# struct:
# - arr (to hold rows of chars from the input str)
# - arr (to hold OCR chars)
# algo:
# - split the input text into lines of OCR chars
#   - ocr_lines = @text.split("\n\n")
# - for each ORC line
#   - split the text into an arr of rows
#     - rows = line.split("\n")
#   - for each row
#     - split each row into an arr of cols (1 to 3 chars long) representing OCR
#       char segments
#       - cols = row.scan(/.{1,3}/)
#     - if the arr of cols is empty [], replace it w/ [""]
#     - count the num of OCR chars in the row
#     - map the arr of cols into each row
#   - build an ocr_arr of individual OCR digits;
#     build a str rep of each OCR char that is in the current line and copy
#     that str to the ocr_arr
#   - for each ocr_digit
#     - for each row
#       - retrieve the str that reps the current OCR char segment
#       - add the str to the ocr_str
#         - chop off any trailing blanks
#     - add the ocr_str to the ocr_arr
#   - add a comma to the ocr_arr between lines of OCR chars
# - rtn the ocr_arr


class OCR
  class InvalidInputError < StandardError; end

    text0 = <<-NUMBER.chomp
 _
| |
|_|

    NUMBER
    text1 = <<-NUMBER.chomp

  |
  |

    NUMBER
    text2 = <<-NUMBER.chomp
 _
 _|
|_

    NUMBER
    text3 = <<-NUMBER.chomp
 _
 _|
 _|

    NUMBER
    text4 = <<-NUMBER.chomp

|_|
  |

    NUMBER
    text5 = <<-NUMBER.chomp
 _
|_
 _|

    NUMBER
    text6 = <<-NUMBER.chomp
 _
|_
|_|

    NUMBER
    text7 = <<-NUMBER.chomp
 _
  |
  |

    NUMBER
    text8 = <<-NUMBER.chomp
 _
|_|
|_|

    NUMBER
    text9 = <<-NUMBER.chomp
 _
|_|
 _|

    NUMBER
  OCR_CHARS = [text0, text1, text2, text3, text4, text5, text6, text7, text8, text9, ',']


  def initialize(text)
    @text = text
  end

  # convert input text (a heredoc of OCR chars) into a str rep of an int
  def convert
    ocr_arr = build_ocr_arr
    # puts "ocr_arr == #{ocr_arr}"
    ocr_arr.map do |ocr_char|
      # puts "ocr_char ==\n#{ocr_char}"
      raise InvalidInputError unless valid?(ocr_char)
      if OCR_CHARS.include?(ocr_char)
        ocr_char == ',' ? ocr_char : OCR_CHARS.index(ocr_char).to_s
      else
        '?'
      end
    end.join
  end

  # build an arr of the OCR chars that are present in the input text
  def build_ocr_arr
    # puts
    ocr_arr = []
    ocr_lines = @text.split("\n\n")
    ocr_lines.each do |line|
      # puts "line ==\n#{line}"

      rows = line.split("\n")
      # puts "rows ==\n#{rows}"

      # map the arr of cols into each row
      ocr_size = 0
      rows.map! do |row|
        cols = row.scan(/.{1,3}/)
        # ocr_size is the num of cols (thus the num of OCR chars) in each row
        cols = (cols == [] ? [""] : cols)
        # puts "cols == #{cols}"
        ocr_size += cols.size
        cols
      end
      # puts "rows2 ==\n#{rows}"
      ocr_size /= 3 # 3 rows for each OCR char
      # p "ocr_size == #{ocr_size}"

      # build a str rep of each OCR char that's in the current line and copy
      # that str to the ocr_arr
      (0...ocr_size).each do |ocr_digit|
        ocr_str = ''
        rows.each do |row|
          # puts "row == #{row}"

          # chop off any trailing blanks;
          # if the row has trailing spaces (padding for the next OCR char),
          # strip off the padding
          str = row[ocr_digit]
          ocr_str += str.sub(/( +)$/, '') + "\n"
        end
        # p "ocr_str == '#{ocr_str}'"
        ocr_arr << ocr_str
      end
      # ocr_arr
      ocr_arr << ',' unless line == ocr_lines.last

    end
    ocr_arr
  end

  # test for a valid OCR char
  def valid?(ocr_char)
    return true if ocr_char == ',' # separator for multiple lines of OCR chars
    arr = ocr_char.split("\n")
    # since we chomp the input text, and the last row is always blank,
    # we only have 3 rows of text (3 elems) in the arr
    arr.size == 3 && arr.all? { |elem| elem.size <= 3 } # 3 rows, 3 cols max
  end
end


require 'minitest/autorun'
# require_relative 'ocr_numbers'

class OCRTest < Minitest::Test
  # rubocop:disable  Style/TrailingWhitespace
  def test_recognize_zero
    # skip
    text = <<-NUMBER.chomp
 _
| |
|_|

    NUMBER
    assert_equal '0', OCR.new(text).convert
  end

  def test_recognize_one
    # # skip
    text = <<-NUMBER.chomp

  |
  |

    NUMBER
    assert_equal '1', OCR.new(text).convert
  end

  def test_recognize_two
    # skip
    text = <<-NUMBER.chomp
 _
 _|
|_

    NUMBER
    assert_equal '2', OCR.new(text).convert
  end

  def test_recognize_three
    # skip
    text = <<-NUMBER.chomp
 _
 _|
 _|

    NUMBER
    assert_equal '3', OCR.new(text).convert
  end

  def test_recognize_four
    # skip
    text = <<-NUMBER.chomp

|_|
  |

    NUMBER
    assert_equal '4', OCR.new(text).convert
  end

  def test_recognize_five
    # skip
    text = <<-NUMBER.chomp
 _
|_
 _|

    NUMBER
    assert_equal '5', OCR.new(text).convert
  end

  def test_recognize_six
    # skip
    text = <<-NUMBER.chomp
 _
|_
|_|

    NUMBER
    assert_equal '6', OCR.new(text).convert
  end

  def test_recognize_seven
    # skip
    text = <<-NUMBER.chomp
 _
  |
  |

    NUMBER
    assert_equal '7', OCR.new(text).convert
  end

  def test_recognize_eight
    # skip
    text = <<-NUMBER.chomp
 _
|_|
|_|

    NUMBER
    assert_equal '8', OCR.new(text).convert
  end

  def test_recognize_nine
    # skip
    text = <<-NUMBER.chomp
 _
|_|
 _|

    NUMBER
    assert_equal '9', OCR.new(text).convert
  end


  def test_identify_garble
    # skip
    text = <<-NUMBER.chomp

| |
| |

    NUMBER
    assert_equal '?', OCR.new(text).convert
  end

  def test_identify_10
    # # skip
    text = <<-NUMBER.chomp
    _
  || |
  ||_|

    NUMBER
    assert_equal '10', OCR.new(text).convert
  end

  def test_identify_110101100
    # skip
    text = <<-NUMBER.chomp
       _     _        _  _
  |  || |  || |  |  || || |
  |  ||_|  ||_|  |  ||_||_|

    NUMBER
    assert_equal '110101100', OCR.new(text).convert
  end

  def test_identify_with_garble
    # skip
    text = <<-NUMBER.chomp
       _     _           _
  |  || |  || |     || || |
  |  | _|  ||_|  |  ||_||_|

    NUMBER
    assert_equal '11?10?1?0', OCR.new(text).convert
  end

  def test_identify_1234567890
    # skip
    text = <<-NUMBER.chomp
    _  _     _  _  _  _  _  _
  | _| _||_||_ |_   ||_||_|| |
  ||_  _|  | _||_|  ||_| _||_|

    NUMBER
    assert_equal '1234567890', OCR.new(text).convert
  end

  def test_identify_123_456_789 # rubocop:disable Metrics/MethodLength
    # skip
    text = <<-NUMBER.chomp
    _  _
  | _| _|
  ||_  _|

    _  _
|_||_ |_
  | _||_|

 _  _  _
  ||_||_|
  ||_| _|

    NUMBER
    assert_equal '123,456,789', OCR.new(text).convert
  end
end
