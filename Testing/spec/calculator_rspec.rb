require './libs/calculator' #=> add this

describe Calculator do
  describe '#add' do
    it 'returns the sum of two numbers' do
      calculator = Calculator.new
      expect(calculator.add(5, 2)).to eql(7)
    end

    it 'returns the sum of more than two numbers' do
      calculator = Calculator.new
      expect(calculator.add(2, 5, 7)).to eql(14)
    end
  end

  describe '#subtract' do
    it 'return the substraction of two numbers' do
      calculator = Calculator.new
      expect(calculator.substract(5, 2)).to eql(3)
    end
  end

  describe '#multiply' do
    it 'return the multiplication of two numbers' do
      calculator = Calculator.new
      expect(calculator.multiply(5, 2)).to eql(10)
    end
  end

  describe '#divide' do
    it 'return the division of two numbers' do
      calculator = Calculator.new
      expect(calculator.divide(5, 2)).to eql(2.5)
    end
  end
end
