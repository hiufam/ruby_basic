# frozen_string_literal: true

# dispaly
module Display
  def show_letters(letters_array)
    str = []
    letters_array.each do |letter|
      if letter.nil? # rubocop:disable Style/ConditionalAssignment
        str << '_'
      else
        str << letter
      end
    end

    puts str.join(' ')
  end
end
