# frozen_string_literal: true

require 'yaml'

require_relative 'dictionary'
require_relative 'hangman'
require_relative 'display'

# game
class Game
  include Display

  attr_accessor :is_playing, :hangman, :dictionary, :is_new_game, :save_data, :mode

  def initialize
    @dictionary = Dictionary.new
    @hangman = Hangman.new
    @is_new_game = true
    @save_data = {
      guess: [],
      secret: [],
      length: 0
    }
    @mode = ''
  end

  def start_game
    @is_playing = true
    game_loop
  end

  def stop_game
    puts 'Game stopped!'
    @is_playing = false
  end

  def get_saved_game(file_name)
    yaml_file = __dir__ << "./saves/#{file_name}.yml"

    data = YAML.load_file(yaml_file)
    @hangman.secret = data[:secret]
    @hangman.guess = data[:guess]
    @mode = ''
  end

  def save_game(file_name = 'save_file')
    @save_data[:guess] = @hangman.guess
    @save_data[:secret] = @hangman.secret
    @save_data[:length] = @hangman.guess.length

    file = File.join(File.dirname(__FILE__), "./saves/#{file_name}.yml")
    File.open(file, 'w') { |f| f.puts YAML.dump(@save_data) }

    @mode = ''
  end

  def game_loop
    while @is_playing

      if @is_new_game
        @hangman.make_secret(@dictionary.random_word)
        @is_new_game = false
      end

      system('cls')

      if @mode == 'saved_files'

        p Dir.entries(File.join(__dir__, 'saves'))

        puts 'Get saved file: (options: "quit")'

        input = gets.chomp

        @mode = '' if input == 'quit'

        get_saved_game(input)

      elsif @mode == 'save'
        puts 'Save file name: (options: "quit")'

        input = gets.chomp

        @mode = '' if input == 'quit'

        save_game(input)
      else
        show_letters(@hangman.guess)

        puts 'Enter letter: (options: "save"/"quit"/"saved_files")'

        input = gets.chomp

        stop_game if input == 'quit'
        @mode = 'save' if input == 'save'
        @mode = 'saved_files' if input == 'saved_files'

        @hangman.take_guess(input.to_s)
      end

    end
  end
end
