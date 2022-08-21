# frozen_string_literal: true

RSpec.describe Deck do
  let(:poker) { build(:poker) }
  let(:deck) { build(:deck, poker:) }

  describe '.new' do
    it 'creates a deck' do
      expect(deck).to be
    end
  end

  describe '#new_regular' do
    let(:deck) { build(:deck, poker:) }

    it 'creates a deck' do
      deck.new_regular
      expect(deck.cards.size).to eq(Deck::TOTAL_CARDS)
    end

    it 'calls shuffle' do
      allow(deck).to receive(:shuffle)
      deck.new_regular
      expect(deck).to have_received(:shuffle)
    end
  end

  describe '#new_aces' do
    let(:deck) { build(:deck, poker:) }

    it 'creates a deck' do
      deck.new_aces
      expect(deck.cards.size).to eq(Deck::TOTAL_CARDS)
    end

    it 'calls shuffle' do
      allow(deck).to receive(:shuffle)
      deck.new_aces
      expect(deck).to have_received(:shuffle)
    end
  end

  describe '#new_jacks' do
    let(:deck) { build(:deck, poker:) }

    it 'creates a deck' do
      deck.new_jacks
      expect(deck.cards.size).to eq(Deck::TOTAL_CARDS)
    end

    it 'calls shuffle' do
      allow(deck).to receive(:shuffle)
      deck.new_jacks
      expect(deck).to have_received(:shuffle)
    end
  end

  describe '#new_aces_jacks' do
    let(:deck) { build(:deck, poker:) }

    it 'creates a deck' do
      deck.new_aces_jacks
      expect(deck.cards.size).to eq(Deck::TOTAL_CARDS)
    end

    it 'calls shuffle' do
      allow(deck).to receive(:shuffle)
      deck.new_aces_jacks
      expect(deck).to have_received(:shuffle)
    end
  end

  describe '#new_sevens' do
    let(:deck) { build(:deck, poker:) }

    it 'creates a deck' do
      deck.new_sevens
      expect(deck.cards.size).to eq(Deck::TOTAL_CARDS)
    end

    it 'calls shuffle' do
      allow(deck).to receive(:shuffle)
      deck.new_sevens
      expect(deck).to have_received(:shuffle)
    end
  end

  describe '#new_eights' do
    let(:deck) { build(:deck, poker:) }

    it 'creates a deck' do
      deck.new_eights
      expect(deck.cards.size).to eq(Deck::TOTAL_CARDS)
    end

    it 'calls shuffle' do
      allow(deck).to receive(:shuffle)
      deck.new_eights
      expect(deck).to have_received(:shuffle)
    end
  end

  describe '#next_card' do
    let(:deck) { build(:deck, :new_regular, poker:) }

    it 'removes the next card' do
      expect { deck.next_card }.to change(deck.cards, :size).by(-1)
    end

    it 'returns a Card' do
      expect(deck.next_card).to be_an_instance_of(Card)
    end
  end
end
