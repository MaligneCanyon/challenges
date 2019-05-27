# approach:
# - in the tests, student name is rep'd by a method name
# - student name is just a way to rep pos in the garden
# - 2x24 arr (always 2 rows, 12 or fewer cols)
# - up to 12 owners, owning a blk of 4 elems in the arr
# - determine the contents of (the plant names w/i) each blk
# - similar methods for each student name
# inputs:
# - sym (a student name, in the form of a method name)
# - str ("\n" sep'd, each line representing a row in the arr)
# outputs:
# - arr (4 syms representing the contents of the specified blk)
# reqs:
# - determine the contents of a 2x2 blk of elems in a 2x24 arr
# rules:
# - ndx = 0   -> arr[0][0], arr[0][1]
#                arr[1][0], arr[1][1]
#   ndx = 1   -> arr[0][2], arr[0][3]
#                arr[1][2], arr[1][3]
#   ndx = 2   -> arr[0][4], arr[0][5]
#                arr[1][4], arr[1][4]
#   etc.
# - generally -> arr[0][n*2], arr[0][n*2+1]
#                arr[1][n*2], arr[1][n*2+1]
# struct:
# - arr (to hold the letters representing the dif plants)
# - hsh (to map plant letters to corresponding syms)
# algo:
# - create a hsh to map plant letters to corresponding syms
# - split the input str into a 2x1 arr
# - split each row of the arr into a subarr of chars
# - define a method that relates the calling method (i.e. student name) to
#   an ndx in the arr
# - copy the arr values for the ndx to a new_arr
# - map the elems of the new_arr (plant letters) to syms
# - rtn the new_arr

PLANTS = {
  'G' => :grass,
  'C' => :clover,
  'R' => :radishes,
  'V' => :violets
}
NAMES = %w(Alice Bob Charlie David Eve Fred Ginny Harriet Ileana Joseph Kincaid Larry)

class Garden
  def initialize(str, students=NAMES)
    @arr = str.split("\n").map { |row| row.split("") }
    @students = students.sort # in case they are not sorted alphabetically
    define_student_methods # define a method for each student name
  end

  # explicitly defining a method for each student works, but it's not dynamic;
  # you must know the names of the students in advance
  # def alice
  #   plants(0)
  # end
  # etc ...

  # this (partially) works too, but relies on the student names being present
  # in the NAMES arr
  # (0...PLANTS.size).each do |ndx|
  #   define_method(NAMES[ndx].downcase.to_sym) { plants(ndx) }
  # end

  # this works using define_singleton_method
  # (define_method does not work w/ a particular obj instance);
  # must call #define_student_methods from initialize
  def define_student_methods
    @students.each_with_index do |student, ndx|
      define_singleton_method(student.downcase.to_sym) { plants(ndx) }
    end
  end

  def plants(n)
    # new_arr = [@arr[0][n * 2], @arr[0][n * 2 + 1], @arr[1][n * 2], @arr[1][n * 2 + 1]]
    # new_arr.map { |elem| PLANTS[elem] }
    [PLANTS[@arr[0][n * 2]], PLANTS[@arr[0][n * 2 + 1]],
     PLANTS[@arr[1][n * 2]], PLANTS[@arr[1][n * 2 + 1]]]
  end
end


require 'minitest/autorun'
# require_relative 'kindergarten_garden'

class GardenTest < Minitest::Test
  def test_alices_garden
    # skip
    garden = Garden.new("RC\nGG")
    assert_equal [:radishes, :clover, :grass, :grass], garden.alice
  end

  def test_different_garden_for_alice
    # skip
    garden = Garden.new("VC\nRC")
    assert_equal [:violets, :clover, :radishes, :clover], garden.alice
  end

  def test_bobs_garden
    # skip
    garden = Garden.new("VVCG\nVVRC")
    assert_equal [:clover, :grass, :radishes, :clover], garden.bob
  end

  def test_bob_and_charlies_gardens
    # skip
    garden = Garden.new("VVCCGG\nVVCCGG")
    assert_equal [:clover, :clover, :clover, :clover], garden.bob
    assert_equal [:grass, :grass, :grass, :grass], garden.charlie
  end
end


class TestFullGarden < Minitest::Test
  def setup
    # skip
    diagram = "VRCGVVRVCGGCCGVRGCVCGCGV\nVRCCCGCRRGVCGCRVVCVGCGCV"
    @garden = Garden.new(diagram)
  end

  attr_reader :garden

  def test_alice
    # skip
    assert_equal [:violets, :radishes, :violets, :radishes], garden.alice
  end

  def test_bob
    # skip
    assert_equal [:clover, :grass, :clover, :clover], garden.bob
  end

  def test_charlie
    # skip
    assert_equal [:violets, :violets, :clover, :grass], garden.charlie
  end

  def test_david
    # skip
    assert_equal [:radishes, :violets, :clover, :radishes], garden.david
  end

  def test_eve
    # skip
    assert_equal [:clover, :grass, :radishes, :grass], garden.eve
  end

  def test_fred
    # skip
    assert_equal [:grass, :clover, :violets, :clover], garden.fred
  end

  def test_ginny
    # skip
    assert_equal [:clover, :grass, :grass, :clover], garden.ginny
  end

  def test_harriet
    # skip
    assert_equal [:violets, :radishes, :radishes, :violets], garden.harriet
  end

  def test_ileana
    # skip
    assert_equal [:grass, :clover, :violets, :clover], garden.ileana
  end

  def test_joseph
    # skip
    assert_equal [:violets, :clover, :violets, :grass], garden.joseph
  end

  def test_kincaid
    # skip
    assert_equal [:grass, :clover, :clover, :grass], garden.kincaid
  end

  def test_larry
    # skip
    assert_equal [:grass, :violets, :clover, :violets], garden.larry
  end
end

class DisorderedTest < Minitest::Test
  def setup
    # skip
    diagram = "VCRRGVRG\nRVGCCGCV"
    students = %w(Samantha Patricia Xander Roger)
    @garden = Garden.new(diagram, students)
  end

  attr_reader :garden

  def test_patricia
    # skip
    assert_equal [:violets, :clover, :radishes, :violets], garden.patricia
  end

  def test_roger
    # skip
    assert_equal [:radishes, :radishes, :grass, :clover], garden.roger
  end

  def test_samantha
    # skip
    assert_equal [:grass, :violets, :clover, :grass], garden.samantha
  end

  def test_xander
    # skip
    assert_equal [:radishes, :grass, :clover, :violets], garden.xander
  end
end

class TwoGardensDifferentStudents < Minitest::Test
  def diagram
    "VCRRGVRG\nRVGCCGCV"
  end

  def garden_1
    @garden_1 ||= Garden.new(diagram, %w(Alice Bob Charlie Dan))
  end

  def garden_2
    @garden_2 ||= Garden.new(diagram, %w(Bob Charlie Dan Erin))
  end

  def test_bob_and_charlie_per_garden
    # skip
    assert_equal [:radishes, :radishes, :grass, :clover], garden_1.bob
    assert_equal [:violets, :clover, :radishes, :violets], garden_2.bob
    assert_equal [:grass, :violets, :clover, :grass], garden_1.charlie
    assert_equal [:radishes, :radishes, :grass, :clover], garden_2.charlie
  end
end
