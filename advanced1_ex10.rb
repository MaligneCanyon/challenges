# Leverage ../oo_programming/exercises/medium1_ex10.rb
class Card
  include Comparable

  CARD_VALUES = {
    'A' => 14,
    'K' => 13,
    'Q' => 12,
    'J' => 11,
    'T' => 10
  }.freeze

  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def value
    CARD_VALUES.fetch(rank, rank.to_i)
  end

  # def to_s
  #   "#{rank} of #{suit}"
  # end

  protected

  def <=>(other)
    value <=> other.value
  end
end


class Hand
  attr_reader :cards, :type, :keycards, :sidecards

  def initialize(arr)
    @cards = arr
    @type = nil
    @keycards = []
    @sidecards = []
    @hsh = Hash.new(0) # a counter for cards having the same value
  end

  def evaluate
    count_cards
    case
    when royal_flush?
      @type = 9
    when straight_flush?
      @type = 8
      sorted_cards = cards.map(&:value).sort
      @keycards = [sorted_cards[-1]] # the value of the highest ranking card
    when four_of_a_kind?
      @type = 7
      @keycards = [hsh.key(4)] # the value of the 4 equally-ranked cards
      @sidecards = [hsh.key(1)] # the value of the other card
    when full_house?
      @type = 6
      @keycards = [hsh.key(3)]
      @sidecards = [hsh.key(2)]
    when flush?
      @type = 5
      sorted_cards = cards.map(&:value).sort
      @keycards = [sorted_cards[-1]]
      @sidecards = sorted_cards[0...-1]
    when straight?
      @type = 4
      sorted_cards = cards.map(&:value).sort
      @keycards = [sorted_cards[-1]]
      @sidecards = sorted_cards[0...-1]
    when three_of_a_kind?
      @type = 3
      @keycards = [hsh.key(3)]
      @sidecards = hsh.select { |k, v| v == 1 }.keys
    when two_pair?
      @type = 2
      @keycards = hsh.select { |k, v| v == 2 }.keys
      @sidecards = hsh.select { |k, v| v == 1 }.keys
    when pair?
      @type = 1
      @keycards = [hsh.key(2)]
      @sidecards = hsh.select { |k, v| v == 1 }.keys
    else
      @type = 0
      sorted_cards = cards.map(&:value).sort
      @keycards = [sorted_cards[-1]]
      @sidecards = sorted_cards[0...-1]
    end
    self # rtn the mutated (evaluated) Hand instance
  end

  private

  attr_reader :hsh

  def count_cards
    # count the num of cards having the same value
    cards.each { |card| @hsh[card.value] += 1 }
  end

  def royal_flush?
    straight_flush? && cards.max.rank == 'A'
  end

  def straight_flush?
    straight? && flush?
  end

  def four_of_a_kind?
    hsh.values.any? { |elem| elem == 4 }
  end

  def full_house?
    hsh.values.any? { |elem| elem == 3 } &&
      hsh.values.any? { |elem| elem == 2 }
  end

  def flush?
    soot = cards.first.suit
    cards.all? { |card| card.suit == soot }
  end

  def straight?
    hsh.values.all? { |elem| elem == 1 } &&
      ((cards.max.value - cards.min.value == 4) || # a regular straight
      (cards.max.value == 14 && cards.map(&:value).sum == 28)) # A,2,3,4,5 # an Ace-low straight
  end

  def three_of_a_kind?
    hsh.values.any? { |elem| elem == 3 } &&
      hsh.values.none? { |elem| elem == 2 }
  end

  def two_pair?
    hsh.values.count { |elem| elem == 2 } == 2
  end

  def pair?
    hsh.values.count { |elem| elem == 2 } == 1
  end
end


class Poker
  attr_reader :type, :cards

  def initialize(hands) # 'hands' is an arr w/ subarrs like %w(4S 5H 6S 8D 2H)
    # p "@hands == ",
    @hands = hands.map { |hand| build(hand) }
  end

# build
# =====
# inputs:
# - an arr of strs like %w(4S 5H 6S 8D 2H)
# outputs:
# - a mutated (evaluated) Hand obj
# reqs:
# - build and evaluate a poker hand from the input str
# rules:
# - none
# struct:
# - Card objs
# - Hand obj
# algo:
# - map the input arr to an arr of Card objs
#   - preserve the original arr so that we can reference it later in tests
# - create a Poker hand (a Hand obj) from the arr of Card objs
# - evaluate the Poker hand and rtn the evaluated Hand obj

  def build(arr)
    arr = arr.map { |elem| Card.new(elem[0], elem[1]) }
    hand = Hand.new(arr)
    hand.evaluate # rtns a mutated (evaluated) Hand obj
  end

