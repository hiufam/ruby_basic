# frozen_string_literal: true

stock_prices = [17, 3, 6, 9, 15, 8, 6, 1, 10]

def stock_picker(stock_prices)
  smallest_index = 0
  diff = 0
  pair = [-1, -1]

  stock_prices.each_with_index do |price, index|
    smallest_index = index if price < stock_prices[smallest_index]

    current_diff = stock_prices[index] - stock_prices[smallest_index]
    next unless current_diff > diff

    diff = current_diff
    pair[0] = smallest_index
    pair[1] = index
  end

  p pair
  pair
end

stock_picker(stock_prices)
