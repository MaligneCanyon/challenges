# day
# ===
# inputs:
# - sym (weekday)
# - sym (schedule)
# - @year
# - @month
# outputs:
# - Date obj
# reqs:
# - calc a Date obj from the inputs
# rules:
# - if schedule is
#   - :first  then (1..7).include?(day)
#   - :second then (8..14).include?(day)
#   - :third  then (15..21).include?(day)
#   - :fourth then (22..28).include?(day)
#   - :last   then ((last_day - 6)..last_day).include?(day)
#   - :teenth then (13..19).include?(day)
# struct:
# -
# algo:
# - if the schedule is :last
#   - determine the day range for the last week of the month
#     - create a Date obj using @year, @month, -1
#     - calc the last day of the month from the Date obj
#     - calc the min and max day in the schedule
# - for the min to max day in the schedule
#   - create a Date obj
#   - convert the weekday to a str
#   - append a '?' to the str and convert it back to a sym
#   - call the send method on the Date obj, passing it the revised weekday sym
#   - rtn the Date obj is a infact the specified weekday

require 'date'
class Meetup
  SCHEDULE = {
    :first  => (1..7).to_a.freeze,
    :second => (8..14).to_a.freeze,
    :third  => (15..21).to_a.freeze,
    :fourth => (22..28).to_a.freeze,
    # :last   => (29..31).to_a.freeze, # not necessarily
    :teenth => (13..19).to_a.freeze
  }

  def initialize(month, year)
    @month = month
    @year = year
  end

  def day(weekday, schedule)
    if schedule == :last
      last_day = Date.new(@year, @month, -1).day
      min, max = last_day - 6, last_day
    else
      min, max = SCHEDULE[schedule].first, SCHEDULE[schedule].last
    end
    (min..max).each do |day|
      # p "#{@year}, #{@month}, #{day}"
      date = Date.new(@year, @month, day)
      symbol = (weekday.to_s + '?').to_sym
      return date if date.send(symbol)
    end
    # raise StandardError, 'date not found'
  end
end
p Meetup.new(5, 2013).day(:monday, :teenth)
p Meetup.new(4, 2019).day(:monday, :teenth)

require 'minitest/autorun'
require 'date'
# require_relative 'meetup'


