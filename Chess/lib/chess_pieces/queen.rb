# frozen_string_literal: true

require 'matrix'
require_relative '../chess_piece'

# queen
class Queen < ChessPiece
  def initialize(chess_board, side)
    super(chess_board, 'queen', side)
  end

  def available_moves
    return [] if pos.nil?

    moves = []

    # check for default moves
    end_pos = []
    # straight
    end_pos << @pos + Vector[0, 7]
    end_pos << @pos + Vector[0, -7]
    end_pos << @pos + Vector[7, 0]
    end_pos << @pos + Vector[-7, 0]

    # diagonal
    end_pos << @pos + Vector[7, 7]
    end_pos << @pos + Vector[-7, -7]
    end_pos << @pos + Vector[7, -7]
    end_pos << @pos + Vector[-7, 7]

    end_pos.each do |end_p|
      default_moves = ray_cast(@pos, end_p)
      moves.concat(default_moves)
    end

    moves
  end
end
