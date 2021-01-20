#!/usr/bin/env ruby

require_relative '../enumerables'

ARRAY_SIZE = 10
LOWEST_VALUE = 0
HIGHEST_VALUE = 9

RSpec.describe 'enumerables' do
  let(:results_array) { [] }
  let(:my_results_array) { [] }
  let(:push_element) { proc { |element| results_array << element } }
  let(:my_push_element) { proc { |element| my_results_array << element } }
  let(:push_element_and_index) do
    proc do |element, index|
      results_array << element
      results_array << index
    end
  end
  let(:my_push_element_and_index) do
    proc do |element, index|
      my_results_array << element
      my_results_array << index
    end
  end
  let(:array) { Array.new(ARRAY_SIZE) { rand(LOWEST_VALUE...HIGHEST_VALUE) } }
  let(:block) { proc { |num| num < (LOWEST_VALUE + HIGHEST_VALUE) / 2 } }
  let(:empty_block) { proc {} }
  let(:range) { Range.new(5, 50) }
  let(:hash) { { a: 1, b: 2, c: 3, d: 4, e: 5 } }
  describe '#my_each' do
    it 'loops trough an array and push elements to a new array' do
      array.my_each(&my_push_element)
      array.each(&push_element)
      expect(my_results_array).to match_array(results_array)
    end
    it 'loops trough an range and push elements to a new array' do
      range.my_each(&my_push_element)
      range.each(&push_element)
      expect(my_results_array).to match_array(results_array)
    end
    it 'loops trough an hash and push elements to a new array' do
      hash.my_each(&my_push_element)
      hash.each(&push_element)
      expect(my_results_array).to match_array(results_array)
    end
    it 'returns Enumerator if no block given' do
      expect(array.my_each).to be_a(Enumerator)
    end
    it 'returns the array itself when a block is given' do
      expect(array.my_each(&empty_block)).to eq(array)
    end
    it 'returns the range itself when a block is given' do
      expect(range.my_each(&empty_block)).to eq(range)
    end
    it 'returns the hash itself when a block is given' do
      expect(hash.my_each(&empty_block)).to eq(hash)
    end
  end
  describe '#my_each_with_index' do
    it 'loops trough an array and push elements to a new array' do
      array.my_each(&my_push_element_and_index)
      array.each(&push_element_and_index)
      expect(my_results_array).to match_array(results_array)
    end
    it 'loops trough an range and push elements to a new array' do
      range.my_each(&my_push_element_and_index)
      range.each(&push_element_and_index)
      expect(my_results_array).to match_array(results_array)
    end
    it 'loops trough an hash and push elements to a new array' do
      hash.my_each(&my_push_element_and_index)
      hash.each(&push_element_and_index)
      expect(my_results_array).to match_array(results_array)
    end
    it 'returns Enumerator if no block given' do
      expect(array.my_each).to be_a(Enumerator)
    end
    it 'returns the array itself when a block is given' do
      expect(array.my_each(&empty_block)).to eq(array)
    end
    it 'returns the range itself when a block is given' do
      expect(range.my_each(&empty_block)).to eq(range)
    end
    it 'returns the hash itself when a block is given' do
      expect(hash.my_each(&empty_block)).to eq(hash)
    end
  end
end
