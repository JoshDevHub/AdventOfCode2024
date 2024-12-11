module IntegerHelpers
  refine Integer do
    def length = to_s.length
    def even_digits? = length.even?
    def split = to_s.chars.each_slice(length / 2).map { _1.join.to_i }
  end
end

class StoneLine
  using IntegerHelpers

  def initialize(input)
   @input = input
   @cache = {}
  end

  def total_for(blink_count:) = @input.sum { blink(_1, blink_count) }

  private

  def blink(stone, iteration)
    return 1 if iteration == 0

    @cache[[stone, iteration]] ||=
      if stone == 0
        blink(1, iteration - 1)
      elsif stone.even_digits?
        stone.split.sum { blink(_1, iteration - 1) }
      else
        blink(stone * 2024, iteration - 1)
      end
  end
end

input = ARGF.read.split.map(&:to_i)
stones = StoneLine.new(input)

p stones.total_for(blink_count: 25) # p1
p stones.total_for(blink_count: 75) # p2
