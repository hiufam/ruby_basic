def fibs_rec(num)
  return 0 if num == 0
  return 1 if num == 1

  fibs_rec(num - 1) + fibs_rec(num - 2)
end

p fibs_rec(8)

def merge_sort(array)
  return array if [1, 0].include?(array.length)

  partition_index = (array.length / 2).round

  array_a = merge_sort(array.slice(0..partition_index - 1))
  array_b = merge_sort(array.slice(partition_index..array.length - 1))

  i_a = 0
  i_b = 0
  result = []

  p array_a
  p array_b

  while i_a < array_a.length && i_b < array_b.length
    if array_a[i_a] < array_b[i_b]
      result << array_a[i_a]
      i_a += 1
    else
      result << array_b[i_b]
      i_b += 1
    end
  end

  result += array_a.slice(i_a..array_a.length - 1) if i_a < array_a.length
  result += array_b.slice(i_b..array_b.length - 1) if i_b < array_b.length

  result
end

p merge_sort([3, 2, 1, 13, 8, 5, 0, 1])
