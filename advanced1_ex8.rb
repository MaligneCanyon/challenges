class Game
  def initialize
    @frames = []
    @first_ball_score = nil
  end

# roll
# ====
# inputs:
# - int (num of pins knocked down)
# outputs:
# - arr (w/ 2-elem subarrs of chars indicating roll result)
# reqs:
# - add a 1 or 2-elem subarr to the @frames arr
# - the subarr will contain
#   - 'X' for a strike (1 subelem only), or
#   - '/' for a spare (in the 2nd subelem position), or
#   - numeric chars representing the num of pins knocked down
# rules:
# - none
# struct:
# - arr
# algo:
# - if it's the 2nd roll of the frame
#   - if it's a spare
#     - add a [@frame.first, '/'] subarr to @frames
#   - else
#     - add a [@frame.first, pins] subarr to @frames
#   - reset @frame to []
# - else (it's the 1st roll of the frame)
#   - if pins == 10
#     - add a ['X'] subarr to @frames
#   - else if there are already 10 frames and the last roll was a spare
#     - add a [pins] subarr to @frames
#   - else
#     - set @first_ball_score to pins

  def roll(pins)
    raise RuntimeError, 'Should not be able to roll after game is over' if game_over?
    raise RuntimeError, 'Pins must have a value from 0 to 10' unless (0..10).include?(pins)

    if @first_ball_score # this is last ball of frame
      if pins + @first_ball_score == 10 # a spare
        @frames << [@first_ball_score, '/']
      else
        raise RuntimeError, 'Pin count exceeds pins on the lane' if @first_ball_score + pins > 10
        @frames << [@first_ball_score, pins]
      end
      @first_ball_score = nil
    else
      if pins == 10 # a strike
        @frames << ['X']
      elsif @frames.size == 10 && @frames.last.last == '/'
        @frames << [pins]
      else
        @first_ball_score = pins
      end
    end
    # p @first_ball_score
    # p @frames
  end

# score
# =====
# inputs:
# - arr (nested, with alphanumeric elems and subelems)
# outputs:
# - int
# reqs:
# - sum the num of pins knocked down in the @frames arr
# rules:
# - if an elem is an 'X'
#   - add 10 + the value of the next two elems
# - if an elem is a '/'
#   - add 10 - the value of the previous elem + the value of the next elem
# - if either of the next two elems is 'X' or '/'
#   - add 10 for the value of that next elem
# struct:
# - arr
# algo:
# - calc the base_num of rolls (excluding frame10 bonus rolls)
#   - @frames[0..9].flatten.size
# - flatten @frames to a new_arr
# - map each elem of the new_arr
#   - if the ndx of the elem is < base_num
#     - if the elem is 'X' or '/'
#       - calc the bonus from subsequent rolls
#         - bonus = 0
#         - add the bonus from the 1st subsequent roll
#           - if the 1st subsequent elem is (another) 'X'
#             - bonus += 10
#           - else
#             - bonus += the 1st subsequent elem value
#         - if the elem is 'X'
#           - add the bonus from the 2nd subsequent roll
#             - if the 2nd subsequent elem is (another) 'X'
#               - bonus += 10
#             - elsif the 2nd subsequent elem is a '/'
#               - bonus += (10 - the 1st subsequent elem value)
#             - else
#               - bonus += the 2nd subsequent elem value
#       - use 10 + bonus
#     - else
#       - use the elem value
#   - else
#     - use nil
# - sum the values from the new_arr for the base_num rolls
#   (do not count the frame10 bonus rolls twice)
# - rtn the sum

  def score
    # puts
    # p @frames

    raise RuntimeError, 'Score cannot be taken until the end of the game' unless game_over?

    base_rolls = @frames[0..9].flatten.size
    arr = @frames.flatten
    # p arr
    arr.map!.with_index do |elem, ndx|
      if ndx < base_rolls
        # p "elem == #{elem}"

        # should split the bonus calc off into a separate method
        # calc the bonus for the 1st subsequent roll
        bonus = arr[ndx + 1] == 'X' ? 10 : arr[ndx + 1] if elem == 'X' || elem == '/'
        if elem == 'X'
          # add the bonus for the 2nd subsequent roll
          bonus += if arr[ndx + 2] == 'X'
            10
          elsif arr[ndx + 2] == '/'
            10 - arr[ndx + 1]
          else
            arr[ndx + 2]
          end

          # p "bonus == #{bonus}"
          10 + bonus
        elsif elem == '/'
          # p "bonus == #{bonus}"
          (10 - arr[ndx - 1]) + bonus
        else
          elem
        end
      end
    end
    # p arr
    # p arr[0...base_rolls]
    arr[0...base_rolls].sum
  end

# game_over?
# ==========
# rules:
# - the game is over if there are
#   - 10 frames and the 10th frame (ndx == 9) does not include an 'X' or '/'
#   - 11 frames and the 10th frame (ndx == 9) has a '/'
#   - 11 frames and the 10th frame (ndx == 9) has an 'X' and the 11th frame
#     (ndx == 10) does not have an 'X'
#   - 12 frames and the 10th frame (ndx == 9) has an 'X' and the 11th frame
#     (ndx == 10) has an 'X'
# - graphically,
#     9   10  11  frame_ndx
#     n,n
#     n,/ *
#     X   ^X
#     X   X   *
#   where
#   - 'n' is an int 0..9
#   - * is anything

  def game_over?
    # puts
    # p @frames.size
    # p @frames[9].last if @frames.size >= 10
    # p @frames[10].last if @frames.size >= 11
    # game_over =
    @frames.size == 10 && !(@frames[9].last =~ /[X\/]/) ||
    @frames.size == 11 && (@frames[9].last == '/' ||
      (@frames[9].last == 'X' && @frames[10].last != 'X')) ||
    @frames.size == 12 && @frames[9].last == 'X' && @frames[10].last == 'X'
    # p " game_over: #{game_over}"
    # game_over
  end
