# frozen_string_literal: true

# Hang
class Hangman
  attr_accessor :secret, :guess

  def make_secret(secret_string)
    @secret = secret_string.split('')
    @guess = Array.new(secret_string.length, nil)
  end

  def take_guess(char)
    @secret.each_with_index do |value, index|
      @guess[index] = value if value == char
    end
  end

  def check_win
    @guess == @secret
  end
end
