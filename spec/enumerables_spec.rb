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
  let(:words) { %w[dog door rod blade] }
  let(:expected) { 'dog' }
  let(:false_array) { [nil, true, 99] }
  let(:true_array) { [1, 2i, 3.14] }
  let(:falsy_array) { [false, nil, false, false] }
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
  describe '#my_select' do
    it 'selects the item from the array' do
      favorites = words.my_select { |words| words == expected }
      expect(favorites).to eq([expected])
    end
    it 'returns Enumerator if no block given' do
      enumerator = array.my_select
      expect(enumerator).to be_a Enumerator
    end
  end
  describe '#my_all?' do
    it 'returns true with no block and no falsy elements' do
      expect(false_array.my_all?).not_to be(true)
      expect(true_array.my_all?).to be(true)
    end
    it 'returns true with class argument and all elements are members' do
      expect(array.my_all?(Integer)).to be(true)
      expect(true_array.my_all?(Integer)).not_to be(true)
    end
    it 'returns true when all elements match the regex' do
      expect(words.my_all?(/t/)).not_to be(true)
      expect(words.my_all?(/[aeiou]/)).to be(true)
    end
    it 'returns true when given a block all elements evaluate to true' do
      expect(words.my_all? { |word| word.length >= 3 }).to be(true)
      expect(words.my_all? { |word| word.length >= 4 }).not_to be(true)
    end
    it 'returns true when no argument or block given in an empty array' do
      expect(results_array.my_all?).to be(true)
    end
    it 'can handle case when no parameter, false or nil is given' do
      expect(true_array.my_all?).to be(true)
      expect(true_array.my_all?(nil)).not_to be(true)
      expect(true_array.my_all?(false)).not_to be(true)
      array.push(false)
      expect(true_array.my_all?).to be(true)
      expect(true_array.my_all?(nil)).not_to be(true)
      expect(true_array.my_all?(false)).not_to be(true)
      array.pop
      array.push(nil)
      expect(true_array.my_all?).to be(true)
      expect(true_array.my_all?(nil)).not_to be(true)
      expect(true_array.my_all?(false)).not_to be(true)
    end
  end
  describe '#my_any?' do
    it 'returns true with no block and at least one truthy elements' do
      expect(true_array.my_any?).to be(true)
      expect(falsy_array.my_any?).not_to be(true)
    end
    it 'returns true with class argument and any elements are members' do
      expect(array.my_any?(Integer)).to be(true)
      expect(falsy_array.my_any?(Integer)).not_to be(true)
    end
    it 'returns true when any elements match the regex' do
      expect(words.my_any?(/l/)).to be(true)
      expect(words.my_any?(/p/)).not_to be(true)
    end
    it 'returns true when given a block and any elements evaluate to true' do
      expect(words.my_any? { |word| word.length >= 4 }).to be(true)
      expect(words.my_any? { |word| word.length >= 6 }).not_to be(true)
    end
    it 'returns false when no argument or block given in an empty array' do
      expect(results_array.my_any?).to be(false)
    end
    it 'can handle case when no parameter, false or nil is given' do
      expect(array.my_any?).to be(true)
      expect(array.my_any?(nil)).to be(false)
      expect(array.my_any?(false)).to be(false)
      array.push(false)
      expect(array.my_any?).to be(true)
      expect(array.my_any?(nil)).to be(false)
      expect(array.my_any?(false)).to be(true)
      array.pop
      array.push(nil)
      expect(array.my_any?).to be(true)
      expect(array.my_any?(nil)).to be(true)
      expect(array.my_any?(false)).to be(false)
    end
  end
  describe '#my_none?' do
    it 'returns true with no block and no truthy elements' do
      expect(true_array.my_none?).to be(false)
      expect(falsy_array.my_none?).not_to be(false)
    end
    it 'returns true with class argument and no elements are members' do
      expect(array.my_none?(Integer)).to be(false)
      expect(falsy_array.my_none?(Integer)).not_to be(false)
    end
    it 'returns true when no elements match the regex' do
      expect(words.my_none?(/l/)).to be(false)
      expect(words.my_none?(/p/)).not_to be(false)
    end
    it 'returns true when given a block and no elements evaluate to true' do
      expect(words.my_none? { |word| word.length >= 4 }).to be(false)
      expect(words.my_none? { |word| word.length >= 6 }).not_to be(false)
    end
    it 'returns true when no argument or block given in an empty array' do
      expect(results_array.my_none?).to be(true)
    end
    it 'returns false when no block and nil or false argument' do
      expect(array.my_none?).to be(false)
    end
    it 'can handle case when no parameter, false or nil is given' do
      expect(array.my_none?).to be(false)
      expect(array.my_none?(nil)).to be(true)
      expect(array.my_none?(false)).to be(true)
      array.push(false)
      expect(array.my_none?).to be(false)
      expect(array.my_none?(nil)).to be(true)
      expect(array.my_none?(false)).to be(false)
      array.pop
      array.push(nil)
      expect(array.my_none?).to be(false)
      expect(array.my_none?(nil)).to be(false)
      expect(array.my_none?(false)).to be(true)
    end
  end
end
