require_relative '../caeser_cipher'

describe 'Caeser Cipher' do
  describe '#caeser_cipher' do
    context 'when caeser cipher shift is 5' do
      let(:shift) { 5 }
      let(:text) { 'What a string!' }

      it 'encode string "Hello World!" into "Bmfy f xywnsl!"' do
        expect(caesar_cipher(text, shift)).to eq('Bmfy f xywnsl!')
      end
    end
  end
end
