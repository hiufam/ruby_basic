def alphabetic?(char)
  char.match?(/[A-Za-z]/)
end

def caesar_cipher(string, shift = 1)
  alphabet = 'abcdefghijklmnopqrstuvwxyz'

  result = []
  char_arr = string.split('')
  char_arr.each do |char|
    is_upcase = char.upcase == char

    if alphabetic?(char)
      index = alphabet.index(char.downcase)
      shifted_index = (index + shift) % 26

      result << (is_upcase ? alphabet[shifted_index].upcase : alphabet[shifted_index])
    else
      result << char
    end
  end

  result.join('')
end
