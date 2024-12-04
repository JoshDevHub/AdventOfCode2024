class XmasGrid
  def initialize(grid)
    @grid = grid
  end

  DIAGONALS = [[-1, -1], [1, 1], [-1, 1], [1, -1]].freeze
  DIRECTIONS = [[0, 1], [0, -1], [1, 0], [-1, 0], *DIAGONALS].freeze

  CROSSES_AROUND_A = %w[MSSM MSMS SMSM SMMS].freeze

  include Enumerable
  def each
    @grid.each_with_index do |row, row_idx|
      row.each_with_index do |char, col_idx|
        yield char, row_idx, col_idx
      end
    end
  end

  def count_xmas
    sum do |char, row_idx, col_idx|
      next(0) unless char == "X"

      DIRECTIONS.count do |drow, dcol|
        slice_indices = 4.times.map { |i| [row_idx + (drow * i), col_idx + (dcol * i)] }
        next if slice_indices.any? { |r, c| r.negative? || c.negative? }

        candidate = slice_indices.map { |r, c| @grid.dig(r, c) }.join
        candidate == "XMAS"
      end
    end
  end

  def count_x_mas
    count do |char, row_idx, col_idx|
      next unless char == "A"

      adjs = DIAGONALS.map do |(drow, dcol)|
        n_row, n_col = [row_idx + drow, col_idx + dcol]
        next if n_row.negative? || n_col.negative?

        @grid.dig(n_row, n_col)
      end

      CROSSES_AROUND_A.include?(adjs.join)
    end
  end
end

input = ARGF.readlines.map(&:chars)

p XmasGrid.new(input).count_xmas  # p1

p XmasGrid.new(input).count_x_mas # p2
