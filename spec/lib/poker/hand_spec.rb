# frozen_string_literal: true

RSpec.describe Hand do
  let(:ace) { build(:card, :ace, poker:) }
  let(:three) { build(:card, :three, poker:) }
  let(:five) { build(:card, :five, poker:) }
  let(:seven) { build(:card, :seven, poker:) }
  let(:ten) { build(:card, :ten, poker:) }
  let(:poker) { build(:poker, :with_deck) }
  let(:hand) { build(:hand, poker:) }

  describe '.new' do
    it 'creates a hand' do
      expect(hand).to be
    end

    it 'has a bet' do
      expect(hand.bet).to eq(500)
    end
  end

  describe '#deal_card' do
    it 'adds a card to the hand' do
      expect do
        hand.deal_card
      end.to change { hand.cards.size }.by(1)
    end
  end

  describe '#pay' do
    context 'when a winning hand is unpaid' do
      let(:hand) { build(:hand, :one_pair, poker:) }

      it 'adds the result to the poker money' do
        expect do
          hand.pay
        end.to change(poker, :money).by(500)
      end
    end

    context 'when a losing hand is unpaid' do
      let(:hand) { build(:hand, :unknown, poker:) }

      it 'subtracts the result from the poker money' do
        expect do
          hand.pay
        end.to change(poker, :money).by(-500)
      end
    end

    context 'when hand is already paid' do
      before { hand.result = 500 }

      it 'ignores a hand with a result' do
        expect do
          hand.pay
        end.not_to change(hand, :result)
      end
    end
  end

  describe '#draw' do
    before do
      hand.cards << ace << ace << ten << ten << ten
      poker.hand = hand
    end

    it 'draws the hand' do
      expected = " 🂡 🂡 🂪 🂪 🂪  $5.00  \n ⇑         \n\n"
      expect(hand.draw).to eq(expected)
    end

    context 'with face type 2' do
      before { poker.face_type = 2 }

      it 'draws the hand' do
        expected = " A♠ A♠ T♠ T♠ T♠  $5.00  \n ⇑              \n\n"
        expect(hand.draw).to eq(expected)
      end
    end

    context 'with a positive result' do
      before { hand.result = 500 }

      it 'draws the hand' do
        expected = " 🂡 🂡 🂪 🂪 🂪  +$5.00  \n ⇑         \n\n"
        expect(hand.draw).to eq(expected)
      end
    end

    context 'with a negative result' do
      before { hand.result = -500 }

      it 'draws the hand' do
        expected = " 🂡 🂡 🂪 🂪 🂪  -$5.00  \n ⇑         \n\n"
        expect(hand.draw).to eq(expected)
      end
    end

    context 'with a discarded card' do
      before { hand.discards << 2 }

      it 'draws the hand' do
        expected = " 🂡 🂡 🂠 🂪 🂪  $5.00  \n ⇑         \n\n"
        expect(hand.draw).to eq(expected)
      end
    end

    context 'with a rank' do
      before { hand.rank = :full_house }

      it 'draws the hand' do
        expected = " 🂡 🂡 🂪 🂪 🂪  ⇒ Full House $5.00  \n ⇑         \n\n"
        expect(hand.draw).to eq(expected)
      end
    end
  end

  describe '#replace_discards' do
    before do
      hand.cards << ace << three << five << seven << ten
    end

    it 'replaces the discards' do
      hand.discards = [0, 2, 4]
      hand.replace_discards
      expect(hand.discards).to be_empty
    end
  end

  describe '#normalize_current_card' do
    it 'increases the current card to 0' do
      hand.current_card = -1
      hand.normalize_current_card
      expect(hand.current_card).to eq(0)
    end

    it 'reduces the current card to 4' do
      hand.current_card = 5
      hand.normalize_current_card
      expect(hand.current_card).to eq(4)
    end
  end

  describe '#clear_draw_hand_actions' do
    before do
      hand.cards << ace << three << five << seven << ten
      poker.hand = hand
      allow(Poker).to receive(:getc).and_return('x')
      allow(poker).to receive(:puts)
      allow(hand).to receive(:puts)
    end

    it 'calls normalize_current_card' do
      allow(hand).to receive(:normalize_current_card)
      hand.clear_draw_hand_actions
      expect(hand).to have_received(:normalize_current_card)
    end

    it 'calls clear' do
      allow(poker).to receive(:clear)
      hand.clear_draw_hand_actions
      expect(poker).to have_received(:clear)
    end

    it 'calls draw_hand' do
      allow(poker).to receive(:draw_hand)
      hand.clear_draw_hand_actions
      expect(poker).to have_received(:draw_hand)
    end

    it 'calls ask_hand_action' do
      allow(hand).to receive(:ask_hand_action)
      hand.clear_draw_hand_actions
      expect(hand).to have_received(:ask_hand_action)
    end
  end

  describe '#ask_hand_action' do
    before do
      hand.cards << ace << three << five << seven << ten
      poker.hand = hand
      allow(poker).to receive(:puts)
      allow(hand).to receive(:puts)
    end

    context 'when keeping current card' do
      before do
        allow(Poker).to receive(:getc).and_return('k', 'x', 'q')
        allow(hand.discards).to receive(:delete).with(0)
        allow(hand).to receive(:current_card=).with(1)
        allow(hand).to receive(:current_card=).with(nil)
        allow(hand).to receive(:clear_draw_hand_actions).and_call_original
      end

      it 'increments the current card' do
        hand.ask_hand_action
        expect(hand.discards).to have_received(:delete).with(0)
        expect(hand).to have_received(:current_card=).with(1)
        expect(hand).to have_received(:current_card=).with(nil)
        expect(hand).to have_received(:clear_draw_hand_actions)
      end
    end

    context 'when discarding current card' do
      before do
        allow(Poker).to receive(:getc).and_return('d', 'x', 'q')
        allow(hand.discards).to receive(:<<).with(0)
        allow(hand).to receive(:current_card=).with(1)
        allow(hand).to receive(:current_card=).with(nil)
        allow(hand).to receive(:clear_draw_hand_actions).and_call_original
      end

      it 'increments the current card' do
        hand.ask_hand_action
        expect(hand.discards).to have_received(:<<).with(0)
        expect(hand).to have_received(:current_card=).with(1)
        expect(hand).to have_received(:current_card=).with(nil)
        expect(hand).to have_received(:clear_draw_hand_actions)
      end

      it 'does not add a duplicate discard' do
        allow(hand.discards).to receive(:include?).and_return(true)
        hand.ask_hand_action
        expect(hand.discards).to_not have_received(:<<).with(0)
        expect(hand).to have_received(:current_card=).with(1)
        expect(hand).to have_received(:current_card=).with(nil)
        expect(hand).to have_received(:clear_draw_hand_actions)
      end
    end

    context 'when skipping the current card' do
      before do
        allow(Poker).to receive(:getc).and_return('n', 'x', 'q')
        allow(hand).to receive(:current_card=).with(1)
        allow(hand).to receive(:current_card=).with(nil)
        allow(hand).to receive(:clear_draw_hand_actions).and_call_original
      end

      it 'increments the current card' do
        hand.ask_hand_action
        expect(hand).to have_received(:current_card=).with(1)
        expect(hand).to have_received(:current_card=).with(nil)
        expect(hand).to have_received(:clear_draw_hand_actions)
      end
    end

    context 'when moving to previous card' do
      before do
        hand.current_card = 1
        allow(Poker).to receive(:getc).and_return('p', 'x', 'q')
        allow(hand).to receive(:current_card=).with(0)
        allow(hand).to receive(:current_card=).with(nil)
        allow(hand).to receive(:clear_draw_hand_actions).and_call_original
      end

      it 'increments the current card' do
        hand.ask_hand_action
        expect(hand).to have_received(:current_card=).with(0)
        expect(hand).to have_received(:current_card=).with(nil)
        expect(hand).to have_received(:clear_draw_hand_actions)
      end
    end

    context 'when invalid input' do
      before do
        allow(Poker).to receive(:getc).and_return('z', 'x', 'q')
        allow(hand).to receive(:clear_draw_hand_actions).and_call_original
      end

      it 'increments the current card' do
        hand.ask_hand_action
        expect(hand).to have_received(:clear_draw_hand_actions)
      end
    end
  end
end
