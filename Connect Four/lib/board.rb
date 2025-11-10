class Board
  attr_accessor :pieces_map
  attr_reader :rows_counts, :cols_count

  def initialize
    @rows_counts = 6
    @cols_counts = 7
    @pieces_map = Array.new(@rows_counts) { Array.new(@cols_counts) }
  end

  def place_piece(piece, col)
    validate_move(col)

    (0..(@rows_counts - 1)).to_a.reverse_each do |row|
      if @pieces_map[row][col].nil?
        @pieces_map[row][col] = piece
        return [row, col]
      end
    end
  end

  def validate_move(col)
    raise StandardError, 'Invalid move' if col.negative? || col > @cols_counts - 1
    raise StandardError, 'Column is full' unless @pieces_map[0][col].nil?
  end

  def check_win?(piece, pos)
    row = pos[0]
    col = pos[1]

    pos_arrays(row, col).each do |arr|
      return true if arr.count(piece) >= 4
    end

    false
  end

  def pos_arrays(row, col, radius = 3)
    top_row = [row - radius, 0].max
    bottom_row = [row + radius, @rows_counts - 1].min
    left_col = [col - radius, 0].max
    right_col = [col + radius, @cols_counts - 1].min

    vertical_array = []
    horizontal_array = []
    diagonal_array = []
    anti_diagonal_array = []

    (top_row..bottom_row).each do |row_index|
      vertical_array.push(@pieces_map[row_index][col])
    end

    (left_col..right_col).each do |col_index|
      horizontal_array.push(@pieces_map[row][col_index])
    end

    # get 4 corners of the square surrounding the position
    top_left_offset = [row - top_row, col - left_col].min
    top_left = [row - top_left_offset, col - top_left_offset]

    top_right_offset = [row - top_row, right_col - col].min
    top_right = [row - top_right_offset, col + top_right_offset]

    bottom_left_offset = [bottom_row - row, col - left_col].min
    bottom_left = [row + bottom_left_offset, col - bottom_left_offset]

    bottom_right_offset = [bottom_row - row, right_col - col].min
    bottom_right = [row + bottom_right_offset, col + bottom_right_offset]

    offset = 0
    while top_left[0] + offset < bottom_right[0] + 1 && top_left[1] + offset < bottom_right[1] + 1
      diagonal_array.push(@pieces_map[top_left[0] + offset][top_left[1] + offset])

      offset += 1
    end

    offset = 0
    while bottom_left[0] - offset > top_right[0] - 1 && bottom_left[1] + offset < top_right[1] + 1
      anti_diagonal_array.push(@pieces_map[bottom_left[0] - offset][bottom_left[1] + offset])

      offset += 1
    end

    [vertical_array, horizontal_array, diagonal_array, anti_diagonal_array]
  end
end
