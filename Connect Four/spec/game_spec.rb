require_relative '../lib/game'
require_relative '../lib/board'

describe Game do
  subject(:game) { described_class.new(board) }
  let(:board) { instance_double(Board) }

  describe '#start_game' do
    context 'when game game started' do
      before do
        allow(board).to receive(:place_piece)
      end

      it 'it calls game loop' do
        expect(game).to receive(:game_loop).once
        game.start_game
      end
    end
  end
  describe '#get_turn' do
    context 'when player 1 turn is set as first' do
      it 'returns player 1 turn' do
        game.turn = 1
        expect(game.turn).to eq(1)
      end
    end
  end

  describe '#player_input' do
    context 'when player input invalid move' do
      before do
        allow(game).to receive(:gets).and_return('-1')
        allow(board).to receive(:place_piece).and_raise(StandardError, 'Invalid move')
      end

      it 'raises error' do
        game.turn = 1

        expect { game.player_input }.to raise_error(StandardError, 'Invalid move')
      end
    end

    context 'when player with their turn enter input' do
      before do
        allow(board).to receive(:check_win?)
        allow(game).to receive(:gets).and_return('0')
      end

      it 'calls place piece once' do
        game.turn = 1

        expect(board).to receive(:place_piece).with('o', 0).once
        game.player_input
      end
    end

    context 'after player 1 make their move' do
      before do
        allow(board).to receive(:place_piece)
        allow(board).to receive(:check_win?)
        allow(game).to receive(:gets).and_return('0')
      end

      it 'returns player 2 turn' do
        game.turn = 1

        expect { game.player_input }.to change { game.turn }.to(2)
      end
    end

    context 'if players enter "q" into input' do
      before do
        allow(game).to receive(:gets).and_return('q')
      end

      it 'calls stop_game' do
        expect(game).to receive(:stop_game).once
        expect(game.is_playing).to be false
        game.player_input
      end
    end

    context 'when players takes turn and stop only after 4 turns' do
      before do
        allow(game).to receive(:gets).and_return('0', '0', '0', '0', 'q')
        allow(board).to receive(:check_win?)
      end

      it 'calls place_piece 4 times between x and o interchangably and stop game after 4 times' do
        expect(board).to receive(:place_piece).with('o', 0).twice
        expect(board).to receive(:place_piece).with('x', 0).twice
        expect(game.is_playing).to be false

        game.start_game
      end
    end

    context 'when a player makes winning move' do
      before do
        allow(game).to receive(:gets).and_return('0', '0', '1', '0', '2', '0', '3') # if not stop loop, repeat the process
        allow(board).to receive(:check_win?).and_return(false, false, false, false, false, false, true)
      end

      it 'calls stop_game' do
        expect(board).to receive(:place_piece).with('o', 0).once
        expect(board).to receive(:place_piece).with('o', 1).once
        expect(board).to receive(:place_piece).with('o', 2).once
        expect(board).to receive(:place_piece).with('o', 3).once
        expect(board).to receive(:place_piece).with('x', 0).exactly(3).times

        expect(game).to receive(:stop_game).once

        7.times do
          game.player_input
        end
      end
    end
  end
end
