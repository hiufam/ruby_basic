def euclidean_distance(vector1, vector2)
  # Ensure vectors have the same dimension
  raise ArgumentError, 'Vectors must have the same dimension' unless vector1.length == vector2.length

  sum_of_squares = 0
  vector1.each_with_index do |component1, i|
    component2 = vector2[i]
    sum_of_squares += (component1 - component2)**2
  end

  Math.sqrt(sum_of_squares)
end
