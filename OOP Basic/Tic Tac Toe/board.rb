# frozen_string_literal: true

class Board
  attr_reader :pieces_map, :rows, :cols

  def initialize(rows = 20, cols = 20)
    @rows = rows
    @cols = cols
    @pieces_map = Array.new(rows) { Array.new(cols) }
  end

  def validate_move(pos_index)
    raise ArgumentError, 'Position must be within bounds!' if pos_index.negative? || pos_index > rows * cols - 1

    row_index = (pos_index / cols).floor
    col_index = pos_index % cols

    return if @pieces_map[row_index][col_index].nil?

    raise ArgumentError, 'Position occupied!'
  end

  def index_to_row_col(index)
    validate_move(index)

    row_index = (index / cols).floor
    col_index = index % cols

    [row_index, col_index]
  end

  def place_piece_by_index(piece, index)
    pos = index_to_row_col(index)
    place_piece(piece, pos[0], pos[1])

    pos
  end

  def place_piece(piece, row, col)
    @pieces_map[row][col] = piece
  end

  def pos_arrays(row, col, radius = 4)
    top_row = [row - radius, 0].max
    bottom_row = [row + radius, rows - 1].min
    left_col = [col - radius, 0].max
    right_col = [col + radius, cols - 1].min

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

  def draw_board
    board_str = ''

    (0..rows - 1).each do |row|
      (0..cols - 1).each do |col|
        board_str += if !@pieces_map[row][col].nil?
                       "| #{@pieces_map[row][col]} |"
                     else
                       "|#{format('%03d', col + row * cols)}|"
                     end
      end

      board_str += "\n"
    end

    board_str
  end
end
