MINUTES_PER_HOUR = 60
HOURS_PER_DAY = 24 # could be 12 for a 12-hour clock

class Clock
  def self.at(hour, min=0)
    self.new(hour, min)
  end

  def initialize(hour, min)
    @hour = hour
    @min = min
  end

  def to_s
    format("%02d:%02d", @hour, @min)
  end

  def +(offset)
    adjust!(offset)
  end

  def -(offset)
    adjust!(-offset)
  end

  def ==(other)
    to_s == other.to_s
  end

# adjust!
# =======
# inputs:
# - int (offset in minutes)
# outputs:
# - clock obj
# reqs:
# - adjust the clock by the input number of minutes
# - rtn the revised clock obj
# rules:
# - roll minutes if >= 60 or < 0
# - roll hours if >= 24 or < 0
# - offset may be +ve or -ve
# struct:
# - numeric
# algo:
# - convert the current time (@hours, @mins) to minutes and add the offset
# - divide the minutes by the number of mins in a day, and take the remainder
#   as the new number of minutes
# - divide the number of minutes by the number of mins in an hour, and take
#   the quotient as the new clock @hour, and the remainder as the new clock
#   @min
# - rtn the revised clock obj

  private
  def adjust!(offset)
    minutes = @hour * MINUTES_PER_HOUR + @min + offset
    minutes %= (HOURS_PER_DAY * MINUTES_PER_HOUR)
    @hour, @min = minutes.divmod(MINUTES_PER_HOUR)
    self
  end
end


require 'minitest/autorun'
# require_relative 'clock'

class ClockTest < Minitest::Test
  def test_on_the_hour
    # skip
    assert_equal '08:00', Clock.at(8).to_s
    assert_equal '09:00', Clock.at(9).to_s
  end

  def test_past_the_hour
    # skip
    assert_equal '11:09', Clock.at(11, 9).to_s
  end

  def test_add_a_few_minutes
    # skip
    clock = Clock.at(10) + 3
    assert_equal '10:03', clock.to_s
  end

  def test_add_over_an_hour
    # skip
    clock = Clock.at(10) + 61
    assert_equal '11:01', clock.to_s
  end

  def test_wrap_around_at_midnight
    # skip
    clock = Clock.at(23, 30) + 60
    assert_equal '00:30', clock.to_s
  end

  def test_subtract_minutes
    # skip
    clock = Clock.at(10) - 90
    assert_equal '08:30', clock.to_s
  end

  def test_equivalent_clocks
    # skip
    clock1 = Clock.at(15, 37)
    clock2 = Clock.at(15, 37)
    assert_equal clock1, clock2
  end

  def test_inequivalent_clocks
    # skip
    clock1 = Clock.at(15, 37)
    clock2 = Clock.at(15, 36)
    clock3 = Clock.at(14, 37)
    refute_equal clock1, clock2
    refute_equal clock1, clock3
  end

  def test_wrap_around_backwards
    # skip
    clock = Clock.at(0, 30) - 60
    assert_equal '23:30', clock.to_s
  end
end
