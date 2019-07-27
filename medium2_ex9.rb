# Since R. doesn't utilize pointers, @datum is actually the current elem,
# and the "tail" is the next elem

class Element
  attr_accessor :datum, :next

  def initialize(datum, next_node=nil)
    @datum = datum
    @next = next_node
  end

  def tail? # exactly what are we supposed to be testing here ???
    self.instance_variables.include?(:@next)
  end
end


class SimpleLinkedList
  attr_accessor :datum

  def initialize(data=nil)
    @datum = data ? Element.new(data, nil) : nil
  end

  def to_a
    return [] unless @datum
    arr = []
    current_node = @datum
    loop do
      arr << current_node.datum
      break unless current_node.next
      current_node = current_node.next
    end
    arr
  end

  def size
    to_a.size
  end

  def empty?
    to_a.empty?
  end

  def push(data)
    @datum = Element.new(data, @datum)
  end

  def peek # take a look at the value of the most recently added elem
    to_a.first
  end

  def head # retreive the top-level elem from the linked list
    datum
  end

  def pop
    data = head.datum # save the top-level data
    self.datum = head.next # set the top-level elem to the next elem in the list
    data # rtn the popped data
  end

  def self.from_a(arr)
    arr ||= [] # set nil arr to an empty arr
    arr = arr.reverse # due to order in which elems are added to the linked list
    linked_list = self.new(arr.first) # if arr.empty? then arr.first == nil
    (1...arr.size).each { |ndx| linked_list.push(arr[ndx]) } unless arr.empty?
    linked_list
  end

  def reverse
    # to reverse a linked list, convert it to an arr and reverse the arr,
    # then convert that reversed arr back into a linked list
    SimpleLinkedList.from_a(to_a.reverse)
  end
end


require 'minitest/autorun'
# require_relative 'simple_linked_list'

class LinkedListTest < Minitest::Test
  def test_element_datum
    # skip
    e = Element.new(1)
    assert_equal 1, e.datum
  end

  def test_element_tail
    # skip
    e = Element.new(1)
    assert e.tail?
  end

  def test_element_next_default
    # skip
    e = Element.new(1)
    assert_nil e.next
  end

  def test_element_next_initialization
    # skip
    e1 = Element.new(1)
    e2 = Element.new(2, e1)
    assert_equal e1, e2.next
  end

  def test_empty_list_size
    # skip
    l = SimpleLinkedList.new
    assert_equal 0, l.size
  end

  def test_empty_list_empty
    # skip
    l = SimpleLinkedList.new
    assert l.empty?
  end

  def test_pushing_element_on_list
    # skip
    l = SimpleLinkedList.new
    l.push(1)
    assert_equal 1, l.size
  end

  def test_empty_list_1_element
    # skip
    l = SimpleLinkedList.new
    l.push(1)
    refute l.empty?
  end

  def test_peeking_at_list
    # skip
    l = SimpleLinkedList.new
    l.push(1)
    assert_equal 1, l.size
    assert_equal 1, l.peek
  end

  def test_peeking_at_empty_list
    # skip
    l = SimpleLinkedList.new
    assert_nil l.peek
  end

  def test_access_head_element
    # skip
    l = SimpleLinkedList.new
    l.push(1)
    assert_instance_of Element, l.head
    assert_equal 1, l.head.datum
    assert l.head.tail?
  end

  def test_items_are_stacked
    # skip
    l = SimpleLinkedList.new
    l.push(1)
    l.push(2)
    assert_equal 2, l.size
    assert_equal 2, l.head.datum
    assert_equal 1, l.head.next.datum
  end

  def test_push_10_items
    # skip
    l = SimpleLinkedList.new
    (1..10).each do |datum|
      l.push(datum)
    end
    assert_equal 10, l.size
    assert_equal 10, l.peek
  end

  def test_pop_1_item
    # skip
    l = SimpleLinkedList.new
    l.push(1)
    assert_equal 1, l.pop
    assert_equal 0, l.size
  end

  def test_popping_frenzy
    # skip
    l = SimpleLinkedList.new
    (1..10).each do |datum|
      l.push(datum)
    end
    6.times { l.pop }
    assert_equal 4, l.size
    assert_equal 4, l.peek
  end

  def test_from_a_empty_array
    # skip
    l = SimpleLinkedList.from_a([])
    assert_equal 0, l.size
    assert_nil l.peek
  end

  def test_from_a_nil
    # skip
    l = SimpleLinkedList.from_a(nil)
    assert_equal 0, l.size
    assert_nil l.peek
  end

  def test_from_a_2_element_array
    # skip
    l = SimpleLinkedList.from_a([1, 2])
    assert_equal 2, l.size
    assert_equal 1, l.peek
    assert_equal 2, l.head.next.datum
  end

  def test_from_a_10_items
    # skip
    l = SimpleLinkedList.from_a((1..10).to_a)
    assert_equal 10, l.size
    assert_equal 1, l.peek
    assert_equal 10, l.head.next.next.next.next.next.next.next.next.next.datum
  end

  def test_to_a_empty_list
    # skip
    l = SimpleLinkedList.new
    assert_equal [], l.to_a
  end

  def test_to_a_of_1_element_list
    # skip
    assert_equal [1], SimpleLinkedList.from_a([1]).to_a
  end

  def test_to_a_of_2_element_list
    # skip
    assert_equal [1, 2], SimpleLinkedList.from_a([1, 2]).to_a
  end

  def test_reverse_2_element_list
    # skip
    list = SimpleLinkedList.from_a([1, 2])
    # list_r and list need not be the same object
    list_r = list.reverse

    assert_equal 2, list_r.peek
    assert_equal 1, list_r.head.next.datum
    assert list_r.head.next.tail?
  end

  def test_reverse_10_element_list
    # skip
    data = (1..10).to_a
    list = SimpleLinkedList.from_a(data)
    assert_equal data.reverse, list.reverse.to_a
  end

  def test_roundtrip_10_element_array
    # skip
    data = (1..10).to_a
    assert_equal data, SimpleLinkedList.from_a(data).to_a
  end
end
