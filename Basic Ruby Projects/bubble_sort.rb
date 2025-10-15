def bubble_sort(arr)
  if arr.length < 2 
    p arr
    arr
  end

  nums_arr = arr.dup
  end_index = nums_arr.length() - 1

  while end_index > 0
    for i in 0..(end_index - 1)
      if (nums_arr[i] > nums_arr[i + 1])
        swap(i, i + 1, nums_arr)
      end
    end

    end_index -= 1
  end

  p nums_arr
  p arr
  nums_arr
end

def swap(index_1, index_2, array)
  array[index_1], array[index_2] = array[index_2], array[index_1]
end

bubble_sort([4,3,78,2,0,2])
