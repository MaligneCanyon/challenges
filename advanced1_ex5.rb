class Board

# transform
# =========
# inputs:
# - arr of strs (each representing a row of the board)
# outputs:
# - arr of strs (each representing a row of the board)
# reqs:
# - for any blank (space char) w/i the borders of the board,
#   replace the char w/ a count of the surrounding '*' chars
# rules:
# - ignore border chars (+-|)
# struct:
# - arr
# algo:
# - raise an err if the board is formatted incorrectly
# - split the elems of the input arr into chars and map them to a new_arr
# - for each row of the board
#   - for each col w/i a row
#     - if the char is a ' '
#       - count the surrounding '*' chars
#         - in the row above the current row
#         - in the current row
#         - in the row below the current row
#       - if the count is > 0
#         - convert the count to a char
#         - replace the original char w/ the count char
#       - else use the existing char
#     - else
#       - use the existing char
#     - map the char back to the board row
#   - join the row chars to form a new_str
#   - map the new_str back to the new_arr
# - rtn the new_arr

  def self.transform(arr)
    # puts
    raise ValueError unless self.valid?(arr)

    arr.map!(&:chars)

    arr.map.with_index do |row, rndx|
      row.map.with_index do |col, cndx|
        if col == ' '
          surroundings = [
            arr[rndx - 1][cndx - 1], arr[rndx - 1][cndx], arr[rndx - 1][cndx + 1],
            arr[rndx][cndx - 1], arr[rndx][cndx + 1],
            arr[rndx + 1][cndx - 1], arr[rndx + 1][cndx], arr[rndx + 1][cndx + 1]
          ]
          mine_count = surroundings.count('*')
          mine_count > 0 ? mine_count.to_s : col
        else
          col
        end
      end.join
    end
  end

# valid?
# ======
# algo:
# - rtn F if
#   - all lines are not the same width
#   - the first line is not at least 3 chars wide
#   - the top and bottom lines are not formatted like '+----+'
#   - any of the middle lines contains chars other than '|', ' ' and '*'
# - rtn T otherwise

  def self.valid?(input)
    # chk top line
    # p "chk_border_line #{input[0]}: #{chk_border_line(input[0])}"
    return false unless chk_border_line(input[0])

    # chk middle lines
    (1...(input.size - 1)).each do |line|
      # p "chk_middle_line #{input[line]}: #{chk_middle_line(input[line])}"
      return false unless chk_middle_line(input[line])
    end

    # chk bottom line
    # p "chk_border_line #{input[-1]}: #{chk_border_line(input[-1])}"
    return false unless chk_border_line(input[-1])

    # chk all lines lengths are equal
    # p "equal line length: #{input.all? { |line| line.size == input[0].size }}"
    return false unless input.all? { |line| line.size == input[0].size }

    # chk board is wide enough
    # p "board width: #{input[0].size}"
    # p "board wide enough: #{input[0].size > 2}"
    return false unless input[0].size > 2

    true
  end

# chk_border_line
# ===============
# algo:
# - rtn T if
#   - the first and last chars are '+' and
#   - the remaining chars are all '-'
# - rtn F otherwise

  def self.chk_border_line(str)
    # str[0] == '+' && str[-1] == '+' && !!!(str[1...(str.length - 1)] =~ /[^-]/) # too cryptic
    return false if str[1...(str.length - 1)] =~ /[^-]/
    str[0] == '+' && str[-1] == '+'
  end

# chk_middle_line
# ===============
# algo:
# - rtn T if
#   - the first and last chars are '|' and
#   - the remaining chars are all ' ' or '*'
# - rtn F otherwise

  def self.chk_middle_line(str)
    # str[0] == '|' && str[-1] == '|' && !!!(str[1...(str.length - 1)] =~ /[^ *]/) # too cryptic
    return false if str[1...(str.length - 1)] =~ /[^ *]/
    str[0] == '|' && str[-1] == '|'
  end
end


class ValueError < StandardError; end


require 'minitest/autorun'
# require_relative 'minesweeper'

class MinesweeperTest < Minitest::Test
  def test_transform1
    # skip
    inp = ['+------+', '| *  * |', '|  *   |', '|    * |', '|   * *|',
           '| *  * |', '|      |', '+------+']
    out = ['+------+', '|1*22*1|', '|12*322|', '| 123*2|', '|112*4*|',
           '|1*22*2|', '|111111|', '+------+']
    assert_equal out, Board.transform(inp)
  end

  def test_transform2
    # skip
    inp = ['+-----+', '| * * |', '|     |', '|   * |', '|  * *|',
           '| * * |', '+-----+']
    out = ['+-----+', '|1*2*1|', '|11322|', '| 12*2|', '|12*4*|',
           '|1*3*2|', '+-----+']
    assert_equal out, Board.transform(inp)
  end

  def test_transform3
    # skip
    inp = ['+-----+', '| * * |', '+-----+']
    out = ['+-----+', '|1*2*1|', '+-----+']
    assert_equal out, Board.transform(inp)
  end

  def test_transform4
    # skip
    inp = ['+-+', '|*|', '| |', '|*|', '| |', '| |', '+-+']
    out = ['+-+', '|*|', '|2|', '|*|', '|1|', '| |', '+-+']
    assert_equal out, Board.transform(inp)
  end

  def test_transform5
    # skip
    inp = ['+-+', '|*|', '+-+']
    out = ['+-+', '|*|', '+-+']
    assert_equal out, Board.transform(inp)
  end

  def test_transform6
    # skip
    inp = ['+--+', '|**|', '|**|', '+--+']
    out = ['+--+', '|**|', '|**|', '+--+']
    assert_equal out, Board.transform(inp)
  end

  # duplicate - ignore this
  # def test_transform7
  #   skip
  #   inp = ['+--+', '|**|', '|**|', '+--+']
  #   out = ['+--+', '|**|', '|**|', '+--+']
  #   assert_equal out, Board.transform(inp)
  # end

  def test_transform8
    # skip
    inp = ['+---+', '|***|', '|* *|', '|***|', '+---+']
    out = ['+---+', '|***|', '|*8*|', '|***|', '+---+']
    assert_equal out, Board.transform(inp)
  end

  def test_transform9
    # skip
    inp = ['+-----+', '|     |', '|   * |', '|     |', '|     |',
           '| *   |', '+-----+']
    out = ['+-----+', '|  111|', '|  1*1|', '|  111|', '|111  |',
           '|1*1  |', '+-----+']
    assert_equal out, Board.transform(inp)
  end

  def test_different_len
    # skip
    inp = ['+-+', '| |', '|*  |', '|  |', '+-+']
    assert_raises(ValueError) do
      Board.transform(inp)
    end
  end

  def test_faulty_border
    # skip
    inp = ['+-----+', '*   * |', '+-- --+']
    assert_raises(ValueError) do
      Board.transform(inp)
    end
  end

  def test_invalid_char
    # skip
    inp = ['+-----+', '|X  * |', '+-----+']
    assert_raises(ValueError) do
      Board.transform(inp)
    end
  end
end
