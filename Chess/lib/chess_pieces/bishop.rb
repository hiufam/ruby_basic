# frozen_string_literal: true

require 'matrix'
require_relative '../chess_piece'

# bishop
class Bishop < ChessPiece
  def initialize(chess_board, side)
    super(chess_board, 'bishop', side)
  end

  def available_moves
    return [] if pos.nil?

    moves = []

    # check for default moves
    end_pos = []
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
