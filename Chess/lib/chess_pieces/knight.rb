# frozen_string_literal: true

require 'matrix'
require_relative '../chess_piece'

# knight
class Knight < ChessPiece
  def initialize(chess_board, side)
    super(chess_board, 'knight', side)
  end

  def available_moves
    return [] if pos.nil?

    moves = []

    # check for default moves
    end_pos = []
    end_pos << @pos + Vector[1, 2]
    end_pos << @pos + Vector[2, 1]
    end_pos << @pos + Vector[-1, 2]
    end_pos << @pos + Vector[-2, 1]
    end_pos << @pos + Vector[1, -2]
    end_pos << @pos + Vector[2, -1]
    end_pos << @pos + Vector[-1, -2]
    end_pos << @pos + Vector[-2, -1]

    end_pos.each do |end_p|
      next if @chess_board.out_bound?(end_p)

      piece = @chess_board.get_piece(end_p)
      moves << end_p if !piece.nil? && piece.side != @side
      moves << end_p if piece.nil?
    end

    moves
  end
end
