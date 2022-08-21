# frozen_string_literal: true

RSpec.describe Card do
  let(:poker) { build(:poker) }
  let(:card) { build(:card, poker:) }

  describe '.new' do
    it 'creates a card' do
      expect(card).to be
    end

    it 'has a value' do
      expect(card.value).to eq(0)
    end

    it 'has a suit' do
      expect(card.suit).to eq(0)
    end
  end

  describe '#to_s' do
    context 'with regular faces' do
      it 'returns a string value' do
        expect(card.to_s).to eq('🂡')
      end
    end

    context 'with alternate faces' do
      before do
        poker.face_type = 2
      end

      it 'returns a string value' do
        expect(card.to_s).to eq('A♠')
      end
    end
  end

  describe '.faces' do
    it 'returns a five of clubs' do
      expect(described_class.faces[4][3]).to eq('🃕')
    end
  end
end
