# inputs:
# - str
# outputs:
# - int
# reqs:
# - parse the input str and extract the operands (2 or more) and operators (1 or more)
# - compute the result of operating on the operands (l-to-r until no operators remain)
# rules:
# - none
# struct:
# - arr (to hold operators and operands)
# algo:
# - split the str into an arr of words
#   - split on space and question_mark
# - discard the 1st and 2nd words ("What" and "is")
# - shift an elem out of the arr and save it as operand1
# - while arr.size > 0
#   - shift an elem out of the arr and save it as the operator
#   - shift an elem out of the arr and save it as operand2
#   - if operand2 is equal to "by" (it's not actually an operand, so ...)
#     - shift another elem out of the arr and save it as operand2
#   - lookup the method corresponding to the operator in a hsh
#   - call send on operand1 w/ the method and operand2 as args
#     - save the result in operand1
# - rtn operand1


HSH = { 'plus' => :+, 'minus' => :-, 'multiplied' => :*, 'divided' => :/ }

class WordProblem
  def initialize(str)
    @arr = str.split(/[ ?]/)[2..-1]
  end

  def answer
    op1 = @arr.shift.to_i
    until @arr.empty? do
      operator, op2 = @arr.shift(2)
      op2 = @arr.shift if op2 == 'by'
      sym = HSH.fetch(operator) { raise ArgumentError }
      # p "#{op1} #{sym.to_s} #{op2}"
      op1 = op1.send(sym, op2.to_i)
    end
    op1
  end
end


require 'minitest/autorun'
# require_relative 'wordy'

class WordProblemTest < Minitest::Test
  def test_add_1
    # skip
    assert_equal 2, WordProblem.new('What is 1 plus 1?').answer
  end

  def test_add_2
    # skip
    assert_equal 55, WordProblem.new('What is 53 plus 2?').answer
  end

  def test_add_negative_numbers
    # skip
    assert_equal(-11, WordProblem.new('What is -1 plus -10?').answer)
  end

  def test_add_more_digits
    # skip
    assert_equal 45_801, WordProblem.new('What is 123 plus 45678?').answer
  end

  def test_subtract
    # skip
    assert_equal 16, WordProblem.new('What is 4 minus -12?').answer
  end

  def test_multiply
    # skip
    assert_equal(-75, WordProblem.new('What is -3 multiplied by 25?').answer)
  end

  def test_divide
    # skip
    assert_equal(-11, WordProblem.new('What is 33 divided by -3?').answer)
  end

  def test_add_twice
    # skip
    question = 'What is 1 plus 1 plus 1?'
    assert_equal 3, WordProblem.new(question).answer
  end

  def test_add_then_subtract
    # skip
    question = 'What is 1 plus 5 minus -2?'
    assert_equal 8, WordProblem.new(question).answer
  end

  def test_subtract_twice
    # skip
    question = 'What is 20 minus 4 minus 13?'
    assert_equal 3, WordProblem.new(question).answer
  end

  def test_subtract_then_add
    # skip
    question = 'What is 17 minus 6 plus 3?'
    assert_equal 14, WordProblem.new(question).answer
  end

  def test_multiply_twice
    # skip
    question = 'What is 2 multiplied by -2 multiplied by 3?'
    assert_equal(-12, WordProblem.new(question).answer)
  end

  def test_add_then_multiply
    # skip
    question = 'What is -3 plus 7 multiplied by -2?'
    assert_equal(-8, WordProblem.new(question).answer)
  end

  def test_divide_twice
    # skip
    question = 'What is -12 divided by 2 divided by -3?'
    assert_equal 2, WordProblem.new(question).answer
  end

  def test_too_advanced
    # skip
    assert_raises ArgumentError do
      WordProblem.new('What is 53 cubed?').answer
    end
  end

  def test_irrelevant
    # skip
    assert_raises ArgumentError do
      WordProblem.new('Who is the president of the United States?').answer
    end
  end
end
