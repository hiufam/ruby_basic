require_relative '../Tic Tac Toe/board'
require_relative '../Tic Tac Toe/game'

describe Game do
  context 'during tic tac toe where win requirement is alignment of 5 pieces in either horizontal, diagonal, or vertical' do
    subject(:game) { described_class.new }

    context 'when placed 5 pieces next to each other horizontally' do
      before do
      end

      it 'returns win for that piece' do
        game.place_piece('o', 0)
        game.place_piece('o', 1)
        game.place_piece('o', 2)
        game.place_piece('o', 3)
        game.place_piece('o', 4)

        is_win = game.check_win?('o', 4)

        expect(is_win).to be(true)
      end
    end
  end

  describe '#place_piece' do
    subject(:game) { described_class.new(board) }
    let(:board) { instance_double(Board) }

    context 'when move is placed' do
      before do
        allow(board).to receive(:place_piece_by_index)
      end

      it 'calls place piece by index once' do
        expect(board).to receive(:place_piece_by_index).once
        game.place_piece('o', 1)
      end
    end

    context 'when place piece outside of board' do
      before do
        allow(board).to receive(:place_piece_by_index).and_raise(ArgumentError)
      end

      it 'print error' do
        expect { game.place_piece('o', -1) }.to raise_error(ArgumentError) # This is wrong
      end
    end
  end
end
