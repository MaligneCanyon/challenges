# ::to
# ====
# inputs:
# - arr of ints (an unspecified number of inputs)
# - int (a max num)
# outputs:
# - int (a sum)
# reqs:
# - given a list of ints (defaulting to [3, 5]) and a max value
#   - find all multiples of each int up to but excluding the max value
# - rtn the sum of the unique multiples
# rules:
# - none
# struct:
# - arr
# algo:
# - init a new_arr to []
# - for each elem in the input arr
#   - while the elem value is < the max value
#     - copy the elem value to the new_arr
#     - incr the elem value by itself
# - sum the unique values in the new_arr
# - rtn the sum

class SumOfMultiples
  def initialize(*arr) # arg is an unbundled list of elems
    @arr = arr
  end

  # def self.to(arr=[3, 5], max)
  #   new_arr = []
  #   arr.each do |elem|
  #     multiple = elem
  #     while multiple < max
  #       new_arr << multiple
  #       multiple += elem
  #     end
  #   end
  #   new_arr.uniq.sum
  # end

  def self.to(arr=[3, 5], max)
    new_arr = []
    arr.each do |elem|
      elem.step(by: elem, to: max - 1) { |multiple| new_arr << multiple }
    end
    new_arr.uniq.sum
  end

  def to(max) # call the ::to class method using the input list of ints
    SumOfMultiples.to(@arr, max)
  end
end

p SumOfMultiples.to(20) == 78 # calls the ::to class method
p SumOfMultiples.new(3, 5).to(20) == 78 # calls the #to instance method


require 'minitest/autorun'
# require_relative 'sum_of_multiples'

class SumTest < Minitest::Test
  def test_sum_to_1
    # skip
    assert_equal 0, SumOfMultiples.to(1)
  end

  def test_sum_to_3
    # skip
    assert_equal 3, SumOfMultiples.to(4)
  end

  def test_sum_to_10
    # skip
    assert_equal 23, SumOfMultiples.to(10)
  end

  def test_sum_to_100
    # skip
    assert_equal 2_318, SumOfMultiples.to(100)
  end

  def test_sum_to_1000
    # skip
    assert_equal 233_168, SumOfMultiples.to(1000)
  end

  def test_configurable_7_13_17_to_20
    # skip
    assert_equal 51, SumOfMultiples.new(7, 13, 17).to(20)
  end

  def test_configurable_4_6_to_15
    # skip
    assert_equal 30, SumOfMultiples.new(4, 6).to(15)
  end

  def test_configurable_5_6_8_to_150
    # skip
    assert_equal 4419, SumOfMultiples.new(5, 6, 8).to(150)
  end

  def test_configurable_43_47_to_10000
    # skip
    assert_equal 2_203_160, SumOfMultiples.new(43, 47).to(10_000)
  end
end
