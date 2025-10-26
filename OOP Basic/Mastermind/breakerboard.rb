# frozen_string_literal: true

module BegCodes
  R = 'r'
  G = 'g'
  Y = 'y'
  B = 'b'
  M = 'm'
  C = 'c'
end

# Able to choose 4 colors, no blank, dup allowed
class BreakerBoard
  BEGS = [BegCodes::R, BegCodes::G, BegCodes::Y, BegCodes::B, BegCodes::M, BegCodes::C].freeze
  attr_accessor :goal_pegs, :guessed_pegs_list, :hint_pegs_list

  def initialize
    @goal_pegs = []
    @guessed_pegs_list = []
    @hint_pegs_list = []
  end

  # set goal with string with length of 4
  def setup_goal_pegs(goal_pegs)
    @goal_pegs = goal_pegs.split('')
  end

  # guess the pegs with string
  def place_guess(guessed_pegs_string)
    pegs = guessed_pegs_string.split('')

    validate_pegs(pegs)

    hint_pegs = get_hint_pegs(pegs)

    guessed_pegs_list.push(pegs)
    hint_pegs_list.push(hint_pegs)

    { guessed_pegs: pegs, hint_pegs: hint_pegs }
  end

  def validate_pegs(pegs_array)
    raise ArgumentError, 'Number of begs must be equal to 4' if pegs_array.length != 4

    pegs_array.each do |peg|
      raise ArgumentError, 'Beg color does not exist' unless BegCodes.const_defined?(peg.upcase)
    end
  end

  # return hint pegs. check array of pegs
  def get_hint_pegs(guessed_pegs)
    colored_hint_pegs = 0
    blank_hint_pegs = 0
    goal_pegs_colors_hash = Hash.new(0)
    guessed_pegs_colors_hash = Hash.new(0)

    # check for same color and position
    @goal_pegs.each_with_index do |goal_peg, index|
      if goal_peg == guessed_pegs[index]
        colored_hint_pegs += 1
      else
        goal_pegs_colors_hash[goal_peg] += 1
        guessed_pegs_colors_hash[guessed_pegs[index]] += 1
      end
    end

    # check for same color but different position
    goal_pegs_colors_hash.each do |key, value|
      blank_hint_pegs += value if guessed_pegs_colors_hash[key] == value
    end

    hint_pegs = []
    { colored: colored_hint_pegs, blank: blank_hint_pegs }.each do |key, value|
      (0..(value - 1)).each do
        case key
        when :colored
          hint_pegs.push('bl') # black peg
        when :blank
          hint_pegs.push('w') # white peg
        else
          hint_pegs.push(nil)
        end
      end
    end

    hint_pegs
  end
end
