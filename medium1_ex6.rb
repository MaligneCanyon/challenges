class School
  def initialize
    @hsh = Hash.new([]) # default value is an empty arr
  end

# to_h
# ====
# inputs:
# - hsh (unsorted)
# outputs:
# - hsh (sorted)
# reqs:
# - sort the input hsh as per the rules and rtn the result
# rules:
# - grades should sort as 1, 2, 3, etc.
# - students within a grade should be sorted alphabetically by name
# - ex. {1=>["Anna", "Barb", "Charlie"], 2=>["Alex", "Peter"], ...}
# struct:
# - hsh
# algo:
# - sort the hsh by keys
# - xform the hsh values (by sorting them alphabetically)
# - rtn the sorted hsh

  def to_h
    # Hash#sort_by rtns an arr; call Array#to_h to convert back to a hsh
    hsh = @hsh.sort_by { |k, _| k }.to_h
    hsh.transform_values { |value| value.sort }
  end

# add
# ===
# inputs:
# - name
# - level
# outputs:
# - hsh (mutated instance var)
# reqs:
# - add a name and level to the hsh for each student
# rules:
# - keys are the level
# - values are a list of student names in that level
# struct:
# - hsh
# algo:
# - if the level exists
#   - unless the list already contains the name
#     - add the name to the list
# - else
#   - create a k,v pair w/ the level as the key and the name as member of the
#     list of students

  def add(name, level)
    if @hsh.has_key?(level)
      @hsh[level] << name unless @hsh[level].include?(name)
    else
      @hsh[level] = [name]
    end
  end

  def grade(level)
    @hsh[level]
  end
end


require 'minitest/autorun'
# require_relative 'grade_school'

class SchoolTest < Minitest::Test
  attr_reader :school

  def setup
    @school = School.new
  end

  def test_an_empty_school
    # skip
    assert_equal({}, school.to_h)
  end

  def test_add_student
    # skip
    school.add('Aimee', 2)
    assert_equal({ 2 => ['Aimee'] }, school.to_h)
  end

  def test_add_more_students_in_same_class
    # skip
    school.add('Blair', 2)
    school.add('James', 2)
    school.add('Paul', 2)
    assert_equal({ 2 => %w(Blair James Paul) }, school.to_h)
  end

  def test_add_students_to_different_grades
    # skip
    school.add('Chelsea', 3)
    school.add('Logan', 7)
    assert_equal({ 3 => ['Chelsea'], 7 => ['Logan'] }, school.to_h)
  end

  def test_get_students_in_a_grade
    # skip
    school.add('Bradley', 5)
    school.add('Franklin', 5)
    school.add('Jeff', 1)
    assert_equal %w(Bradley Franklin), school.grade(5)
  end

  def test_get_students_in_a_non_existant_grade
    # skip
    assert_equal [], school.grade(1)
  end

  def test_sort_school # rubocop:disable Metrics/MethodLength
    # skip
    [
      ['Jennifer', 4], ['Kareem', 6],
      ['Christopher', 4], ['Kyle', 3]
    ].each do |name, grade|
      school.add(name, grade)
    end
    sorted = {
      3 => ['Kyle'],
      4 => %w(Christopher Jennifer),
      6 => ['Kareem']
    }
    assert_equal sorted, school.to_h
    assert_equal [3, 4, 6], school.to_h.keys
  end
end
