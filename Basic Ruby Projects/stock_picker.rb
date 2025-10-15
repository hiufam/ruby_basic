stock_prices = [17,3,6,9,15,8,6,1,10]

def stock_picker(stock_prices)
  smallest_index = 0
  diff = 0;
  pair = [-1, -1]
  
  stock_prices.each_with_index  do |price, index|
    if price < stock_prices[smallest_index]
      smallest_index = index
    end
    
    current_diff = stock_prices[index] - stock_prices[smallest_index]
    if (current_diff > diff)
      diff = current_diff
      pair[0] = smallest_index
      pair[1] = index
    end
  end 

  p pair
  pair
end

stock_picker(stock_prices)
