# frozen_string_literal: true

# Dic
class Dictionary
  attr_accessor :words

  def initialize
    @words = []
    dic_file = File.open(__dir__ << './dictionary.txt', 'r')

    while (line = dic_file.gets)
      @words << line.chomp
    end

    dic_file.close
  end

  def random_word(min_length = 5, max_length = 12)
    filtered_words = words.select do |word|
      word.length >= min_length && word.length <= max_length
    end

    rand_index = rand(filtered_words.length)
    filtered_words[rand_index]
  end
end
