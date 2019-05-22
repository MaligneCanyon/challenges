# approach
# - obtain a list of factors for a num
# - add the factors excluding the num

# inputs:
# - int
# outputs:
# - str
# reqs:
# - determine whether the sum of factors of a positive int (excluding the int
#   itself) is equal to, less than, or greater than the int
# rules:
#     Perfect: Sum of factors = number
#     Abundant: Sum of factors > number
#     Deficient: Sum of factors < number
# struct:
# - arr (to hold factors)
# algo:
# - rtn an err if the num < 1
# - init an arr to [1]
# - for each "factor" from 2 upto floor(sqrt(num))
#   - if the "factor" divides evenly into the num
#     - add the factor and the quotient to the arr
# - sum the arr values
# - rtn a str comparing the sum to the original num

class PerfectNumber
  # def self.classify(num)
  #   raise RuntimeError if num < 1
  #   arr = [1]
  #   2.upto(Integer.sqrt(num)) do |factor|
  #     quotient, rem = num.divmod(factor)
  #     arr << [factor, quotient] if rem.zero?
  #   end
  #   sum = arr.flatten.sum
  #   case (sum <=> num)
  #     when -1 then 'deficient'
  #     when  0 then 'perfect'
  #     when  1 then 'abundant'
  #   end
  # end

  def self.classify(num)
    raise RuntimeError if num < 1
    arr = [1]
    2.upto(Integer.sqrt(num)) do |factor|
      quotient, rem = num.divmod(factor)
      arr << [factor, quotient] if rem.zero?
    end
    sum = arr.flatten.sum
    %w(deficient perfect abundant)[(sum <=> num) + 1]
  end
end


require 'minitest/autorun'
# require_relative 'perfect_numbers'

class PerfectNumberTest < Minitest::Test
  def test_initialize_perfect_number
    assert_raises RuntimeError do
      PerfectNumber.classify(-1)
    end
  end

  def test_classify_deficient
    assert_equal 'deficient', PerfectNumber.classify(13)
  end

  def test_classify_perfect
    assert_equal 'perfect', PerfectNumber.classify(28)
  end

  def test_classify_abundant
    assert_equal 'abundant', PerfectNumber.classify(12)
  end
end
