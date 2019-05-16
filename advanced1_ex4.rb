class Robot
  BEARINGS = [:north, :east, :south, :west].freeze

  attr_accessor :bearing, :coordinates

  def initialize
    @bearing = nil
    @coordinates = [nil, nil]
  end

  def orient(dir)
    raise ArgumentError unless BEARINGS.include?(dir)
    self.bearing = dir
  end

# turn_right
# ==========
# note: the terms "bearing" and "dir" are synonomous
# algo:
# - get the ndx of the initial bearing from the BEARINGS arr
# - incr the ndx
#   - roll the ndx if it is at the end of the BEARINGS arr
# - set the new bearing to the BEARINGS elem at the new ndx

  def turn_right
    # p "old bearing == #{bearing}"
    # ndx = BEARINGS.index(bearing)
    # p "old ndx == #{ndx}"
    # ndx = (ndx + 1) % 4
    # p "new ndx == #{ndx}"
    # new_bearing = BEARINGS[ndx]
    # p "new bearing == #{new_bearing}"
    # self.bearing = new_bearing
    self.bearing = BEARINGS[(BEARINGS.index(bearing) + 1) % 4]
  end

  def turn_left
    self.bearing = BEARINGS[(BEARINGS.index(bearing) - 1) % 4]
  end

# at
# ==
# algo:
# - set the x-coord to the first arg
# - set the y-coord to the last arg

  def at(x, y)
    self.coordinates = [x, y]
  end

# advance
# =======
# algo:
# - if the robot is facing north
#   - incr the y-coord
# - if the robot is facing east
#   - incr the x-coord
# - if the robot is facing south
#   - decr the y-coord
# - if the robot is facing west
#   - decr the x-coord

  def advance
    case bearing
    when :north
      coordinates[1] += 1
    when :east
      coordinates[0] += 1
    when :south
      coordinates[1] -= 1
    when :west
      coordinates[0] -= 1
    end
  end
end

# robot = Robot.new
# robot.orient(:north)
# robot.turn_right


class Simulator
  COMMANDS = { turn_right: 'R', turn_left: 'L', advance: 'A' }.freeze

# instructions
# ============
# algo:
# - split the cmd str into an arr of chars
# - map each char in the arr to a sym using the COMMANDS hsh
#   - arr[char] = COMMANDS.invert[char]
# - rtn the arr of syms

  def instructions(cmds)
    cmds.chars.map { |char| COMMANDS.invert[char] }
  end

# place
# =====
# algo:
# - set the x and y coords of the Robot instance
# - set the bearing of the Robot instance

  def place(rbot, x: nil, y: nil, direction: nil)
    rbot.at(x, y)
    rbot.orient(direction)
  end

# evaluate
# ========
# note: evaluate doesn't actually "evaluate" anything; it just forwards the
# list of cmds passed to it (sends them to a Robot instance)
# algo:
# - for each cmd in the arr of cmds
#   - call the method spec'd by the the cmd
#     - send the cmd to the Robot instance

  def evaluate(rbot, cmds)
    # instructions(cmds).each do |cmd|
    #   p cmd
    #   rbot.send(cmd)
    # end
    instructions(cmds).each { |cmd| rbot.send(cmd) }
  end
end


require 'minitest/autorun'
# require_relative 'robot_simulator'

class RobotTurningTest < Minitest::Test
  attr_reader :robot

  def setup
    @robot = Robot.new
  end

  def test_robot_bearing
    # skip
    [:east, :west, :north, :south].each do |direction|
      robot.orient(direction)
      assert_equal direction, robot.bearing
    end
  end

  def test_invalid_robot_bearing
    # skip
    assert_raises ArgumentError do
      robot.orient(:crood)
    end
  end

  def test_turn_right_from_north
    # skip
    robot.orient(:north)
    robot.turn_right
    assert_equal :east, robot.bearing
  end

  def test_turn_right_from_east
    # skip
    robot.orient(:east)
    robot.turn_right
    assert_equal :south, robot.bearing
  end

  def test_turn_right_from_south
    # skip
    robot.orient(:south)
    robot.turn_right
    assert_equal :west, robot.bearing
  end

  def test_turn_right_from_west
    # skip
    robot.orient(:west)
    robot.turn_right
    assert_equal :north, robot.bearing
  end

  def test_turn_left_from_north
    # skip
    robot.orient(:north)
    robot.turn_left
    assert_equal :west, robot.bearing
  end

  def test_turn_left_from_east
    # skip
    robot.orient(:east)
    robot.turn_left
    assert_equal :north, robot.bearing
  end

  def test_turn_left_from_south
    # skip
    robot.orient(:south)
    robot.turn_left
    assert_equal :east, robot.bearing
  end

  def test_turn_left_from_west
    # skip
    robot.orient(:west)
    robot.turn_left
    assert_equal :south, robot.bearing
  end

  def test_robot_coordinates
    # skip
    robot.at(3, 0)
    assert_equal [3, 0], robot.coordinates
  end

  def test_other_robot_coordinates
    # skip
    robot.at(-2, 5)
    assert_equal [-2, 5], robot.coordinates
  end

  def test_advance_when_facing_north
    # skip
    robot.at(0, 0)
    robot.orient(:north)
    robot.advance
    assert_equal [0, 1], robot.coordinates
  end

  def test_advance_when_facing_east
    # skip
    robot.at(0, 0)
    robot.orient(:east)
    robot.advance
    assert_equal [1, 0], robot.coordinates
  end

  def test_advance_when_facing_south
    # skip
    robot.at(0, 0)
    robot.orient(:south)
    robot.advance
    assert_equal [0, -1], robot.coordinates
  end

  def test_advance_when_facing_west
    # skip
    robot.at(0, 0)
    robot.orient(:west)
    robot.advance
    assert_equal [-1, 0], robot.coordinates
  end
end

class RobotSimulatorTest < Minitest::Test
  def simulator
    @simulator ||= Simulator.new
  end

  def test_instructions_for_turning_left
    # skip
    assert_equal [:turn_left], simulator.instructions('L')
  end

  def test_instructions_for_turning_right
    # skip
    assert_equal [:turn_right], simulator.instructions('R')
  end

  def test_instructions_for_advancing
    # skip
    assert_equal [:advance], simulator.instructions('A')
  end

  def test_series_of_instructions
    # skip
    commands = [:turn_right, :advance, :advance, :turn_left]
    assert_equal commands, simulator.instructions('RAAL')
  end

  def test_instruct_robot
    # skip
    robot = Robot.new
    simulator.place(robot, x: -2, y: 1, direction: :east)
    simulator.evaluate(robot, 'RLAALAL')
    assert_equal [0, 2], robot.coordinates
    assert_equal :west, robot.bearing
  end

  def test_instruct_many_robots # rubocop:disable Metrics/MethodLength
    # skip
    robot1 = Robot.new
    robot2 = Robot.new
    robot3 = Robot.new
    simulator.place(robot1, x: 0, y: 0, direction: :north)
    simulator.place(robot2, x: 2, y: -7, direction: :east)
    simulator.place(robot3, x: 8, y: 4, direction: :south)
    simulator.evaluate(robot1, 'LAAARALA')
    simulator.evaluate(robot2, 'RRAAAAALA')
    simulator.evaluate(robot3, 'LAAARRRALLLL')

    assert_equal [-4, 1], robot1.coordinates
    assert_equal :west, robot1.bearing

    assert_equal [-3, -8], robot2.coordinates
    assert_equal :south, robot2.bearing

    assert_equal [11, 5], robot3.coordinates
    assert_equal :north, robot3.bearing
  end
end
