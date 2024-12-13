require_relative "../lib/grid"
require "forwardable"

class GardenGroup < Grid
  def initialize(...)
    super(...)
    @plotted = Set.new
  end

  CORNER_ADJS = [%i[up left], %i[up right], %i[down right], %i[down left]]
                .map { LABELED_DIRS.values_at _1, _2 }

  Region = Data.define(:label, :positions) do
    extend Forwardable
    def_delegators :positions, :<<, :empty?, :length, :include?
    alias_method :area, :length

    def perimeter
      positions.sum do |pos|
        CARDINALS.count { |dir| !include?(pos + dir) }
      end
    end

    def number_of_sides
      positions.sum do |pos|
        CORNER_ADJS.count do |a, b|
          (!include?(a + pos) && !include?(b + pos)) ||
            (include?(a + pos) && include?(b + pos) && !include?(a + b + pos))
        end
      end
    end

    def fence_cost = area * perimeter
    def discount_fence_cost = area * number_of_sides
  end

  def regions = @regions ||= @grid.map { map_region(_1, _2) }.reject(&:empty?)
  def total_fence_cost = regions.sum(&:fence_cost)
  def discount_fence_cost = regions.sum(&:discount_fence_cost)

  def map_region(curr_pos, curr_char, curr_region = nil)
    curr_region ||= Region[curr_char, Set.new]
    return curr_region if @grid[curr_pos] != curr_char || @plotted.include?(curr_pos)

    @plotted << curr_pos
    curr_region << curr_pos
    CARDINALS.each { |adj| map_region(adj + curr_pos, curr_char, curr_region) }

    curr_region
  end
end

garden_group = GardenGroup.from_raw_input(ARGF.read.strip)

p garden_group.total_fence_cost    # p1
p garden_group.discount_fence_cost # p2
