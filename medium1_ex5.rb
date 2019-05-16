# see '../courses/oo_programming/exercises/medium1_ex4.rb'

class CircularBuffer
  # you can def an Exception class w/i another custom class
  class BufferEmptyException < StandardError; end
  class BufferFullException < StandardError; end

  attr_accessor :arr, :newest, :oldest

  def initialize(size)
    @arr = Array.new(size, nil)
    @oldest = nil
    @newest = nil
  end

  def write(value)
    if newest && incr(newest) == oldest
      raise BufferFullException
    else
      write!(value)
    end
  end

  def write!(value)
    if value # prevent adding nil to the arr
      if newest # there's something other than nil in the arr
        self.newest = incr(newest)
        self.oldest = incr(oldest) if newest == oldest  # we are replacing the oldest elem
      else # all arr elems are nil
        self.newest = 0
        self.oldest = 0
      end
      arr[newest] = value
    end
  end

  def read
    raise BufferEmptyException if arr.none? # raise an err if all arr elems are nil
    value = arr[oldest] # save the oldest arr elem
    arr[oldest] = nil # replace the oldest elem w/ nil
    if arr.none? # there was only one non-nil elem left
      self.oldest = nil
      self.newest = nil
    else
      self.oldest = incr(oldest)
    end
    value # rtn the (saved) oldest arr elem
  end

  def clear
    arr.fill(nil)
    self.oldest = nil
    self.newest = nil
  end

  def incr(ndx)
    ndx += 1
    # ndx = 0 if ndx == arr.size # rollover
    # ndx
    ndx %= arr.size # handle rollover
  end
end


require 'minitest/autorun'
# require_relative 'circular_buffer'

class CircularBufferTest < Minitest::Test
  def test_read_empty_buffer_throws_buffer_empty_exception
    buffer = CircularBuffer.new(1)
    assert_raises(CircularBuffer::BufferEmptyException) { buffer.read }
  end

  def test_write_and_read_back_one_item
    # skip
    buffer = CircularBuffer.new(1)
    buffer.write '1'
    assert_equal '1', buffer.read
    assert_raises(CircularBuffer::BufferEmptyException) { buffer.read }
  end

  def test_write_and_read_back_multiple_items
    # skip
    buffer = CircularBuffer.new(2)
    buffer.write '1'
    buffer.write '2'
    assert_equal '1', buffer.read
    assert_equal '2', buffer.read
    assert_raises(CircularBuffer::BufferEmptyException) { buffer.read }
  end

  def test_clearing_buffer
    # skip
    buffer = CircularBuffer.new(3)
    ('1'..'3').each { |i| buffer.write i }
    buffer.clear
    assert_raises(CircularBuffer::BufferEmptyException) { buffer.read }
    buffer.write '1'
    buffer.write '2'
    assert_equal '1', buffer.read
    buffer.write '3'
    assert_equal '2', buffer.read
  end

  def test_alternate_write_and_read
    # skip
    buffer = CircularBuffer.new(2)
    buffer.write '1'
    assert_equal '1', buffer.read
    buffer.write '2'
    assert_equal '2', buffer.read
  end

  def test_reads_back_oldest_item
    # skip
    buffer = CircularBuffer.new(3)
    buffer.write '1'
    buffer.write '2'
    buffer.read
    buffer.write '3'
    assert_equal '2', buffer.read
    assert_equal '3', buffer.read
  end

  def test_writes_of_nil_should_not_occupy_buffer
    # skip
    buffer = CircularBuffer.new(5)
    buffer.write nil
    ('1'..'3').each { |i| buffer.write i }
    assert_equal '1', buffer.read
  end

  def test_writing_to_a_full_buffer_throws_an_exception
    # skip
    buffer = CircularBuffer.new(2)
    buffer.write '1'
    buffer.write '2'
    assert_raises(CircularBuffer::BufferFullException) { buffer.write 'A' }
  end

  def test_overwriting_oldest_item_in_a_full_buffer
    # skip
    buffer = CircularBuffer.new(2)
    buffer.write '1'
    buffer.write '2'
    buffer.write! 'A'
    assert_equal '2', buffer.read
    assert_equal 'A', buffer.read
    assert_raises(CircularBuffer::BufferEmptyException) { buffer.read }
  end

  def test_forced_writes_of_nil_should_not_occupy_buffer
    # skip
    buffer = CircularBuffer.new(2)
    ('1'..'2').each { |i| buffer.write i }
    buffer.write! nil
    assert_equal '1', buffer.read
    assert_equal '2', buffer.read
    assert_raises(CircularBuffer::BufferEmptyException) { buffer.read }
  end

  def test_forced_writes_to_non_full_buffer_should_behave_like_writes
    # skip
    buffer = CircularBuffer.new(2)
    buffer.write '1'
    buffer.write! '2'
    assert_equal '1', buffer.read
    assert_equal '2', buffer.read
    assert_raises(CircularBuffer::BufferEmptyException) { buffer.read }
  end

  # rubocop:disable Metrics/MethodLength
  def test_alternate_read_and_write_into_buffer_overflow
    # skip
    buffer = CircularBuffer.new(5)
    ('1'..'3').each { |i| buffer.write i }
    buffer.read
    buffer.read
    buffer.write '4'
    buffer.read
    ('5'..'8').each { |i| buffer.write i }
    buffer.write! 'A'
    buffer.write! 'B'
    ('6'..'8').each do |i|
      assert_equal i, buffer.read
    end
    assert_equal 'A', buffer.read
    assert_equal 'B', buffer.read
    assert_raises(CircularBuffer::BufferEmptyException) { buffer.read }
  end
  # rubocop:enable Metrics/MethodLength
end
