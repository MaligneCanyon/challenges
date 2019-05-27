class Palindromes
  attr_accessor :factors, :products

  def initialize(max_factor:, min_factor: 1) # don't actually need to spec a value
    @max = max_factor
    @min = min_factor
    @factors = []
    @products = []
  end

# generate
# ========
# inputs:
# - ints (max_factor and min_factor)
# outputs:
# - arr (w/ subarrs consisting of factor pairs)
# reqs:
# - compute all products of two ints w/i a given range (min_factor to
#   max_factor)
# - if a product is a palindromic number, add the pair of ints to the obj's
#   @factors arr and the palindromic number to the obj's @products arr
# rules:
# - none
# struct:
# - arr
# algo:
# - int1 = min_factor
# - while int1 <= max_factor
#   - int2 = int1
#   - while int2 <= max_factor
#     - multiply int1 by int2
#     - if the product is a palindromic number
#       - add the pair of ints to @factors arr
#       - add the palindromic number to the @products arr
#     - incr int2
#   - incr int1

  # def generate
  #   int1 = int2 = @min
  #   (@min..@max).each do |int1|
  #     (int1..@max).each do |int2|
  #       product = int1 * int2
  #       # puts "product == #{product}, int1 == #{int1}, int2 == #{int2}"
  #       if product.to_s.reverse == product.to_s
  #         @factors << [int1, int2]
  #         @products << product
  #       end
  #     end
  #   end
  # end

  def generate
    arr = (@min..@max).to_a.repeated_combination(2).to_a
    arr.each do |subarr|
      product = subarr.first * subarr.last
      if product.to_s.reverse == product.to_s
        @factors << subarr
        @products << product
      end
    end
  end

  def largest
    pal_selector(self.products.max)
  end

  def smallest
    pal_selector(self.products.min)
  end

  def value
    @products.first
  end

# pal_selector
# ============
# inputs:
# - original palindrome obj
# outputs:
# - modified palindrome obj
# reqs:
# - select the min (or max) palindromic number from the @products arr
# - select the factors for the min (or max) palindromic numbers
# rules:
# - none
# struct:
# - arr
# algo:
# - clone the original palindromic obj
# - select the min (or max) palindromic number from the original @products arr
#   - @products = [self.products.min] (or [self.products.max])
# - select the factors for the min (or max) palindromic numbers
#   - select the factors from the original @factors arr with indices that
#     correspond to where the product in the original @products arr is equal
#     to the min (or max) product
# - rtn the modified palindromic obj

  private
  def pal_selector(single_product)
    pals = self.clone
    pals.products = [single_product]
    pals.factors = self.factors.select.with_index do |_, ndx|
      self.products[ndx] == single_product
    end
    pals
  end
end


require 'minitest/autorun'
# require_relative 'palindrome_products'

class PalindromesTest < Minitest::Test
  def test_largest_palindrome_from_single_digit_factors
    # skip
    palindromes = Palindromes.new(max_factor: 9)
    palindromes.generate
    largest = palindromes.largest
    assert_equal 9, largest.value
    assert_includes [[[3, 3], [1, 9]], [[1, 9], [3, 3]]], largest.factors
  end

  def test_largest_palindrome_from_double_digit_factors
    # skip
    palindromes = Palindromes.new(max_factor: 99, min_factor: 10)
    palindromes.generate
    largest = palindromes.largest
    assert_equal 9009, largest.value
    assert_equal [[91, 99]], largest.factors
  end

  def test_smallest_palindrome_from_double_digit_factors
    # skip
    palindromes = Palindromes.new(max_factor: 99, min_factor: 10)
    palindromes.generate
    smallest = palindromes.smallest
    assert_equal 121, smallest.value
    assert_equal [[11, 11]], smallest.factors
  end

  def test_largest_palindrome_from_triple_digit_factors
    # skip
    palindromes = Palindromes.new(max_factor: 999, min_factor: 100)
    palindromes.generate
    largest = palindromes.largest
    assert_equal 906_609, largest.value
    assert_equal [[913, 993]], largest.factors
  end

  def test_smallest_palindrome_from_triple_digit_factors
    # skip
    palindromes = Palindromes.new(max_factor: 999, min_factor: 100)
    palindromes.generate
    smallest = palindromes.smallest
    assert_equal 10_201, smallest.value
    assert_equal [[101, 101]], smallest.factors
  end
end
