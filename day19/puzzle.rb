require_relative "../lib/cachable"

class LinensLayout
  prepend Cachable

  def initialize(patterns, designs)
    @patterns = patterns
    @designs = designs
  end

  def total_possible_designs = @designs.count { possible? _1 }

  def total_pattern_combinations = @designs.sum { count_possible_patterns _1 }

  private

  cache :count_possible_patterns
  def count_possible_patterns(design)
    return 1 if design.empty?

    @patterns.sum do |pattern|
      next(0) unless design.start_with?(pattern)

      count_possible_patterns(design[pattern.length..])
    end
  end

  cache :possible?
  def possible?(design)
    return true if design.empty?

    @patterns.any? do |pattern|
      next unless design.start_with?(pattern)

      possible?(design[pattern.length..])
    end
  end
end

pattern_input, design_input = ARGF.read.split("\n\n")

patterns = pattern_input.split(", ")
designs = design_input.split

layout = LinensLayout.new(patterns, designs)

p layout.total_possible_designs      # p1
p layout.total_pattern_combinations  # p2
