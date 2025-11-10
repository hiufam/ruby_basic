require_relative './board'

class Game
  attr_accessor :is_playing, :board, :turn

  def initialize(board)
    @is_playing = false
    @board = board
    @turn = 1
  end

  def start_game
    @is_playing = true
    game_loop
  end

  def game_loop
    while @is_playing
      # do smth
      player_input
      p board.pieces_map
    end
  end

  def stop_game
    @is_playing = false
  end

  def player_input
    input = gets.chomp

    if input == 'q'
      stop_game
      return
    end

    return if input.nil?

    win = nil
    if @turn == 1
      pos = @board.place_piece('o', input.to_i)
      win = @board.check_win?('o', pos) ? 'o' : nil
      @turn = 2
    else
      pos = @board.place_piece('x', input.to_i)
      win = @board.check_win?('x', pos) ? 'x' : nil
      @turn = 1
    end

    return if win.nil?

    stop_game
  end
end
