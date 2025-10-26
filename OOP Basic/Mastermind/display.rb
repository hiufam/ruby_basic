# frozen_string_literal: true

require 'colorize'
require_relative 'breakerboard'

module BegColorCodes
  R = :red
  G = :green
  Y = :yellow
  B = :blue
  M = :magenta
  C = :cyan
  W = :white
  BL = :black
end

# Display
module Display
  def show(guessed_pegs_array, hint_pegs_array)
    puts "#{show_pegs(guessed_pegs_array)} - #{show_hint_pegs(hint_pegs_array)}"
  end

  def show_pegs(pegs_array)
    str = ''
    pegs_array.each do |peg|
      str += "#{'■'.colorize(BegColorCodes.const_get(peg.upcase))} "
    end

    str.strip
  end

  def show_hint_pegs(hint_pegs_array)
    "[#{show_pegs(hint_pegs_array)}]"
  end
end
