class Calculator
  def add(*args)
    result = 0
    args.each do |arg|
      result += arg
    end

    result
  end

  def substract(a, b)
    a - b
  end

  def multiply(a, b)
    a * b
  end

  def divide(a, b)
    a / b.to_f
  end
end
