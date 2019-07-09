# inputs:
# - int (the num of rows in the triangle)
# outputs:
# - arr (w/ subarrs representing each row in the triangle)
# reqs:
# - for each row
#   - calc the row elems
#   - add those elems to a subarr
#   - add the subarr to the output arr
# - rtn the output arr
# rules:
# - if num == 1, arr == [[1]] (first row's subarr is always [1])
# - first and last elems of a subarr are always 1
# struct:
# - arr
# algo:
# - init an arr to [[1]]
# - for each row from 1 to num minus 1
#   - init the subarr to []
#   - for each ndx from 0 to row
#     - calc the subarr value at the current ndx
#       - if ndx == 0 or ndx == row
#         - 1
#       - else
#         - the previous subarr value at (ndx minus 1) plus
#           the previous subarr value at ndx
#   - push the subarr to the arr
# - rtn the arr

class Triangle
  def initialize(num)
    @num = num
  end

  def rows
    arr = [[1]]
    (1...@num).each do |row|
      subarr = []
      (0..row).each do |ndx|
        subarr << (ndx.zero? || ndx == row ? 1 : arr[row - 1][ndx - 1] + arr[row - 1][ndx])
      end
      arr << subarr
    end
    arr
  end
end


require 'minitest/autorun'
# require_relative 'pascals_triangle'

class TriangleTest < Minitest::Test
  def test_one_row
    # skip
    triangle = Triangle.new(1)
    assert_equal [[1]], triangle.rows
  end

  def test_two_rows
    # skip
    triangle = Triangle.new(2)
    assert_equal [[1], [1, 1]], triangle.rows
  end

  def test_three_rows
    # skip
    triangle = Triangle.new(3)
    assert_equal [[1], [1, 1], [1, 2, 1]], triangle.rows
  end

  def test_fourth_row
    # skip
    triangle = Triangle.new(4)
    assert_equal [1, 3, 3, 1], triangle.rows.last
  end

  def test_fifth_row
    # skip
    triangle = Triangle.new(5)
    assert_equal [1, 4, 6, 4, 1], triangle.rows.last
  end

  def test_twentieth_row
    # skip
    triangle = Triangle.new(20)
    expected = [
      1, 19, 171, 969, 3876, 11_628, 27_132, 50_388, 75_582, 92_378, 92_378,
      75_582, 50_388, 27_132, 11_628, 3876, 969, 171, 19, 1
    ]
    assert_equal expected, triangle.rows.last
  end
end
