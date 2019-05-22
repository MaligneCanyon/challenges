# inputs:
# - int (the n in "nth prime")
# outputs:
# - int (the nth prime num)
# reqs:
# - determine the nth prime
# rules:
# - only test those prime numbers up to the sqrt of a candidate num (to see if
#   they are factors of the num; if not, then the num itself is prime)
# struct:
# - arr (to hold primes)
# algo:
# - raise an err if n < 1
# - init an arr to []
# - init a candidate to 2
# - while arr.size < n
#   - set a flag to true
#   - for each elem of the arr
#     - break if elem > sqrt(candidate)
#     - if the elem divides evenly into the candidate
#       - set the flag to false
#       - break (the candidate was not prime)
#   - if the flag is true
#     - add the candidate to the arr
#   - increment the candidate
# - rtn the last arr elem

class Prime
  # def self.nth(n)
  #   raise ArgumentError if n < 1
  #   arr = []
  #   candidate = 1
  #   loop do
  #     prime = true
  #     root = Integer.sqrt(candidate)
  #     arr.each do |elem|
  #       break if elem > root
  #       if (candidate % elem).zero?
  #         prime = false
  #         break
  #       end
  #     end
  #     arr << candidate if prime
  #     break unless arr.size < n
  #     candidate += 1
  #   end
  #   arr.last
  # end

  def self.nth(n)
    raise ArgumentError if n < 1
    arr = [2]
    candidate = 3
    until arr.size == n do
      prime = true
      root = Integer.sqrt(candidate)
      arr.each do |elem|
        break if elem > root
        if (candidate % elem).zero?
          prime = false
          break
        end
      end
      arr << candidate if prime
      candidate += 2
    end
    arr.last
  end
end


# Test suite:

require 'prime'

ERROR_MESSAGE = <<-MSG.freeze
Using Ruby's Prime class is probably the best way to do this in a
'real' application; but this is an exercise, not a real application,
so you're expected to implement this yourself.
MSG

# This code prevents you from using any of the prohibited methods.

class Prime
  [:each, :new, :prime?, :take].each do |m|
    define_method(m) { |*_| fail ERROR_MESSAGE }
  end
end

class Integer
  [:prime?, :each_prime].each do |m|
    define_method(m) { |*_| fail ERROR_MESSAGE }
  end
end

# Actual test suite begins here.

require 'minitest/autorun'
# require_relative 'nth_prime'

class TestPrimes < Minitest::Test
  def test_first
    # skip
    assert_equal 2, Prime.nth(1)
  end

  def test_second
    # skip
    assert_equal 3, Prime.nth(2)
  end

  def test_sixth_prime
    # skip
    assert_equal 13, Prime.nth(6)
  end

  def test_big_prime
    # skip
    assert_equal 104_743, Prime.nth(10_001)
  end

  def test_weird_case
    # skip
    assert_raises ArgumentError do
      Prime.nth(0)
    end
  end
end
