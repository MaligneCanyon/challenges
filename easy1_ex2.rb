# inputs:
# - int (the max num in a range)
# outputs:
# - arr of ints (prime nums)
# reqs:
# - for each num in a range from 2 to a max value
#   - delete all multiples of num in the range
# - rtn the remaining values
# rules:
# - start at 2 (exclude 1)
# struct:
# - range
# - arr
# algo:
# - create a range from 2 to the input max num
# - convert the range to an arr
# - for each elem in the arr
#   - skip the elem if its value is nil
#   - for each multiple of the elem up to the max num
#     - replace the multiple w/ nil
# - delete all occurences of nil in the arr
# - rtn the arr

class Sieve
  def initialize(limit)
    @limit = limit
  end

  def primes
    arr = (2..@limit).to_a
    arr.each do |num|
      next unless num
      (num + num).step(by: num, to: @limit) do |multiple|
        arr[arr.index(multiple)] = nil if arr.include?(multiple)
      end
    end
    arr.compact
  end
end

p Sieve.new(10).primes

require 'minitest/autorun'
# require_relative 'sieve'

class SieveTest < Minitest::Test
  def test_a_few_primes
    expected = [2, 3, 5, 7]
    assert_equal expected, Sieve.new(10).primes
  end

  def test_primes
    # skip
    expected = [
      2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59,
      61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127,
      131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191,
      193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 251, 257,
      263, 269, 271, 277, 281, 283, 293, 307, 311, 313, 317, 331,
      337, 347, 349, 353, 359, 367, 373, 379, 383, 389, 397, 401,
      409, 419, 421, 431, 433, 439, 443, 449, 457, 461, 463, 467,
      479, 487, 491, 499, 503, 509, 521, 523, 541, 547, 557, 563,
      569, 571, 577, 587, 593, 599, 601, 607, 613, 617, 619, 631,
      641, 643, 647, 653, 659, 661, 673, 677, 683, 691, 701, 709,
      719, 727, 733, 739, 743, 751, 757, 761, 769, 773, 787, 797,
      809, 811, 821, 823, 827, 829, 839, 853, 857, 859, 863, 877,
      881, 883, 887, 907, 911, 919, 929, 937, 941, 947, 953, 967,
      971, 977, 983, 991, 997
    ]
    assert_equal expected, Sieve.new(1000).primes
  end
end