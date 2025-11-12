# frozen_string_literal: true

require 'matrix'
require_relative '../chess_piece'

# king
class King < ChessPiece
  def initialize(chess_board, side)
    super(chess_board, 'king', side)
  end

  def checked?
    if @side == 'black'
      pieces = @chess_board.pieces[:white]
      pieces.each do |piece|
        return true if piece.check_mate?
      end
    end

    if @side == 'white'
      pieces = @chess_board.pieces[:black]
      pieces.each do |piece|
        return true if piece.check_mate?
      end
    end

    false
  end

  def available_moves
    return [] if pos.nil?

    moves = []

    # check for default moves
    end_pos = []
    # straight
    end_pos << @pos + Vector[0, 1]
    end_pos << @pos + Vector[0, -1]
    end_pos << @pos + Vector[1, 0]
    end_pos << @pos + Vector[-1, 0]

    # diagonal
    end_pos << @pos + Vector[1, 1]
    end_pos << @pos + Vector[-1, -1]
    end_pos << @pos + Vector[1, -1]
    end_pos << @pos + Vector[-1, 1]

    end_pos.each do |end_p|
      default_moves = ray_cast(@pos, end_p)
      moves.concat(default_moves)
    end

    moves
  end
end
