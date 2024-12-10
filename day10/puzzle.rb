require_relative "../lib/grid"

class TopographicMap < Grid
  def trailheads = @trailheads ||= select { |num, *| num.zero? }
  def score_trailheads = trailheads.sum { |_, row, col| dfs(row, col, visit_set: Set.new) }
  def rate_trailheads = trailheads.sum { |_, row, col| dfs(row, col) }

  private

  def dfs(row, col, trail_end_count = 0, visit_set: nil)
    if @grid[row][col] == 9
      if visit_set
        return 0 if visit_set.include?([row, col])
        visit_set << [row, col]
      end

      return trail_end_count + 1
    end

    CARDINALS.sum do |dr, dc|
      nr, nc = row + dr, col + dc
      next 0 unless valid_position?(nr, nc) && @grid[nr][nc].pred == @grid[row][col]

      dfs(nr, nc, trail_end_count, visit_set:)
    end
  end
end

grid_input = ARGF.readlines(chomp: true).map { _1.chars.map(&:to_i) }
map = TopographicMap.new(grid_input)

p map.score_trailheads # p1
p map.rate_trailheads  # p2