# best_hand
# =========
# - could use a recursive algo or iterate thru an arr of criteria [type, keycards, sidecards]
# inputs:
# - arr (of poker hands; each hand is an arr of Cards)
# outputs:
# - arr (the best poker hand(s), w/i an arr)
# reqs:
# - eval which of the input poker hands is better, and rtn the better hand(s)
# rules:
# - best hand_type is the one w/ the highest value of the @type attribute
# - if there is a tie for the highest type (ex. AA234 vrs KK234)
#   - best hand is hand w/ the highest ranking key_card(s) (A vrs K)
#   - if there is a tie for the highest ranking key_card(s) (ex. AA532 vrs AA432)
#     - best hand is hand w/ the highest ranking side_card(s) (532 vrs 432)
#     - if there is a tie for the highest ranking side_card(s) (ex. AA532 vrs AA532)
#       - then the hands are equiv
# struct:
# - arr
# algo:
# - sort the hands by type
# - select hands w/ the highest type
# - if there is > 1 hand w/ the highest type
#   - sort those hands by keycards (highest to lowest)
#   - select hands w/ the highest keycards
#   - if there is > 1 hand w/ the highest keycards
#     - sort those hands by sidecards
#     - select hands w/ the highest sidecards
#     - if there is > 1 hand w/ the highest sidecards
#       - do nothing (a tie)
# - for each selected hand
#   - map the hand elems back to 2-letter strs (rank and suit)
# - rtn the selected hand(s) in an arr

  def best_hand
    @hands.sort_by! { |hand| hand.type }
    # p "@hands ==", @hands
    best = @hands.select { |hand| hand.type == @hands[-1].type }
    # p "best ==", best
    if best.size > 1 # must chk keycards
      best.sort_by! { |hand| hand.keycards.reverse }
      best.select! { |hand| hand.keycards == best[-1].keycards }
      # p "best ==", best
      if best.size > 1 # must chk sidecards
        best.sort_by! { |hand| hand.sidecards }
        best.select! { |hand| hand.sidecards == best[-1].sidecards }
        # if best.size > 1 # a tie
        #   do nothing
        # end
      end
    end
    best.map { |hand| to_rs(hand.cards) }
  end

  def to_rs(arr)
    arr.map { |card| card.rank + card.suit }
  end
end


require 'minitest/autorun'
# require_relative 'poker'

