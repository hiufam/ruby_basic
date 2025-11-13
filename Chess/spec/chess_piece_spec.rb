require 'matrix'
require_relative '../lib/chess_piece'
require_relative '../lib/chess_board'

describe ChessPiece do
  subject(:chess_piece) { described_class.new(chess_board, 'rook', 'white') }
  let(:chess_board) { instance_double(ChessBoard) }

  describe '#check_mate?' do
    context 'if opponent king position is included in piece available moves' do
      context 'if black king is on the same lane as white rook' do
        let(:black_king) { instance_double(King) }

        before do
          allow(chess_piece).to receive(:available_moves).and_return([Vector[0, 1], Vector[0, 2]])
          allow(chess_board).to receive(:kings).and_return({ black: black_king })
          allow(black_king).to receive(:pos).and_return(Vector[0, 2])
        end

        it 'returns true' do
          check_mate = chess_piece.check_mate?
          expect(check_mate).to be true
        end
      end
    end
  end

  describe '#ray_cast' do
    context 'when a piece cast a ray in a horizontal direction' do
      context 'when white rook at position [0, 2] cast ray to white king at [0, 5]' do
        let(:white_king) { instance_double(King) }

        before do
          allow(chess_board).to receive(:out_bound?).and_return(false)
          allow(white_king).to receive(:side).and_return('white')
          allow(chess_board).to receive(:get_piece).and_return(nil, nil, white_king)
        end

        it 'returns list of moves [[0, 3], [0, 4]] excluding castling' do
          moves = chess_piece.ray_cast(Vector[0, 2], Vector[0, 5])

          expect(moves).to eq([Vector[0, 3], Vector[0, 4]])
        end
      end
    end
  end
end
