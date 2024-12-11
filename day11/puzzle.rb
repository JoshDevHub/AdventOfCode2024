module IntegerHelpers
  refine Integer do
    def length = to_s.length
    def even_digits? = length.even?
    def split = to_s.chars.each_slice(length / 2).map { _1.join.to_i }
  end
end

class StoneLine
  using IntegerHelpers

  def initialize(input) = @input = input.clone

  def count = @input.values.sum

  def blink!(count)
    count.times do
      merge_dict = Hash.new(0)
      @input.each do |n, tally|
        if n.zero?
          merge_dict[1] += tally
        elsif n.even_digits?
          n.split.each { merge_dict[_1] += tally }
        else
          merge_dict[n * 2024] += tally
        end

        @input[n] = 0
      end

      @input.merge!(merge_dict) { |_k, old, new| old + new }
    end

    self
  end
end

input = ARGF.read.split.map(&:to_i).tally

p StoneLine.new(input).blink!(25).count # p1
p StoneLine.new(input).blink!(75).count # p2
