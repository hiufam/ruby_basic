require_relative '../lib/board'

describe Board do
  subject(:board) { described_class.new }

  describe '#place_piece' do
    context 'when player place a piece at 7th column' do
      it 'places the piece at the bottom of the 7th column' do
        result_pieces_map = [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, 'o']
        ]
        column_index = 6
        board.place_piece('o', column_index)

        expect(board.pieces_map).to eql(result_pieces_map)
      end
    end

    context 'when player place a piece twice at the 7th column' do
      it 'places both piece on top of one another' do
        result_pieces_map = [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, 'o'],
          [nil, nil, nil, nil, nil, nil, 'o']
        ]
        column_index = 6
        next_column_index = 6
        board.place_piece('o', column_index)
        board.place_piece('o', next_column_index)

        expect(board.pieces_map).to eql(result_pieces_map)
      end
    end
  end

  describe '#validate_move' do
    context 'when player places outside of board' do
      it 'raises error' do
        column_index = 7
        expect { board.validate_move(column_index) }.to raise_error(StandardError, 'Invalid move')
      end
    end

    context 'when player places piece in a full column' do
      it 'raises error' do
        6.times do
          board.place_piece('o', 6)
        end

        column_index = 6
        expect { board.validate_move(column_index) }.to raise_error(StandardError, 'Column is full')
      end
    end
  end

  describe '#check_win?' do
    context 'when player places 4 pieces that aligned with each other' do
      it 'returns true' do
        3.times do
          board.place_piece('o', 4)
        end

        lastest_pos = board.place_piece('o', 4)
        win = board.check_win?('o', lastest_pos)
        expect(win).to be true
      end
    end

    context 'when player places 4 pieces that are not aligned with each other' do
      it 'returns false' do
        3.times do
          board.place_piece('o', 4)
        end

        lastest_pos = board.place_piece('o', 3)
        win = board.check_win?('o', lastest_pos)
        expect(win).to be false
      end
    end
  end
end
