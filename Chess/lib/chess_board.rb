require_relative './chess_pieces/pawn'
require_relative './chess_pieces/rook'
require_relative './chess_pieces/bishop'
require_relative './chess_pieces/queen'
require_relative './chess_pieces/knight'
require_relative './chess_pieces/king'

class ChessBoard
  attr_accessor :pieces_map, :kings

  def pieces
    pieces_arr = { black: [], white: [] }
    @pieces_map.each do |row|
      row.each do |piece|
        pieces_arr[piece.side.to_sym] << piece unless piece.nil?
      end
    end

    pieces_arr
  end

  def initialize
    @pieces_map = Array.new(8) { Array.new(8) }

    w_king = King.new(self, 'white')
    w_rook_l = Rook.new(self, 'white')
    w_rook_r = Rook.new(self, 'white')
    w_bishop_l = Bishop.new(self, 'white')
    w_bishop_r = Bishop.new(self, 'white')
    w_knight_l = Knight.new(self, 'white')
    w_knight_r = Knight.new(self, 'white')
    w_queen = Queen.new(self, 'white')

    b_king = King.new(self, 'black')
    b_rook_l = Rook.new(self, 'black')
    b_rook_r = Rook.new(self, 'black')
    b_bishop_l = Bishop.new(self, 'black')
    b_bishop_r = Bishop.new(self, 'black')
    b_knight_l = Knight.new(self, 'black')
    b_knight_r = Knight.new(self, 'black')
    b_queen = Queen.new(self, 'black')

    @kings = { white: w_king, black: b_king }

    # add pawn pieces
    (0..7).each do |i|
      set_piece(Vector[i, 1], Pawn.new(self, 'white'))
      set_piece(Vector[i, 6], Pawn.new(self, 'black'))
    end

    # add special pieces
    set_piece(Vector[0, 0], w_rook_l)
    set_piece(Vector[7, 0], w_rook_r)
    set_piece(Vector[1, 0], w_knight_l)
    set_piece(Vector[6, 0], w_knight_r)
    set_piece(Vector[2, 0], w_bishop_l)
    set_piece(Vector[5, 0], w_bishop_r)
    set_piece(Vector[3, 0], w_queen)
    set_piece(Vector[4, 0], w_king)

    set_piece(Vector[0, 7], b_rook_l)
    set_piece(Vector[7, 7], b_rook_r)
    set_piece(Vector[1, 7], b_knight_l)
    set_piece(Vector[6, 7], b_knight_r)
    set_piece(Vector[2, 7], b_bishop_l)
    set_piece(Vector[5, 7], b_bishop_r)
    set_piece(Vector[3, 7], b_queen)
    set_piece(Vector[4, 7], b_king)
  end

  # using Cartesian coordinate
  def get_piece(pos)
    x = pos[0]
    y = pos[1]

    pieces_map[7 - y][x]
  end

  def set_piece(pos, piece)
    x = pos[0]
    y = pos[1]

    pieces_map[7 - y][x] = piece
    piece.pos = pos unless piece.nil?
  end

  def make_move(new_pos, piece)
    piece&.change_pos(new_pos)
  end

  def out_bound?(pos)
    pos[0].negative? || pos[1].negative? || pos[0] > 7 || pos[1] > 7
  end

  def get_piece_by_coord_str(coord_str)
    get_piece(interprete_move(coord_str))
  end

  def interprete_move(coord_str)
    alphabetic = 'ABCDEFGH'
    numeric = '12345678'

    a = coord_str[0]
    b = coord_str[1]

    return Vector[alphabetic.index(a.upcase), numeric.index(b)] if alphabetic.include?(a.upcase) && numeric.include?(b)
    return Vector[alphabetic.index(b.upcase), numeric.index(a)] if alphabetic.include?(b.upcase) && numeric.include?(a)

    nil
  end

  def validate_piece(coord, side)
    raise StandardError, 'Move must contain 1 letter and 1 number' if coord.length != 2

    alphabetic = 'ABCDEFGH'
    numeric = '12345678'

    a = coord[0]
    b = coord[1]

    unless (alphabetic.include?(a.upcase) && numeric.include?(b)) || (alphabetic.include?(b.upcase) && numeric.include?(a))
      raise StandardError, 'Invalid move'
    end

    piece = get_piece(interprete_move(coord))

    raise StandardError, 'Piece does not exist' if piece.nil?
    raise StandardError, 'Cannot pick opponent piece' if piece.side != side
  end

  def validate_move(coord, piece)
    raise StandardError, 'Move must contain 1 letter and 1 number' if coord.length != 2

    alphabetic = 'ABCDEFGH'
    numeric = '12345678'

    a = coord[0]
    b = coord[1]

    unless (alphabetic.include?(a.upcase) && numeric.include?(b)) || (alphabetic.include?(b.upcase) && numeric.include?(a))
      raise StandardError, 'Invalid move'
    end

    available_moves = piece.available_moves
    raise StandardError, 'Move is unavailable' unless available_moves.include?(interprete_move(coord))
  end
end
