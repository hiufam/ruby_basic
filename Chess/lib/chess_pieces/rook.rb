# frozen_string_literal: true

require 'matrix'
require_relative '../chess_piece'

# rook
class Rook < ChessPiece
  def initialize(chess_board, side)
    super(chess_board, 'rook', side)
  end

  def change_pos(new_pos)
    piece = @chess_board.get_piece(new_pos)

    # Castle move
    if !piece.nil? && piece.type == 'king' && piece.side == @side
      raise StandardError, 'king is checked cannot castle' if piece.checked?

      castle_direction = (new_pos - @pos).normalize

      @chess_board.make_move(new_pos + castle_direction * -1, piece)
      @chess_board.make_move(new_pos, self)
      return
    end

    unless @pos.nil?
      temp_pos = @pos
      @prev_move = temp_pos

      @chess_board.set_piece(temp_pos, nil)
    end
    @pos = new_pos
    @chess_board.set_piece(new_pos, self)
  end

  def available_moves
    return [] if pos.nil?

    moves = []

    on_piece_casted = proc do |piece|
      moves << piece.pos if piece.type == 'king' && piece.side == @side && @prev_move.nil? && piece.prev_move.nil?
    end

    # check for default moves
    end_pos = []
    end_pos << @pos + Vector[0, 7]
    end_pos << @pos + Vector[0, -7]
    end_pos << @pos + Vector[7, 0]
    end_pos << @pos + Vector[-7, 0]

    end_pos.each do |end_p|
      default_moves = ray_cast(@pos, end_p, on_piece_casted)
      moves.concat(default_moves)
    end

    moves
  end
end