class PokerTest < Minitest::Test
  def test_one_hand
    # skip
    high_of_jack = %w(4S 5S 7H 8D JC)
    game = Poker.new([high_of_jack])
    # p "high_of_jack ==", high_of_jack
    assert_equal [high_of_jack], game.best_hand
  end

  def test_highest_card
    # skip
    high_of_8 = %w(4S 5H 6S 8D 2H)
    high_of_queen = %w(2S 4H 6S TD QH)
    game = Poker.new([high_of_8, high_of_queen])
    # p "high_of_8 ==", high_of_8
    # p "high_of_queen ==", high_of_queen
    assert_equal [high_of_queen], game.best_hand
  end

  def test_nothing_vs_one_pair
    # skip
    high_of_king = %w(4S 5H 6S 8D KH)
    pair_of_4 = %w(2S 4H 6S 4D JH)
    game = Poker.new([high_of_king, pair_of_4])
    assert_equal [pair_of_4], game.best_hand
  end

  def test_two_pair
    # skip
    pair_of_2 = %w(4S 2H 6S 2D JH)
    pair_of_4 = %w(2S 4H 6S 4D JH)
    game = Poker.new([pair_of_2, pair_of_4])
    assert_equal [pair_of_4], game.best_hand
  end

  def test_one_pair_vs_double_pair
    # skip
    pair_of_8 = %w(2S 8H 6S 8D JH)
    double_pair = %w(4S 5H 4S 8D 5H) # note: duplicate cards !
    game = Poker.new([pair_of_8, double_pair])
    assert_equal [double_pair], game.best_hand
  end

  def test_two_double_pair
    # skip
    double_pair_2_and_8 = %w(2S 8H 2S 8D JH)
    double_pair_4_and_5 = %w(4S 5H 4S 8D 5H)
    game = Poker.new([double_pair_2_and_8, double_pair_4_and_5])
    assert_equal [double_pair_2_and_8], game.best_hand
  end

  def test_double_pair_vs_three
    # skip
    double_pair_2_and_8 = %w(2S 8H 2S 8D JH)
    three_of_4 = %w(4S 5H 4S 8D 4H)
    game = Poker.new([double_pair_2_and_8, three_of_4])
    assert_equal [three_of_4], game.best_hand
  end

  def test_two_three
    # skip
    three_of_2 = %w(2S 2H 2S 8D JH)
    three_of_1 = %w(4S AH AS 8D AH)
    game = Poker.new([three_of_2, three_of_1])
    assert_equal [three_of_1], game.best_hand
  end

  def test_three_vs_straight
    # skip
    three_of_4 = %w(4S 5H 4S 8D 4H)
    straight = %w(3S 4H 2S 6D 5H)
    game = Poker.new([three_of_4, straight])
    assert_equal [straight], game.best_hand
  end

  def test_an_ace_low_straight
    # skip
    three_of_4 = %w(4S 5H 4S 8D 4H)
    straight_to_5 = %w(4S AH 3S 2D 5H)
    game = Poker.new([three_of_4, straight_to_5])
    assert_equal [straight_to_5], game.best_hand
  end

  def test_two_straights
    # skip
    straight_to_8 = %w(4S 6H 7S 8D 5H)
    straight_to_9 = %w(5S 7H 8S 9D 6H)
    game = Poker.new([straight_to_8, straight_to_9])
    assert_equal [straight_to_9], game.best_hand
  end

  def test_straight_vs_flush
    # skip
    straight_to_8 = %w(4S 6H 7S 8D 5H)
    flush_to_7 = %w(2S 4S 5S 6S 7S)
    game = Poker.new([straight_to_8, flush_to_7])
    assert_equal [flush_to_7], game.best_hand
  end

  def test_two_flushes
    # skip
    flush_to_8 = %w(3H 6H 7H 8H 5H)
    flush_to_7 = %w(2S 4S 5S 6S 7S)
    game = Poker.new([flush_to_8, flush_to_7])
    assert_equal [flush_to_8], game.best_hand
  end

  def test_flush_vs_full
    # skip
    flush_to_8 = %w(3H 6H 7H 8H 5H)
    full = %w(4S 5H 4S 5D 4H)
    game = Poker.new([flush_to_8, full])
    assert_equal [full], game.best_hand
  end

  def test_two_fulls
    # skip
    full_of_4_by_9 = %w(4H 4S 4D 9S 9D)
    full_of_5_by_8 = %w(5H 5S 5D 8S 8D)
    game = Poker.new([full_of_4_by_9, full_of_5_by_8])
    assert_equal [full_of_5_by_8], game.best_hand
  end

  def test_full_vs_square
    # skip
    full = %w(4S 5H 4S 5D 4H)
    square_of_3 = %w(3S 3H 2S 3D 3H)
    game = Poker.new([square_of_3, full])
    assert_equal [square_of_3], game.best_hand
  end

  def test_two_square
    # skip
    square_of_2 = %w(2S 2H 2S 8D 2H)
    square_of_5 = %w(4S 5H 5S 5D 5H)
    game = Poker.new([square_of_2, square_of_5])
    assert_equal [square_of_5], game.best_hand
  end

  def test_square_vs_straight_flush
    # skip
    square_of_5 = %w(4S 5H 5S 5D 5H)
    straight_flush_to_9 = %w(5S 7S 8S 9S 6S)
    game = Poker.new([square_of_5, straight_flush_to_9])
    assert_equal [straight_flush_to_9], game.best_hand
  end

  def test_two_straight_flushes
    # skip
    straight_flush_to_8 = %w(4H 6H 7H 8H 5H)
    straight_flush_to_9 = %w(5S 7S 8S 9S 6S)
    game = Poker.new([straight_flush_to_8, straight_flush_to_9])
    assert_equal [straight_flush_to_9], game.best_hand
  end

  def test_three_hand_with_tie
    # skip
    spade_straight_to_9 = %w(9S 8S 7S 6S 5S)
    diamond_straight_to_9 = %w(9D 8D 7D 6D 5D)
    three_of_4 = %w(4D 4S 4H QS KS)
    hands = [spade_straight_to_9, diamond_straight_to_9, three_of_4]
    game = Poker.new(hands)
    assert_equal [spade_straight_to_9, diamond_straight_to_9], game.best_hand
  end

  # bonus pain ...
  def test_two_equal_double_pair
    # skip
    double_pair_2_and_8_with_J = %w(2S 8S 2H 8H JH)
    double_pair_2_and_8_with_T = %w(2D 8D 2C 8C TH)
    game = Poker.new([double_pair_2_and_8_with_J, double_pair_2_and_8_with_T])
    assert_equal [double_pair_2_and_8_with_J], game.best_hand
  end
end
