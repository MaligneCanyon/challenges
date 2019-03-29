# 3.25hrs
class Triplet
  def initialize(a, b, c)
    @a = a
    @b = b
    @c = c
  end

  def sum
    @a + @b + @c
  end

  def product
    @a * @b * @c
  end

  def pythagorean?
    @a**2 + @b**2 == @c**2
  end

  def self.where(sum: nil, min_factor: 1, max_factor: 1)
    arr = triplet_x(sum, min_factor, max_factor)
    arr.map { |triplet| Triplet.new(triplet[0], triplet[1], triplet[2]) }
  end

  def self.triplet_x(exp_sum=nil, amin=1, cmax)
    # p "exp_sum == #{exp_sum}, amin == #{amin}, cmax == #{cmax}"
    arr = []
    bmin = amin + 1
    bmax = cmax - 1
    amax = cmax - 2
    csqmax = cmax**2
    amin.upto(amax) do |a|
      bmin.upto(bmax) do |b|
        asq_plus_bsq = a**2 + b**2
        if asq_plus_bsq <= csqmax
          # puts "#{a}, #{b}"
          c = Integer.sqrt(asq_plus_bsq)
          if c**2 == asq_plus_bsq
            if exp_sum
              next unless exp_sum == a + b + c
            end
            arr << [a, b, c]
          end
        else
          break
        end
      end
      bmin += 1
    end
    arr
  end
end

# p Triplet.triplet_x(,,10) == [[3, 4, 5], [6, 8, 10]] # ????????????
p Triplet.triplet_x(nil, 1, 10) == [[3, 4, 5], [6, 8, 10]]
p Triplet.triplet_x(nil, 11, 20) == [[12, 16, 20]]
p Triplet.triplet_x(180, 1, 100) == [[18, 80, 82], [30, 72, 78], [45, 60, 75]]
p Triplet.where(sum: 180, max_factor: 100).map(&:product).sort == [118_080, 168_480, 202_500]

# p triplets = Triplet.where(max_factor: 10)
  # triplets.map(&:product) calls the Array#product method ... unless triplets
  # is an arr of Triplet instance
# p triplets.map(&:product)
# triplets.map do |subarr|
#   p subarr.product
#   subarr.product
# end


# triplet_x
# ---------
# inputs:
# - int (exp_sum)
# - int (amin)
# - int (cmax)
# outputs:
# - arr (of triplet subarrs)
# reqs:
# - given inputs
#   - the sum of int values a, b, c
#   - amin, and
#   - cmax,
#   gen an arr of triplets (subarrs of three ints: [a, b, c])
# rules:
# - a, b, c are always ints
# - a**2 + b**2 == c**2
# - a < b < c
# - amin == 1 (default)
# - bmin == amin + 1
# - bmax == cmax - 1
# - amax == cmax - 2
# struct:
# - arr
# algo:
# - init an arr to []
# - calc bmin, bmax, amax
# - calc csqmax (cmax**2)
# - for a = amin upto amax
#   - for b = bmin upto bmax
#     - calc asq_plus_bsq (a**2 + b**2)
#     - if asq_plus_bsq <= csqmax
#       - calc c (Integer.sqrt(asq_plus_bsq))
#       - if asq_plus_bsq is a perfect square (c**2 == asq_plus_bsq)
#         - if an exp_sum is present
#           - calc the act_sum (a + b + c)
#           - next unless exp_sum == act_sum
#         - save [a, b, c] to the arr
#     - else break
#   - incr bmin
# - rtn the arr

# where
# -----
# inputs:
# - int (min_factor as a keyword arg)
# - int (max_factor as a keyword arg)
# outputs:
# - arr (of Triplets)
# reqs:
# - given an input max_factor, and an optional min_factor
#   gen an arr of Triplets (triplet subarrs of three ints: [a, b, c])
# rules:
# - none
# struct:
# - arr
# algo:
# - call triplet_x to calc the arr of triplets
# - for each subarr in the arr
#   - call Triplet.new w/ the subarr elems as args
#   - map the new Triplet to the subarr
# - rtn the arr


require 'minitest/autorun'
# require_relative 'triplet'

class TripletTest < MiniTest::Unit::TestCase
  def test_sum
    # skip
    assert_equal 12, Triplet.new(3, 4, 5).sum
  end

  def test_product
    # skip
    assert_equal 60, Triplet.new(3, 4, 5).product
  end

  def test_pythagorean
    # skip
    assert Triplet.new(3, 4, 5).pythagorean?
  end

  def test_not_pythagorean
    # skip
    assert !Triplet.new(5, 6, 7).pythagorean?
  end

  def test_triplets_upto_10
    # skip
    triplets = Triplet.where(max_factor: 10)
    products = triplets.map(&:product).sort
    assert_equal [60, 480], products
  end

  def test_triplets_from_11_upto_20
    # skip
    triplets = Triplet.where(min_factor: 11, max_factor: 20)
    products = triplets.map(&:product).sort
    assert_equal [3840], products
  end

  def test_triplets_where_sum_x
    # skip
    triplets = Triplet.where(sum: 180, max_factor: 100)
    products = triplets.map(&:product).sort
    assert_equal [118_080, 168_480, 202_500], products
  end
end
