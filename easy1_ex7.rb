# inputs:
# - 2 strs
# outputs:
# - int
# reqs:
# - compare two strs
# - count the difs btwn the strs
# rules:
# - only count difs upto the min str length
# struct:
# - arr
# algo:
# - convert the strs to arrs of chars
# - init a counter at 0
# - determine the min str size
# - for each ndx from 0 to the min str size
#   - compare the chars in the two strs at the current ndx
#   - incr the counter if the chars differ
# - rtn the counter


class DNA
  def initialize(strand1)
    @strand1 = strand1.chars
  end

  def hamming_distance(strand2)
    @strand2 = strand2.chars
    counter = 0
    min_size = [@strand1.size, @strand2.size].min
    (0...min_size).each do |ndx|
      counter += 1 unless @strand1[ndx] == @strand2[ndx]
    end
    counter
  end
end
# p DNA.new('GAGCCTACTAACGGGAT').hamming_distance('CATCGTAATGACGGCCT') == 7


require 'minitest/autorun'
# require_relative 'point_mutations'

class DNATest < Minitest::Test
  def test_no_difference_between_empty_strands
    assert_equal 0, DNA.new('').hamming_distance('')
  end

  def test_no_difference_between_identical_strands
    # skip
    assert_equal 0, DNA.new('GGACTGA').hamming_distance('GGACTGA')
  end

  def test_complete_hamming_distance_in_small_strand
    # skip
    assert_equal 3, DNA.new('ACT').hamming_distance('GGA')
  end

  def test_hamming_distance_in_off_by_one_strand
    # skip
    strand = 'GGACGGATTCTGACCTGGACTAATTTTGGGG'
    distance = 'AGGACGGATTCTGACCTGGACTAATTTTGGGG'
    assert_equal 19, DNA.new(strand).hamming_distance(distance)
  end

  def test_small_hamming_distance_in_middle_somewhere
    # skip
    assert_equal 1, DNA.new('GGACG').hamming_distance('GGTCG')
  end

  def test_larger_distance
    # skip
    assert_equal 2, DNA.new('ACCAGGG').hamming_distance('ACTATGG')
  end

  def test_ignores_extra_length_on_other_strand_when_longer
    # skip
    assert_equal 3, DNA.new('AAACTAGGGG').hamming_distance('AGGCTAGCGGTAGGAC')
  end

  def test_ignores_extra_length_on_original_strand_when_longer
    # skip
    strand = 'GACTACGGACAGGGTAGGGAAT'
    distance = 'GACATCGCACACC'
    assert_equal 5, DNA.new(strand).hamming_distance(distance)
  end

  def test_does_not_actually_shorten_original_strand
    # skip
    dna = DNA.new('AGACAACAGCCAGCCGCCGGATT')
    assert_equal 1, dna.hamming_distance('AGGCAA')
    assert_equal 4, dna.hamming_distance('AGACATCTTTCAGCCGCCGGATTAGGCAA')
    assert_equal 1, dna.hamming_distance('AGG')
  end
end
