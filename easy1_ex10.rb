# inputs:
# - int
# outputs:
# - str
# reqs:
# - convert an int to its Roman numeral equiv
# rules:
# - 1000s
#   1000 => 'M'
#   2000 => 'MM'
#   3000 => 'MMM'
#   'M' * (year/1000)
# - 100s
#   900 => 'CM'
#   800 => 'DCCC'
#   700 => 'DCC'
#   600 => 'DC'
#   500 => 'D'
#   400 => 'CD'
#   300 => 'CCC'
#   200 => 'CC'
#   100 => 'C'
# - 10s
#   90 => 'XC'
#   80 => 'LXXX'
#   70 => 'LXX'
#   60 => 'LX'
#   50 => 'L'
#   40 => 'XL'
#   30 => 'XXX'
#   20 => 'XX'
#   10 => 'X'
# - 1s
#   9 => 'IX'   # sym0 + sym2
#   8 => 'VIII'
#   7 => 'VII'
#   6 => 'VI'
#   5 => 'V'    # sym1
#   4 => 'IV'   # sym0 + sym1
#   3 => 'III'
#   2 => 'II'
#   1 => 'I'    # sym0
#
# - generally, if
#   digit is 0,      roman char = ''
#   digit is (1..3), roman char = sym0 * digit
#   digit is 4,      roman char = sym0 + sym1
#   digit is (5..8), roman char = sym1 + sym0 * (digit - 5)
#   digit is 9,      roman char = sym0 + sym2
#
# struct:
# - hsh
# - str
# algo:
# - create a hsh to hold the syms for the 1000s, 100s and 10s digits
# - init output str roman_numeral to ''
# - convert the input num to a str
# - for (str_size - 1) down to 0
#   - convert the digit at the current str pos to a roman char
#     - hsh[pos] is a list of syms
#     - calc the current roman char as per rules
#   - add the current roman char to the output str
# - rtn the output str

HSH = {
  0 => ['I', 'V', 'X'], # 1s
  1 => ['X', 'L', 'C'], # 10s
  2 => ['C', 'D', 'M'], # 100s
  3 => ['M', '', ''],   # 1000s # would need to update this for nums >= 3900
}

class Integer
  def to_roman
    roman_numeral = ''
    str = self.to_s
    (str.size - 1).downto(0) do |exp|
      digit = str[str.size - 1 - exp].to_i # awkward
      roman_numeral +=  case digit
                        when 0      then ''
                        when (1..3) then HSH[exp][0] * digit
                        when 4      then HSH[exp][0] + HSH[exp][1]
                        when (5..8) then HSH[exp][1] + HSH[exp][0] * (digit - 5)
                        when 9      then HSH[exp][0] + HSH[exp][2]
                        end
    end
    roman_numeral
  end
end


require 'minitest/autorun'
# require_relative 'roman_numerals'

class RomanNumeralsTest < Minitest::Test
  def test_1
    # skip
    assert_equal 'I', 1.to_roman
  end

  def test_2
    # skip
    assert_equal 'II', 2.to_roman
  end

  def test_3
    # skip
    assert_equal 'III', 3.to_roman
  end

  def test_4
    # skip
    assert_equal 'IV', 4.to_roman
  end

  def test_5
    # skip
    assert_equal 'V', 5.to_roman
  end

  def test_6
    # skip
    assert_equal 'VI', 6.to_roman
  end

  def test_9
    # skip
    assert_equal 'IX', 9.to_roman
  end

  def test_27
    # skip
    assert_equal 'XXVII', 27.to_roman
  end

  def test_48
    # skip
    assert_equal 'XLVIII', 48.to_roman
  end

  def test_59
    # skip
    assert_equal 'LIX', 59.to_roman
  end

  def test_93
    # skip
    assert_equal 'XCIII', 93.to_roman
  end

  def test_141
    # skip
    assert_equal 'CXLI', 141.to_roman
  end

  def test_163
    # skip
    assert_equal 'CLXIII', 163.to_roman
  end

  def test_402
    # skip
    assert_equal 'CDII', 402.to_roman
  end

  def test_575
    # skip
    assert_equal 'DLXXV', 575.to_roman
  end

  def test_911
    # skip
    assert_equal 'CMXI', 911.to_roman
  end

  def test_1024
    # skip
    assert_equal 'MXXIV', 1024.to_roman
  end

  def test_3000
    # skip
    assert_equal 'MMM', 3000.to_roman
  end
end