end


require 'minitest/autorun'
# require_relative 'bowling'

class GameTest < Minitest::Test
  def setup
    @game = Game.new
  end

  def test_should_be_able_to_score_open_frame
    # skip
    @game.roll(3)
    @game.roll(4)
    roll_n_times(18, 0)
    assert_equal 7, @game.score
  end

  def test_should_be_able_to_score_multiple_frames
    # skip
    [3, 4, 2, 3, 5, 2].each do |pins|
      @game.roll pins
    end
    roll_n_times(14, 0)
    assert_equal 19, @game.score
  end

  def test_should_score_a_game_with_all_gutterballs
    # skip
    roll_n_times(20, 0)
    assert_equal 0, @game.score
  end

  def test_should_score_a_game_with_all_single_pin_rolls
    # skip
    roll_n_times(20, 1)
    assert_equal 20, @game.score
  end

  def test_should_allow_game_with_all_open_frames
    # skip
    roll_n_times(10, [3, 6])
    assert_equal 90, @game.score
  end

  def test_should_correctly_score_a_strike_that_is_not_on_the_last_frame
    # skip
    @game.roll(10)
    @game.roll(5)
    @game.roll(3)
    roll_n_times(16, 0)

    assert_equal 26, @game.score
  end

  def test_should_score_a_spare_that_is_not_on_the_last_frame
    # skip
    @game.roll(5)
    @game.roll(5)
    @game.roll(3)
    @game.roll(4)
    roll_n_times(16, 0)

    assert_equal 20, @game.score
  end

  def test_should_score_multiple_strikes_in_a_row
    # skip
    @game.roll(10)
    @game.roll(10)
    @game.roll(10)
    @game.roll(5)
    @game.roll(3)
    roll_n_times(12, 0)

    assert_equal 81, @game.score
  end

  def test_should_score_multiple_spares_in_a_row
    # skip
    @game.roll(5)
    @game.roll(5)
    @game.roll(3)
    @game.roll(7)
    @game.roll(4)
    @game.roll(1)
    roll_n_times(14, 0)

    assert_equal 32, @game.score
  end

  def test_should_allow_fill_balls_when_the_final_frame_is_strike
    # skip
    roll_n_times(18, 0)
    @game.roll(10)
    @game.roll(7)
    @game.roll(1)

    assert_equal 18, @game.score
  end

  def test_should_allow_fill_ball_in_last_frame_if_spare
    # skip
    roll_n_times(18, 0)
    @game.roll(9)
    @game.roll(1)
    @game.roll(7)

    assert_equal 17, @game.score
  end

  def test_should_allow_fill_balls_to_be_strike
    # skip
    roll_n_times(18, 0)
    @game.roll(10)
    @game.roll(10)
    @game.roll(10)

    assert_equal 30, @game.score
  end

  def test_should_score_a_perfect_game
    # skip
    roll_n_times(12, 10)
    assert_equal 300, @game.score
  end

  def test_should_not_allow_rolls_with_negative_pins
    # skip
    assert_raises(
      RuntimeError,
      'Pins must have a value from 0 to 10') do
        @game.roll(-1)
      end
  end

  def test_should_not_allow_rolls_better_than_strike
    # skip
    assert_raises(
      RuntimeError,
      'Pins must have a value from 0 to 10') do
        @game.roll(11)
      end
  end

  def test_should_not_allow_two_normal_rolls_better_than_strike
    # skip
    assert_raises RuntimeError, 'Pin count exceeds pins on the lane' do
      @game.roll(5)
      @game.roll(6)
    end
  end

  def test_should_not_allow_two_normal_rolls_better_than_strike_in_last_frame
    # skip
    roll_n_times(18, 0)
    assert_raises RuntimeError, 'Pin count exceeds pins on the lane' do
      @game.roll(10)
      @game.roll(5)
      @game.roll(6)
    end
  end

  def test_should_not_allow_to_take_score_at_the_beginning
    # skip
    assert_raises(
      RuntimeError,
      'Score cannot be taken until the end of the game',
    ) do
      @game.score
    end
  end

  def test_should_not_allow_to_take_score_before_game_has_ended
    # skip
    roll_n_times(19, 5)
    assert_raises(
      RuntimeError,
      'Score cannot be taken until the end of the game') do
        @game.score
      end
  end

  def test_should_not_allow_rolls_after_the_tenth_frame
    # skip
    roll_n_times(20, 0)
    assert_raises(
      RuntimeError,
      'Should not be able to roll after game is over',
    ) do
      @game.roll(0)
    end
  end

  def test_should_not_calculate_score_before_fill_balls_have_been_played
    # skip
    roll_n_times(10, 10)

    assert_raises RuntimeError, 'Game is not yet over, cannot score!' do
      @game.score
    end
  end

  # calls #roll the spec'd num of times
  # if pins is an Array, calls #roll for each elem of pins
  def roll_n_times(rolls, pins)
    rolls.times do
      Array(pins).each { |value| @game.roll(value) }
    end
  end
  private :roll_n_times
end
