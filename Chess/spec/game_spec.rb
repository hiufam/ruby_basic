require_relative '../lib/game'
require_relative '../lib/chess_board'

describe Game do
  subject(:game) { described_class.new(board) }
  let(:board) { instance_double(ChessBoard, pieces_map: []) }

  describe '#check_win' do
    context 'when either opponents lose their king' do
      let(:w_king) { instance_double(King) }
      let(:b_king) { instance_double(King) }

      before do
        allow(board).to receive(:pieces).and_return({ white: [], black: [b_king] })
        allow(board).to receive(:kings).and_return({ white: w_king, black: [b_king] })
      end

      context 'if white loses their king' do
        it 'calls stop game once' do
          expect(game).to receive(:stop_game).once
          game.check_win
        end
      end
    end
  end

  describe '#load_game' do
    context 'if save file does not exist' do
      before do
        allow(File).to receive(:exist?).and_return(false)
      end
      it 'raises error "Save file does not exist' do
        expect { game.load_game }.to raise_error(StandardError, 'Save file does not exist')
      end
    end

    context 'if save file does exist' do
      before do
        allow(File).to receive(:exist?).and_return(true)
        allow(YAML).to receive(:safe_load).and_return({ pieces_map: [] })
        allow(board).to receive(:pieces_map=)
        allow(board).to receive(:kings=)
        allow(board).to receive(:pieces).and_return({ black: [], white: [] })
      end
      it 'calls File read once' do
        expect(File).to receive(:read).once
        game.load_game
      end
    end
  end
end
