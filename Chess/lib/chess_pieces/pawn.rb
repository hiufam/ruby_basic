# frozen_string_literal: true

require 'matrix'
require_relative '../chess_piece'
require_relative './queen'
require_relative './rook'
require_relative './bishop'
require_relative './knight'

# pawn
class Pawn < ChessPiece
  def initialize(chess_board, side)
    super(chess_board, 'pawn', side)
  end

  def promotable?
    return @pos[1].zero? if side == 'black'
    return @pos[1] == 7 if side == 'white'

    false
  end

  def promote(index)
    case index
    when 1
      @chess_board.set_piece(@pos, Queen.new(@chess_board, @side))
    when 2
      @chess_board.set_piece(@pos, Rook.new(@chess_board, @side))
    when 3
      @chess_board.set_piece(@pos, Bishop.new(@chess_board, @side))
    when 4
      @chess_board.set_piece(@pos, Knight.new(@chess_board, @side))
    else
      raise StandardError, 'Piece does not exist'
    end
  end

  def available_moves
    return [] if pos.nil?

    moves = []
    side_factor = @side == 'white' ? 1 : -1

    # check for default moves
    end_pos = @pos + Vector[0, 1 * side_factor]
    end_pos = @pos + Vector[0, 2 * side_factor] if @prev_move.nil?

    default_moves = ray_cast(@pos, end_pos)
    moves.concat(default_moves)

    # check for attack moves
    attack_pos_a = @pos + Vector[1, 1  * side_factor]
    attack_pos_b = @pos + Vector[-1, 1 * side_factor]

    victim_piece_a = @chess_board.get_piece(attack_pos_a) unless @chess_board.out_bound?(attack_pos_a)
    victim_piece_b = @chess_board.get_piece(attack_pos_b) unless @chess_board.out_bound?(attack_pos_b)

    attack_moves_a = ray_cast(@pos, attack_pos_a) if !victim_piece_a.nil? && victim_piece_a.side != @side
    attack_moves_b = ray_cast(@pos, attack_pos_b) if !victim_piece_b.nil? && victim_piece_b.side != @side

    moves.concat(attack_moves_a) unless attack_moves_a.nil?
    moves.concat(attack_moves_b) unless attack_moves_b.nil?

    moves
  end
end
