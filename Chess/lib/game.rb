require 'yaml'
require_relative './display'
require_relative './chess_board'

class Game
  include Display

  attr_accessor :is_playing, :board, :turn, :chose_piece, :chose_move, :promotable_piece, :promoting_piece,
                :saving_game, :getting_saved_game

  def initialize(board = ChessBoard.new)
    @board = board
    @turn = 0
    @chose_piece = nil
    @chose_move = nil
    @promotable_piece = nil
    @promoting_piece = false
    @saving_game = false
    @getting_saved_game = false
  end

  def start_game
    @is_playing = true
    game_loop
  end

  def stop_game
    @is_playing = false
  end

  def game_loop
    error = ''
    while @is_playing
      # system('cls') # clear terminal

      display_board(@board.pieces_map)
      display_error(error) unless error.empty?
      display_turn(@turn.even? ? 'white' : 'black')
      display_king_checked(@board.kings[:black]) if @board.kings[:black].checked?
      display_king_checked(@board.kings[:white]) if @board.kings[:white].checked?
      display_hint(@promotable_piece)
      display_promote_pieces if !@promotable_piece.nil? && @promoting_piece == true
      display_current_choice(@chose_piece, @chose_move) if !chose_piece.nil? && !chose_move.nil?
      display_choose_piece if chose_piece.nil?
      display_choose_move(@chose_piece) if !chose_piece.nil? && chose_move.nil?
      display_winner('black') unless @board.pieces[:white].include?(@board.kings[:white])
      display_winner('white') unless @board.pieces[:black].include?(@board.kings[:black])

      check_win

      begin
        player_input
        error = ''
      rescue StandardError => e
        error = e.message
      end
    end
  end

  def reset_state
    @chose_piece = nil
    @chose_move = nil
    @promotable_piece = nil
    @promoting_piece = false
  end

  def check_win
    stop_game unless @board.pieces[:white].include?(@board.kings[:white])
    stop_game unless @board.pieces[:black].include?(@board.kings[:black])
    nil
  end

  def get_saved_file(file_name = 'save_file')
    dir_name = File.join(__dir__, '/saves')
    yaml_file = dir_name << "/#{file_name}.yml"

    yaml_content = File.read(yaml_file)
    data = YAML.safe_load(yaml_content,
                          permitted_classes: [Symbol, Rook, ChessBoard, King, Queen, Bishop, Knight, Pawn, Vector], aliases: true) # rubocop:disable Layout/LineLength

    @board.pieces_map = data[:pieces_map]
    b_king = @board.pieces[:black].select { |piece| piece.type == 'king' }[0]
    w_king = @board.pieces[:white].select { |piece| piece.type == 'king' }[0]

    @board.kings = { white: w_king, black: b_king }

    @getting_saved_game = false
  end

  def save_game(file_name = 'save_file')
    dir_name = File.join(File.dirname(__FILE__), './saves')

    Dir.mkdir(dir_name) unless File.exist?(dir_name) # make dir if not exist

    file = File.join(dir_name, "./#{file_name}.yml")
    File.open(file, 'w') { |f| f.puts YAML.dump({ pieces_map: @board.pieces_map }) } # raw dog dumping

    @saving_game = false
  end

  def player_input
    input = gets.chomp

    stop_game if input.to_s == 'q'

    if input.to_s == 'rm'
      reset_state
      return
    end

    if input.to_s == 'sv'
      @saving_game = true
      save_game
      return
    end

    if input.to_s == 'gg'
      get_saved_file
      @getting_saved_game = true
      return
    end

    if input.to_s == 'p' && @promoting_piece == false && !@promotable_piece.nil?
      @promoting_piece = true
      return
    end

    if !@promotable_piece.nil? && @promoting_piece
      promote_index = input.to_i
      @promotable_piece.promote(promote_index)
      @turn += 1
      reset_state
      return
    end

    if !@chose_move.nil? && !@chose_piece.nil? && input.to_s == 'y'
      @board.make_move(@board.interprete_move(@chose_move), @chose_piece)
      reset_state
      @turn += 1
      return
    end

    if @chose_piece.nil?
      @board.validate_piece(input, @turn.even? ? 'white' : 'black')
      @chose_piece = @board.get_piece_by_coord_str(input)

      @promotable_piece = @chose_piece if @chose_piece.type == 'pawn' && @chose_piece.promotable?
      return
    end

    if @chose_move.nil? && !@chose_piece.nil? # rubocop:disable Style/GuardClause
      @board.validate_move(input, @chose_piece)
      @chose_move = input
      nil
    end
  end
end
