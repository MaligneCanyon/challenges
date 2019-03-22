# inputs:
# - str
# - n
# outputs:
# - strs (since leading zeros matter)
# reqs:
# - take a str (a str rep of an int)
# - rtn a list of consecutive n-char substrs of that str
# - rtn err if n > str.size
# rules:
# - should rtn str.size - n substrs
# struct:
# - str
# - arr
# algo:
# - if n > str.size, return [] (or raise ArgumentError)
# - init a new_arr to []
# - for each ndx from 0 to (str.size - n)
#   - obtain substr str[ndx...(ndx + n)]
#   - split the substr into a subarr of chars
#   - map the subarr of chars to a subarr of ints
#   - copy the subarr of ints to the new_arr
# - rtn the new_arr

class Series
  def initialize(str)
    @str = str
  end

  # def slices(n)
  #   raise ArgumentError if n > @str.size
  #   arr = []
  #   (0..(@str.size - n)).each do |ndx|
  #     substr = @str[ndx...(ndx + n)]
  #     arr << substr.chars.map(&:to_i)
  #   end
  #   arr
  # end

  def slices(n)
    raise ArgumentError if n > @str.size
    arr = []
    @str.chars.map(&:to_i).each_cons(n) { |subarr| arr << subarr }
    arr
  end
end

p Series.new('01234').slices(3) == [[0,1,2], [1,2,3], [2,3,4]]
p Series.new('01234').slices(4) == [[0,1,2,3], [1,2,3,4]]
# p Series.new('01234').slices(6) == [] # or raises ArgumentError


require 'minitest/autorun'
# require_relative 'series'

class SeriesTest < Minitest::Test
  def test_simple_slices_of_one
    series = Series.new('01234')
    assert_equal [[0], [1], [2], [3], [4]], series.slices(1)
  end

  def test_simple_slices_of_one_again
    # skip
    series = Series.new('92834')
    assert_equal [[9], [2], [8], [3], [4]], series.slices(1)
  end

  def test_simple_slices_of_two
    # skip
    series = Series.new('01234')
    assert_equal [[0, 1], [1, 2], [2, 3], [3, 4]], series.slices(2)
  end

  def test_other_slices_of_two
    # skip
    series = Series.new('98273463')
    expected = [[9, 8], [8, 2], [2, 7], [7, 3], [3, 4], [4, 6], [6, 3]]
    assert_equal expected, series.slices(2)
  end

  def test_simple_slices_of_two_again
    # skip
    series = Series.new('37103')
    assert_equal [[3, 7], [7, 1], [1, 0], [0, 3]], series.slices(2)
  end

  def test_simple_slices_of_three
    # skip
    series = Series.new('01234')
    assert_equal [[0, 1, 2], [1, 2, 3], [2, 3, 4]], series.slices(3)
  end

  def test_simple_slices_of_three_again
    # skip
    series = Series.new('31001')
    assert_equal [[3, 1, 0], [1, 0, 0], [0, 0, 1]], series.slices(3)
  end

  def test_other_slices_of_three
    # skip
    series = Series.new('982347')
    expected = [[9, 8, 2], [8, 2, 3], [2, 3, 4], [3, 4, 7]]
    assert_equal expected, series.slices(3)
  end

  def test_simple_slices_of_four
    # skip
    series = Series.new('01234')
    assert_equal [[0, 1, 2, 3], [1, 2, 3, 4]], series.slices(4)
  end

  def test_simple_slices_of_four_again
    # skip
    series = Series.new('91274')
    assert_equal [[9, 1, 2, 7], [1, 2, 7, 4]], series.slices(4)
  end

  def test_simple_slices_of_five
    # skip
    series = Series.new('01234')
    assert_equal [[0, 1, 2, 3, 4]], series.slices(5)
  end

  def test_simple_slices_of_five_again
    # skip
    series = Series.new('81228')
    assert_equal [[8, 1, 2, 2, 8]], series.slices(5)
  end

  def test_simple_slice_that_blows_up
    # skip
    series = Series.new('01234')
    assert_raises ArgumentError do
      series.slices(6)
    end
  end

  def test_more_complicated_slice_that_blows_up
    # skip
    slice_string = '01032987583'
    series = Series.new(slice_string)
    assert_raises ArgumentError do
      series.slices(slice_string.length + 1)
    end
  end
end
