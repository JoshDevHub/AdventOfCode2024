class Grid
  def initialize(grid)
    @grid = grid
  end

  CARDINALS = [[1, 0], [0, 1], [-1, 0], [0, -1]].freeze
  DIAGONALS = [[-1, -1], [1, 1], [-1, 1], [1, -1]].freeze

  ALL_DIRECTIONS = CARDINALS + DIAGONALS

  include Enumerable
  def each
    @grid.each_with_index do |row, row_idx|
      row.each_with_index do |elem, col_idx|
        yield elem, row_idx, col_idx
      end
    end
  end

  def valid_position?(row, col)
    row >= 0 && row < @grid.length && col >= 0 && col < @grid.length
  end

  def get(row, col)
    @grid[row][col] if valid_position?(row, col)
  end

  def adjacents_for_position(row, col, adj_directions: ALL_DIRECTIONS)
    adj_directions.filter_map do |d_row, d_col|
      a_row, a_col = [row + d_row, col + d_col]
      get(a_row, a_col)
    end
  end

  def collect_adjacents_in_direction(row, col, adj_directions:, length:)
    adj_directions.map do |d_row, d_col|
      length.times.filter_map do |offset|
        a_row, a_col = [row + (d_row * offset), col + (d_col * offset)]
        get(a_row, a_col)
      end
    end
  end
end