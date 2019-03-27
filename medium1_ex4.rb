# of_codon
# --------
# inputs:
# - str (a codon)
# outputs:
# - str (an amino acid)
# reqs:
# - given a codon as input, return an amino acid
# rules:
# - none
# struct:
# - hsh
# algo:
# - construct a lookup table w/ codon keys and amino acid values
# - fetch the amino acid from the hash for the input codon (key)
# - if the input codon str is not found
#   - raise an err
# - else
#   - rtn the amino acid associated w/ the codon

# of_rna
# ------
# inputs:
# - str (RNA strand)
# outputs:
# - arr (of amino acid strs)
# reqs:
# - given an input str representing an RNA strand (composed of 3-char codons),
#   rtn a new_arr containing amino acids corresponding to those codons
# - if a STOP codon is encountered, immediately rtn the new_arr
# rules:
# - none
# struct:
# - arr
# algo:
# - init a new_arr (amino_acids) to []
# - split the input str (RNA strand) into an arr of 3-char substrs (codons)
#   - splice(strand, 3)
# - for each substr (codon)
#   - determine the amino acid
#     - of_codon(codon)
#   - if the result is 'STOP'
#     - break
#   - else
#     - add the amino acid to the new_arr
# - rtn the new_arr

# splice
# ------
# input:
# - str
# - int n (num of chars in each group that str is split into)
# output:
# - arr of char groups
# reqs:
# - split the str into substr that are n chars long
# - place the substrs in an arr and rtn the arr
# rules:
# - n is always 3 in this exercise
# struct:
# - arr
# algo:
# - init a new_arr to []
# - split the str into an arr of chars
# - for each group of n chars in the arr
#   - join the chars to form a substr
#   - copy the substr to the new_arr
# - rtn the new_arr


class InvalidCodonError < KeyError; end
class Translation
  CODEIN = {
    AUG: 'Methionine',
    UUU: 'Phenylalanine',
    UUC: 'Phenylalanine',
    UUA: 'Leucine',
    UUG: 'Leucine',
    UCU: 'Serine',
    UCC: 'Serine',
    UCA: 'Serine',
    UCG: 'Serine',
    UAU: 'Tyrosine',
    UAC: 'Tyrosine',
    UGU: 'Cysteine',
    UGC: 'Cysteine',
    UGG: 'Tryptophan',
    UAA: 'STOP',
    UAG: 'STOP',
    UGA: 'STOP'
  }

  def self.of_codon(codon)
    CODEIN.fetch(codon.to_sym) { raise InvalidCodonError }
  end

  def self.of_rna(strand)
    amino_acids = []
    # codons = self.splice(strand, 3)
    codons = strand.scan(/.../)
    codons.each do |codon|
      acid = self.of_codon(codon)
      break if acid == 'STOP'
      amino_acids << acid
    end
    amino_acids
  end

  # def self.splice(str, n)
  #   new_arr = []
  #   str.chars.each_slice(n) { |slice| new_arr << slice.join }
  #   new_arr
  # end
end


require 'minitest/autorun'
# require_relative 'protein_translation'

# rubocop:disable Style/MethodName
class TranslationTest < Minitest::Test
  def test_AUG_translates_to_methionine
    assert_equal 'Methionine', Translation.of_codon('AUG')
  end

  def test_identifies_Phenylalanine_codons
    # skip
    assert_equal 'Phenylalanine', Translation.of_codon('UUU')
    assert_equal 'Phenylalanine', Translation.of_codon('UUC')
  end

  def test_identifies_Leucine_codons
    # skip
    %w(UUA UUG).each do |codon|
      assert_equal 'Leucine', Translation.of_codon(codon)
    end
  end

  def test_identifies_Serine_codons
    # skip
    %w(UCU UCC UCA UCG).each do |codon|
      assert_equal 'Serine', Translation.of_codon(codon)
    end
  end

  def test_identifies_Tyrosine_codons
    # skip
    %w(UAU UAC).each do |codon|
      assert_equal 'Tyrosine', Translation.of_codon(codon)
    end
  end

  def test_identifies_Cysteine_codons
    # skip
    %w(UGU UGC).each do |codon|
      assert_equal 'Cysteine', Translation.of_codon(codon)
    end
  end
  def test_identifies_Tryptophan_codons
    # skip
    assert_equal 'Tryptophan', Translation.of_codon('UGG')
  end

  def test_identifies_stop_codons
    # skip
    %w(UAA UAG UGA).each do |codon|
      assert_equal 'STOP', Translation.of_codon(codon)
    end
  end

  def test_translates_rna_strand_into_correct_protein
    # skip
    strand = 'AUGUUUUGG'
    expected = %w(Methionine Phenylalanine Tryptophan)
    assert_equal expected, Translation.of_rna(strand)
  end

  def test_stops_translation_if_stop_codon_present
    # skip
    strand = 'AUGUUUUAA'
    expected = %w(Methionine Phenylalanine)
    assert_equal expected, Translation.of_rna(strand)
  end

  def test_stops_translation_of_longer_strand
    # skip
    strand = 'UGGUGUUAUUAAUGGUUU'
    expected = %w(Tryptophan Cysteine Tyrosine)
    assert_equal expected, Translation.of_rna(strand)
  end

  def test_invalid_codons
    # skip
    strand = 'CARROT'
    assert_raises(InvalidCodonError) do
      Translation.of_rna(strand)
    end
  end
end
