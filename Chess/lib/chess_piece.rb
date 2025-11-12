require 'matrix'
require_relative './helper/linear'

class ChessPiece
  attr_accessor :chess_board, :type, :side, :pos, :prev_move

  def initialize(chess_board, type, side)
    @chess_board = chess_board
    @type = type
    @side = side
    @prev_move = nil
    @pos = nil
  end

  def available_moves
    []
  end

  def check_mate?
    moves = available_moves

    return moves.include?(@chess_board.kings[:white].pos) if @side == 'black'
    return moves.include?(@chess_board.kings[:black].pos) if @side == 'white'

    false
  end

  def change_pos(new_pos)
    unless @pos.nil?
      temp_pos = @pos
      @prev_move = temp_pos

      @chess_board.set_piece(temp_pos, nil)
    end
    @pos = new_pos
    @chess_board.set_piece(new_pos, self)
  end

  # cast from start and return maximum number of empty positions, include and/or end
  def ray_cast(start_pos, m_end_pos, on_piece_casted = nil)
    end_pos = m_end_pos

    pos = []
    direction = (end_pos - start_pos).zero? ? Vector[0, 0] : (end_pos - start_pos).normalize

    move_step = Vector[direction[0] / (direction[0].zero? ? 1 : direction[0].abs),
                       direction[1] / (direction[1].zero? ? 1 : direction[1].abs)]

    new_end_pos = nil
    flag_pos = start_pos

    while new_end_pos.nil? && flag_pos != end_pos
      flag_pos += move_step
      break if @chess_board.out_bound?(flag_pos)

      flag_piece = @chess_board.get_piece(flag_pos)
      if !flag_piece.nil?
        new_end_pos = flag_pos

        on_piece_casted&.call(flag_piece)
        start_piece = @chess_board.get_piece(start_pos)
        pos << new_end_pos if start_piece.side != flag_piece.side # add end pos if encount diff side piece
      else
        pos << flag_pos
      end
    end

    pos
  end

  def icon
    chess_icon(@side, @type)
  end

  def chess_icon(side, piece_type)
    white_pieces = {
      king: '♔',
      queen: '♕',
      rook: '♖',
      bishop: '♗',
      knight: '♘',
      pawn: '♙'
    }

    black_pieces = {
      king: '♚',
      queen: '♛',
      rook: '♜',
      bishop: '♝',
      knight: '♞',
      pawn: '♟'
    }

    case side.downcase
    when 'white'
      white_pieces[piece_type.to_sym]
    when 'black'
      black_pieces[piece_type.to_sym]
    else
      raise ArgumentError, "Invalid side '#{side}'. Must be 'white' or 'black'."
    end
  end
end
