# frozen_string_literal: true

require_relative 'board'

class Game
  attr_reader :is_playing, :board, :max_win_count, :players

  attr_accessor :turn

  def initialize(board = Board.new(), max_win_count = 3, first_turn = 'x', players = %w[x o])
    @board = board
    @max_win_count = max_win_count
    @turn = first_turn
    @players = players

    @turn_count = 0
    @turn_index = 0
  end

  def start_game
    @is_playing = true

    error = ''

    while is_playing
      system('cls')


      puts board.draw_board

      puts "Error: #{error}" unless error.empty?

      puts "Input #{turn} move:"

      move_input = gets.chomp

      if move_input == 'stop'
        end_game
        return
      end

      # check if int
      next unless move_input.to_i.to_s == move_input

      begin
        error = ''
        pos = place_piece(turn, move_input.to_i)

        check_win?(turn, pos)

        @turn_count += 1
        @turn_index = (@turn_index + 1) % @players.length

        self.turn = players[@turn_index]
      rescue ArgumentError => e
        error = e.to_s
      end

    end
  end

  def place_piece(turn, input)
    board.place_piece_by_index(turn, input)
  end

  def end_game
    @is_playing = false
    puts 'Game Stopped!'
  end

  def check_win?(piece, pos)
    pos_arrays = board.pos_arrays(pos[0], pos[1], max_win_count)

    pos_arrays.each do |pos_array|
      next unless piece_win?(pos_array, piece)

      puts "#{piece} win!".capitalize
      end_game

      return true
    end

    false
  end

  def piece_win?(array, piece, max_count = max_win_count)
    count = 0

    array.each do |a_piece|
      if a_piece == piece
        count += 1
      else
        count = 0
      end

      return true if count >= max_count
    end

    false
  end
end
