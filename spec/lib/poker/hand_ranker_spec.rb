# frozen_string_literal: true

RSpec.describe HandRanker do
  let(:poker) { build(:poker) }
  let(:ranker) { described_class.new(hand) }

  describe '.new' do
    let(:hand) { build(:hand, :unknown, poker:) }

    it 'creates a hand ranker' do
      expect(ranker).to be
      expect(hand.rank).to eq(:unknown)
    end

    context 'with less than 5 cards' do
      let(:hand) { build(:hand, poker:) }

      it 'raises an error' do
        expect { ranker }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#rank_hand' do
    before { ranker }

    context 'with a royal_flush' do
      let(:hand) { build(:hand, :royal_flush, poker:) }

      it 'detects a royal_flush' do
        expect(hand.rank).to eq(:royal_flush)
      end
    end

    context 'with a straight_flush' do
      let(:hand) { build(:hand, :straight_flush, poker:) }

      it 'detects a straight_flush' do
        expect(hand.rank).to eq(:straight_flush)
      end
    end

    context 'with a four_of_a_kind' do
      let(:hand) { build(:hand, :four_of_a_kind, poker:) }

      it 'detects a four_of_a_kind' do
        expect(hand.rank).to eq(:four_of_a_kind)
      end
    end

    context 'with a full_house' do
      let(:hand) { build(:hand, :full_house, poker:) }

      it 'detects a full_house' do
        expect(hand.rank).to eq(:full_house)
      end
    end

    context 'with a flush' do
      let(:hand) { build(:hand, :flush, poker:) }

      it 'detects a flush' do
        expect(hand.rank).to eq(:flush)
      end
    end

    context 'with a straight' do
      let(:hand) { build(:hand, :straight, poker:) }

      it 'detects a straight' do
        expect(hand.rank).to eq(:straight)
      end
    end

    context 'with a three_of_a_kind' do
      let(:hand) { build(:hand, :three_of_a_kind, poker:) }

      it 'detects a three_of_a_kind' do
        expect(hand.rank).to eq(:three_of_a_kind)
      end
    end

    context 'with a two_pair' do
      let(:hand) { build(:hand, :two_pair, poker:) }

      it 'detects :two_pair' do
        expect(hand.rank).to eq(:two_pair)
      end
    end

    context 'with pair of twos and a pair of queens' do
      let(:hand) do
        build(:hand, poker:, cards: [build(:card, :two, :diamonds),
                                     build(:card, :queen, :clubs),
                                     build(:card, :queen, :hearts),
                                     build(:card, :two, :spades),
                                     build(:card, :ten, :hearts)])
      end

      it 'detects :two_pair' do
        expect(hand.rank).to eq(:two_pair)
      end
    end

    context 'with a one_pair' do
      let(:hand) { build(:hand, :one_pair, poker:) }

      it 'detects a one_pair' do
        expect(hand.rank).to eq(:one_pair)
      end
    end

    context 'with two successive values' do
      let(:hand) do
        build(:hand, poker:, cards:
          [
            build(:card, :king, suit: 1),
            build(:card, :queen),
            build(:card, :jack),
            build(:card, :ten),
            build(:card, :two)
          ])
      end

      it 'is not a straight' do
        expect(hand.rank).to eq(:unknown)
      end
    end
  end
end
