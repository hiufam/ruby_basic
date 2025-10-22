# frozen_string_literal: true

test_dictionary_1 = %w[below down go going horn how howdy it i low own part
                       partner sit]
test_str_1 = "Howdy partner, sit down! How's it going?"

def substring(str, dict)
  result = Hash.new(0)
  str_array = str.split(' ')

  str_array.each do |m_str|
    dict.each do |dict_str|
      result[dict_str] += 1 if m_str.include? dict_str
    end
  end

  p result
end

substring(test_str_1, test_dictionary_1)
