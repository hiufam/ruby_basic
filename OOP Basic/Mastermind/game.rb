# frozen_string_literal: true

require 'colorize'
require_relative 'breakerboard'
require_relative 'display'
require_relative 'player'
require_relative 'computer'

# Game
class Game
  include Display
  attr_accessor :breaker_board, :is_playing, :player, :cpu, :guesser, :creator, :role_assigned

  def initialize
    @breaker_board = BreakerBoard.new
    @is_playing = true
    @role_assigned = false
  end

  def start_game
    @is_playing = true
    @player = Player.new(self)
    @cpu = Computer.new(self)

    assign_role_notification
    game_loop
  end

  def stop_game
    @is_playing = false
    puts 'Game stopped!'
  end

  def assign_role_notification
    until role_assigned
      system('cls')

      puts 'Is Guesser: (yes/no)'

      role = gets.chomp

      assign_players(@player, @cpu) if role == 'yes'
      assign_players(@cpu, @player) if role == 'no'
    end
  end

  def make_goal_notification
    goal_pegs = ''
    goal_pegs = @player.make_goal if @player.role == 'creator'
    goal_pegs = @cpu.make_goal if @cpu.role == 'creator'

    goal_pegs
  end

  def make_guess_notification
    guess = ''
    guess = @cpu.make_guess('naive') if @cpu.role == 'guesser'
    guess = @player.make_guess if @player.role == 'guesser'

    guess
  end

  def assign_players(guesser, creator)
    @guesser = guesser
    guesser.role = 'guesser'

    @creator = creator
    creator.role = 'creator'

    @role_assigned = true
  end

  def game_loop
    error = ''
    make_goal(make_goal_notification)

    while is_playing
      system('cls')

      display_result

      puts "Error: #{error}" unless error.empty?

      input = make_guess_notification

      if input == 'stop'
        stop_game
        return
      end

      begin
        error = ''
        result = make_guess(input) unless input.empty?

        if check_win?(result[:hint_pegs])
          puts 'Guessed Correct!'
          stop_game
        end
      rescue ArgumentError => e
        error = e.to_s
      end

    end
  end

  def check_win?(hint_pegs)
    color_hints_count = 0
    hint_pegs.each do |hint_peg|
      color_hints_count += 1 if hint_peg == 'bl'
    end

    color_hints_count == 4
  end

  def make_goal(goal_string)
    @breaker_board.setup_goal_pegs(goal_string)
  end

  def make_guess(guess_string)
    @breaker_board.place_guess(guess_string)
  end

  def display_result
    @breaker_board.guessed_pegs_list.each_with_index do |pegs, index|
      hint_pegs = @breaker_board.hint_pegs_list[index]
      show(pegs, hint_pegs)
    end
  end
end
