# frozen_string_literal: true

require_relative 'player'

# Computer
class Computer < Player
  attr_accessor :guesses_count, :initial_guesses, :initialize_guess, :correct_colors_pegs_list, :naive_guess_memory

  def initialize(game)
    super(game)
    @guesses_count = 0
    @initial_guesses = []
    @initialize_guess = false
    @correct_colors_pegs_list = []
  end

  def make_guess(type)
    puts 'Computer is guessing...'

    sleep(0.5)

    guess = ''
    guess = make_random_guess if type == 'random'

    if type == 'naive'
      initialize_naive_guess if @initialize_guess == false
      guess = make_naive_guess
    end

    @guesses_count += 1

    guess
  end

  def make_random_guess
    rand_indexes = 4.times.map { rand(0..(BreakerBoard::BEGS.length - 1)) }
    goal_str = ''

    rand_indexes.each do |index|
      goal_str += BreakerBoard::BEGS[index]
    end

    goal_str
  end

  def initialize_naive_guess
    (0..(BreakerBoard::BEGS.length - 1)).each do |beg_index|
      @initial_guesses.push(4.times.map { BreakerBoard::BEGS[beg_index] }.join(''))
    end

    @initialize_guess = true
    @naive_guess_memory = {
      guess_index: 0,
      guess_color_index: 0,
      correct_guess: []
    }
  end

  def make_naive_guess
    guessed_pegs_list = @game.breaker_board.guessed_pegs_list
    hint_pegs_list = @game.breaker_board.hint_pegs_list
    guess = ''

    # guess all colors first
    if @guesses_count < @initial_guesses.length
      guess = @initial_guesses[@guesses_count]

    elsif @guesses_count == @initial_guesses.length
      # add em colors to the guess
      guessed_pegs_list.each_with_index do |guessed_pegs, index|
        guess += hint_pegs_list[index].length.times.map { guessed_pegs[0] }.join('')
      end

      @correct_colors_pegs_list = guess.split('')
      @naive_guess_memory[:correct_guess] = @correct_colors_pegs_list.dup

      guess
    else # assume more than 2 guesses have been made
      prev_pegs_guessed = guessed_pegs_list[@guesses_count - 1].join('')

      prev_prev_colored_pegs = hint_pegs_list[@guesses_count - 2].count('bl')
      prev_colored_pegs = hint_pegs_list[@guesses_count - 1].count('bl')

      # correct guess
      if prev_colored_pegs > prev_prev_colored_pegs

        # correct guess -> remove correct color from array
        @correct_colors_pegs_list.delete_at(@naive_guess_memory[:guess_color_index])

        # reset guess color index and move onto next slot in guess
        @naive_guess_memory[:guess_index] += 1
        @naive_guess_memory[:guess_color_index] = 0

      # correct previous guess
      elsif prev_colored_pegs < prev_prev_colored_pegs

        # correct guess -> remove correct color from array
        @correct_colors_pegs_list.delete_at(@naive_guess_memory[:guess_color_index])

        # reset guess color index and move onto next slot in guess
        @naive_guess_memory[:guess_index] += 1
        @naive_guess_memory[:guess_color_index] = 0

      # incorrect guess
      else
        @naive_guess_memory[:correct_guess][@naive_guess_memory[:guess_index]] =
          @correct_colors_pegs_list[@naive_guess_memory[:guess_color_index]]

        # get the next color in correct colors peg_list
        if @naive_guess_memory[:guess_color_index] < @correct_colors_pegs_list.length
          @naive_guess_memory[:guess_color_index] += 1
        end
      end

      guess = prev_pegs_guessed
    end

    guess
  end

  def make_goal
    system('cls')

    puts 'Computer is generating goal pegs...'

    sleep(1)

    rand_indexes = 4.times.map { rand(0..(BreakerBoard::BEGS.length - 1)) }
    goal_str = ''

    rand_indexes.each do |index|
      goal_str += BreakerBoard::BEGS[index]
    end

    goal_str
  end

  def swap_peg(pegs, index_1, index_2) # rubocop:disable Naming/VariableNumber
    pegs_array = pegs.split('')
    pegs_array[index_1], pegs_array[index_2] = pegs_array[index_2], pegs_array[index_1]
    pegs_array.join('')
  end
end
