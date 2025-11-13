require 'matrix'
require_relative '../lib/chess_board'

describe ChessBoard do
  subject(:chess_board) { described_class.new }

  describe '#pieces' do
    context 'after initializing chess board' do
      it 'return 32 pieces in total' do
        pieces_count = chess_board.pieces[:black].length + chess_board.pieces[:white].length
        max_count = 32

        expect(pieces_count).to eq(max_count)
      end
    end
  end

  describe '#validate_piece' do
    context 'when pick a coordinate with no existing piece' do
      it 'raises error "Piece does not exist"' do
        expect do
          nil_piece_pos = '3a'
          turn = 'white'

          chess_board.validate_piece(nil_piece_pos, turn)
        end.to raise_error(StandardError, 'Piece does not exist')
      end
    end

    context 'when pick opponent piece during turn' do
      it 'raises error "Cannot pick opponent piece"' do
        expect do
          nil_piece_pos = '1a'
          turn = 'black'

          chess_board.validate_piece(nil_piece_pos, turn)
        end.to raise_error(StandardError, 'Cannot pick opponent piece')
      end
    end
  end

  describe '#validate_move' do
    context 'when pick a coordinate that does not exist in piece move set' do
      context 'when rook has no available move, and player try to move piece to 2A' do
        let(:rook) { instance_double(Rook) }

        before do
          allow(rook).to receive(:available_moves).and_return([])
        end
        it 'raises error "Move is unavailable"' do
          nil_piece_pos = '1a'
          expect { chess_board.validate_move(nil_piece_pos, rook) }.to raise_error(StandardError, 'Move is unavailable')
        end
      end
    end
  end
end