# rubocop:disable Style/AlignParameters
class MeetupTest < Minitest::Test
  def test_monteenth_of_may_2013
    # skip
    assert_equal Date.new(2013, 5, 13),
      Meetup.new(5, 2013).day(:monday, :teenth)
  end

  def test_monteenth_of_august_2013
    # skip
    assert_equal Date.new(2013, 8, 19),
      Meetup.new(8, 2013).day(:monday, :teenth)
  end

  def test_monteenth_of_september_2013
    # skip
    assert_equal Date.new(2013, 9, 16),
      Meetup.new(9, 2013).day(:monday, :teenth)
  end

  def test_tuesteenth_of_march_2013
    # skip
    assert_equal Date.new(2013, 3, 19),
      Meetup.new(3, 2013).day(:tuesday, :teenth)
  end

  def test_tuesteenth_of_april_2013
    # skip
    assert_equal Date.new(2013, 4, 16),
      Meetup.new(4, 2013).day(:tuesday, :teenth)
  end

  def test_tuesteenth_of_august_2013
    # skip
    assert_equal Date.new(2013, 8, 13),
      Meetup.new(8, 2013).day(:tuesday, :teenth)
  end

  def test_wednesteenth_of_january_2013
    # skip
    assert_equal Date.new(2013, 1, 16),
      Meetup.new(1, 2013).day(:wednesday, :teenth)
  end

  def test_wednesteenth_of_february_2013
    # skip
    assert_equal Date.new(2013, 2, 13),
      Meetup.new(2, 2013).day(:wednesday, :teenth)
  end

  def test_wednesteenth_of_june_2013
    # skip
    assert_equal Date.new(2013, 6, 19),
      Meetup.new(6, 2013).day(:wednesday, :teenth)
  end

  def test_thursteenth_of_may_2013
    # skip
    assert_equal Date.new(2013, 5, 16),
      Meetup.new(5, 2013).day(:thursday, :teenth)
  end

  def test_thursteenth_of_june_2013
    # skip
    assert_equal Date.new(2013, 6, 13),
      Meetup.new(6, 2013).day(:thursday, :teenth)
  end

  def test_thursteenth_of_september_2013
    # skip
    assert_equal Date.new(2013, 9, 19),
      Meetup.new(9, 2013).day(:thursday, :teenth)
  end

  def test_friteenth_of_april_2013
    # skip
    assert_equal Date.new(2013, 4, 19),
      Meetup.new(4, 2013).day(:friday, :teenth)
  end

  def test_friteenth_of_august_2013
    # skip
    assert_equal Date.new(2013, 8, 16),
      Meetup.new(8, 2013).day(:friday, :teenth)
  end

  def test_friteenth_of_september_2013
    # skip
    assert_equal Date.new(2013, 9, 13),
      Meetup.new(9, 2013).day(:friday, :teenth)
  end

  def test_saturteenth_of_february_2013
    # skip
    assert_equal Date.new(2013, 2, 16),
      Meetup.new(2, 2013).day(:saturday, :teenth)
  end

  def test_saturteenth_of_april_2013
    # skip
    assert_equal Date.new(2013, 4, 13),
      Meetup.new(4, 2013).day(:saturday, :teenth)
  end

  def test_saturteenth_of_october_2013
    # skip
    assert_equal Date.new(2013, 10, 19),
      Meetup.new(10, 2013).day(:saturday, :teenth)
  end

  def test_sunteenth_of_map_2013
    # skip
    assert_equal Date.new(2013, 5, 19),
      Meetup.new(5, 2013).day(:sunday, :teenth)
  end

  def test_sunteenth_of_june_2013
    # skip
    assert_equal Date.new(2013, 6, 16),
      Meetup.new(6, 2013).day(:sunday, :teenth)
  end

  def test_sunteenth_of_october_2013
    # skip
    assert_equal Date.new(2013, 10, 13),
      Meetup.new(10, 2013).day(:sunday, :teenth)
  end

  def test_first_monday_of_march_2013
    # skip
    assert_equal Date.new(2013, 3, 4),
      Meetup.new(3, 2013).day(:monday, :first)
  end

  def test_first_monday_of_april_2013
    # skip
    assert_equal Date.new(2013, 4, 1),
      Meetup.new(4, 2013).day(:monday, :first)
  end

  def test_first_tuesday_of_may_2013
    # skip
    assert_equal Date.new(2013, 5, 7),
      Meetup.new(5, 2013).day(:tuesday, :first)
  end

  def test_first_tuesday_of_june_2013
    # skip
    assert_equal Date.new(2013, 6, 4),
      Meetup.new(6, 2013).day(:tuesday, :first)
  end

  def test_first_wednesday_of_july_2013
    # skip
    assert_equal Date.new(2013, 7, 3),
      Meetup.new(7, 2013).day(:wednesday, :first)
  end

  def test_first_wednesday_of_august_2013
    # skip
    assert_equal Date.new(2013, 8, 7),
      Meetup.new(8, 2013).day(:wednesday, :first)
  end

  def test_first_thursday_of_september_2013
    # skip
    assert_equal Date.new(2013, 9, 5),
      Meetup.new(9, 2013).day(:thursday, :first)
  end

  def test_first_thursday_of_october_2013
    # skip
    assert_equal Date.new(2013, 10, 3),
      Meetup.new(10, 2013).day(:thursday, :first)
  end

  def test_first_friday_of_november_2013
    # skip
    assert_equal Date.new(2013, 11, 1),
      Meetup.new(11, 2013).day(:friday, :first)
  end

  def test_first_friday_of_december_2013
    # skip
    assert_equal Date.new(2013, 12, 6),
      Meetup.new(12, 2013).day(:friday, :first)
  end

  def test_first_saturday_of_january_2013
    # skip
    assert_equal Date.new(2013, 1, 5),
      Meetup.new(1, 2013).day(:saturday, :first)
  end

  def test_first_saturday_of_february_2013
    # skip
    assert_equal Date.new(2013, 2, 2),
      Meetup.new(2, 2013).day(:saturday, :first)
  end

  def test_first_sunday_of_march_2013
    # skip
    assert_equal Date.new(2013, 3, 3),
      Meetup.new(3, 2013).day(:sunday, :first)
  end

  def test_first_sunday_of_april_2013
    # skip
    assert_equal Date.new(2013, 4, 7),
      Meetup.new(4, 2013).day(:sunday, :first)
  end

  def test_second_monday_of_march_2013
    # skip
    assert_equal Date.new(2013, 3, 11),
      Meetup.new(3, 2013).day(:monday, :second)
  end

  def test_second_monday_of_april_2013
    # skip
    assert_equal Date.new(2013, 4, 8),
      Meetup.new(4, 2013).day(:monday, :second)
  end

  def test_second_tuesday_of_may_2013
    # skip
    assert_equal Date.new(2013, 5, 14),
      Meetup.new(5, 2013).day(:tuesday, :second)
  end

  def test_second_tuesday_of_june_2013
    # skip
    assert_equal Date.new(2013, 6, 11),
      Meetup.new(6, 2013).day(:tuesday, :second)
  end

  def test_second_wednesday_of_july_2013
    # skip
    assert_equal Date.new(2013, 7, 10),
      Meetup.new(7, 2013).day(:wednesday, :second)
  end

  def test_second_wednesday_of_august_2013
    # skip
    assert_equal Date.new(2013, 8, 14),
      Meetup.new(8, 2013).day(:wednesday, :second)
  end

  def test_second_thursday_of_september_2013
    # skip
    assert_equal Date.new(2013, 9, 12),
      Meetup.new(9, 2013).day(:thursday, :second)
  end

  def test_second_thursday_of_october_2013
    # skip
    assert_equal Date.new(2013, 10, 10),
      Meetup.new(10, 2013).day(:thursday, :second)
  end

  def test_second_friday_of_november_2013
    # skip
    assert_equal Date.new(2013, 11, 8),
      Meetup.new(11, 2013).day(:friday, :second)
  end

  def test_second_friday_of_december_2013
    # skip
    assert_equal Date.new(2013, 12, 13),
      Meetup.new(12, 2013).day(:friday, :second)
  end

  def test_second_saturday_of_january_2013
    # skip
    assert_equal Date.new(2013, 1, 12),
      Meetup.new(1, 2013).day(:saturday, :second)
  end

  def test_second_saturday_of_february_2013
    # skip
    assert_equal Date.new(2013, 2, 9),
      Meetup.new(2, 2013).day(:saturday, :second)
  end

  def test_second_sunday_of_march_2013
    # skip
    assert_equal Date.new(2013, 3, 10),
      Meetup.new(3, 2013).day(:sunday, :second)
  end

  def test_second_sunday_of_april_2013
    # skip
    assert_equal Date.new(2013, 4, 14),
      Meetup.new(4, 2013).day(:sunday, :second)
  end

  def test_third_monday_of_march_2013
    # skip
    assert_equal Date.new(2013, 3, 18),
      Meetup.new(3, 2013).day(:monday, :third)
  end

  def test_third_monday_of_april_2013
    # skip
    assert_equal Date.new(2013, 4, 15),
      Meetup.new(4, 2013).day(:monday, :third)
  end

  def test_third_tuesday_of_may_2013
    # skip
    assert_equal Date.new(2013, 5, 21),
      Meetup.new(5, 2013).day(:tuesday, :third)
  end

  def test_third_tuesday_of_june_2013
    # skip
    assert_equal Date.new(2013, 6, 18),
      Meetup.new(6, 2013).day(:tuesday, :third)
  end

  def test_third_wednesday_of_july_2013
    # skip
    assert_equal Date.new(2013, 7, 17),
      Meetup.new(7, 2013).day(:wednesday, :third)
  end

  def test_third_wednesday_of_august_2013
    # skip
    assert_equal Date.new(2013, 8, 21),
      Meetup.new(8, 2013).day(:wednesday, :third)
  end

  def test_third_thursday_of_september_2013
    # skip
    assert_equal Date.new(2013, 9, 19),
      Meetup.new(9, 2013).day(:thursday, :third)
  end

  def test_third_thursday_of_october_2013
    # skip
    assert_equal Date.new(2013, 10, 17),
      Meetup.new(10, 2013).day(:thursday, :third)
  end

  def test_third_friday_of_november_2013
    # skip
    assert_equal Date.new(2013, 11, 15),
      Meetup.new(11, 2013).day(:friday, :third)
  end

  def test_third_friday_of_december_2013
    # skip
    assert_equal Date.new(2013, 12, 20),
      Meetup.new(12, 2013).day(:friday, :third)
  end

  def test_third_saturday_of_january_2013
    # skip
    assert_equal Date.new(2013, 1, 19),
      Meetup.new(1, 2013).day(:saturday, :third)
  end

  def test_third_saturday_of_february_2013
    # skip
    assert_equal Date.new(2013, 2, 16),
      Meetup.new(2, 2013).day(:saturday, :third)
  end

  def test_third_sunday_of_march_2013
    # skip
    assert_equal Date.new(2013, 3, 17),
      Meetup.new(3, 2013).day(:sunday, :third)
  end

  def test_third_sunday_of_april_2013
    # skip
    assert_equal Date.new(2013, 4, 21),
      Meetup.new(4, 2013).day(:sunday, :third)
  end

  def test_fourth_monday_of_march_2013
    # skip
    assert_equal Date.new(2013, 3, 25),
      Meetup.new(3, 2013).day(:monday, :fourth)
  end

  def test_fourth_monday_of_april_2013
    # skip
    assert_equal Date.new(2013, 4, 22),
      Meetup.new(4, 2013).day(:monday, :fourth)
  end

  def test_fourth_tuesday_of_may_2013
    # skip
    assert_equal Date.new(2013, 5, 28),
      Meetup.new(5, 2013).day(:tuesday, :fourth)
  end

  def test_fourth_tuesday_of_june_2013
    # skip
    assert_equal Date.new(2013, 6, 25),
      Meetup.new(6, 2013).day(:tuesday, :fourth)
  end

  def test_fourth_wednesday_of_july_2013
    # skip
    assert_equal Date.new(2013, 7, 24),
      Meetup.new(7, 2013).day(:wednesday, :fourth)
  end

  def test_fourth_wednesday_of_august_2013
    # skip
    assert_equal Date.new(2013, 8, 28),
      Meetup.new(8, 2013).day(:wednesday, :fourth)
  end

  def test_fourth_thursday_of_september_2013
    # skip
    assert_equal Date.new(2013, 9, 26),
      Meetup.new(9, 2013).day(:thursday, :fourth)
  end

  def test_fourth_thursday_of_october_2013
    # skip
    assert_equal Date.new(2013, 10, 24),
      Meetup.new(10, 2013).day(:thursday, :fourth)
  end

  def test_fourth_friday_of_november_2013
    # skip
    assert_equal Date.new(2013, 11, 22),
      Meetup.new(11, 2013).day(:friday, :fourth)
  end

  def test_fourth_friday_of_december_2013
    # skip
    assert_equal Date.new(2013, 12, 27),
      Meetup.new(12, 2013).day(:friday, :fourth)
  end

  def test_fourth_saturday_of_january_2013
    # skip
    assert_equal Date.new(2013, 1, 26),
      Meetup.new(1, 2013).day(:saturday, :fourth)
  end

  def test_fourth_saturday_of_february_2013
    # skip
    assert_equal Date.new(2013, 2, 23),
      Meetup.new(2, 2013).day(:saturday, :fourth)
  end

  def test_fourth_sunday_of_march_2013
    # skip
    assert_equal Date.new(2013, 3, 24),
      Meetup.new(3, 2013).day(:sunday, :fourth)
  end

  def test_fourth_sunday_of_april_2013
    # skip
    assert_equal Date.new(2013, 4, 28),
      Meetup.new(4, 2013).day(:sunday, :fourth)
  end

  def test_last_monday_of_march_2013
    # skip
    assert_equal Date.new(2013, 3, 25),
      Meetup.new(3, 2013).day(:monday, :last)
  end

  def test_last_monday_of_april_2013
    # skip
    assert_equal Date.new(2013, 4, 29),
      Meetup.new(4, 2013).day(:monday, :last)
  end

  def test_last_tuesday_of_may_2013
    # skip
    assert_equal Date.new(2013, 5, 28),
      Meetup.new(5, 2013).day(:tuesday, :last)
  end

  def test_last_tuesday_of_june_2013
    # skip
    assert_equal Date.new(2013, 6, 25),
      Meetup.new(6, 2013).day(:tuesday, :last)
  end

  def test_last_wednesday_of_july_2013
    # skip
    assert_equal Date.new(2013, 7, 31),
      Meetup.new(7, 2013).day(:wednesday, :last)
  end

  def test_last_wednesday_of_august_2013
    # skip
    assert_equal Date.new(2013, 8, 28),
      Meetup.new(8, 2013).day(:wednesday, :last)
  end

  def test_last_thursday_of_september_2013
    # skip
    assert_equal Date.new(2013, 9, 26),
      Meetup.new(9, 2013).day(:thursday, :last)
  end

  def test_last_thursday_of_october_2013
    # skip
    assert_equal Date.new(2013, 10, 31),
      Meetup.new(10, 2013).day(:thursday, :last)
  end

  def test_last_friday_of_november_2013
    # skip
    assert_equal Date.new(2013, 11, 29),
      Meetup.new(11, 2013).day(:friday, :last)
  end

  def test_last_friday_of_december_2013
    # skip
    assert_equal Date.new(2013, 12, 27),
      Meetup.new(12, 2013).day(:friday, :last)
  end

  def test_last_saturday_of_january_2013
    # skip
    assert_equal Date.new(2013, 1, 26),
      Meetup.new(1, 2013).day(:saturday, :last)
  end

  def test_last_saturday_of_february_2013
    # skip
    assert_equal Date.new(2013, 2, 23),
      Meetup.new(2, 2013).day(:saturday, :last)
  end

  def test_last_sunday_of_march_2013
    # skip
    assert_equal Date.new(2013, 3, 31),
      Meetup.new(3, 2013).day(:sunday, :last)
  end

  def test_last_sunday_of_april_2013
    # skip
    assert_equal Date.new(2013, 4, 28),
      Meetup.new(4, 2013).day(:sunday, :last)
  end
end
