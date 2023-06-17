# frozen_string_literal: true

RSpec.describe Poker do
  let(:hand) { build(:hand, poker:) }
  let(:deck) { build(:deck, :new_regular) }
  let(:poker) { build(:poker, deck:) }
  let(:input) { StringIO.new }

  describe '.new' do
    it 'creates a poker' do
      expect(poker).to be
    end
  end

  describe '#save_game' do
    let(:file) { instance_double(File) }

    before do
      allow(File).to receive(:open).with(SAVE_FILE, 'w').and_yield(file)
      allow(file).to receive(:puts)
    end

    it 'opens and put save file data' do
      poker.save_game
      expected = %i[deck_type face_type money current_bet].map do |f|
        poker.send(f)
      end.join('|')
      expect(file).to have_received(:puts).with(expected)
    end
  end

  describe '#load_game' do
    context 'with a unreadable save file' do
      it 'fails to load save file' do
        allow(File).to receive(:read).with(SAVE_FILE)
        allow(File).to receive(:readable?).with(SAVE_FILE).and_return(false)

        poker.load_game
        expect(File).to_not have_received(:read).with(SAVE_FILE)
      end
    end

    context 'with a readabale save file' do
      before do
        allow(File).to receive(:readable?).with(SAVE_FILE).and_return(true)
        allow(File).to receive(:read).with(SAVE_FILE).and_return('8|1|2000|1000')
      end

      it 'loads deck_type from save file data' do
        poker.load_game
        expect(poker.deck_type).to eq(8)
      end

      it 'loads face_type from save file data' do
        poker.load_game
        expect(poker.face_type).to eq(1)
      end

      it 'loads money from save file data' do
        poker.load_game
        expect(poker.money).to eq(2000)
      end

      it 'loads current_bet from save file data' do
        poker.load_game
        expect(poker.current_bet).to eq(1000)
      end
    end
  end

  describe '#getc' do
    it 'get a single character from stdin' do
      allow(input).to receive(:getc).and_return('q')
      c = described_class.getc(input)
      expect(c).to eq('q')
    end
  end

  describe '#normalize_current_bet' do
    it 'reduces the current bet to money' do
      poker.current_bet = poker.money + 1
      poker.normalize_current_bet
      expect(poker.current_bet).to eq(poker.money)
    end

    it 'reduces the current bet to MAX_BET' do
      poker.money = MAX_BET + 1
      poker.current_bet = MAX_BET + 1
      poker.normalize_current_bet
      expect(poker.current_bet).to eq(MAX_BET)
    end

    it 'increases the current bet to MIN_BET' do
      poker.current_bet = MIN_BET - 1
      poker.normalize_current_bet
      expect(poker.current_bet).to eq(MIN_BET)
    end
  end

  describe '#clear' do
    it 'calls system' do
      ENV['CLEAR_TERM'] = '1'
      allow(poker).to receive(:system)
      poker.clear
      expect(poker).to have_received(:system).with('export TERM=linux; clear')
    end

    it 'does not call system' do
      ENV['CLEAR_TERM'] = '0'
      allow(poker).to receive(:system)
      poker.clear
      expect(poker).to_not have_received(:system)
    end
  end

  describe '#run' do
    let(:hand) { build(:hand, poker:) }

    before do
      allow(poker).to receive(:hand).and_return(hand)
      allow(poker).to receive(:load_game)
      allow(Deck).to receive(:new)
      allow(poker).to receive(:deal_new_hand)
      allow(poker).to receive(:puts)
      allow(described_class).to receive(:getc).and_return('q')
    end

    it 'loads saved game' do
      poker.run
      expect(poker).to have_received(:load_game)
    end

    it 'creates a new deck' do
      poker.run
      expect(Deck).to have_received(:new)
    end

    it 'deals a new hand' do
      poker.run
      expect(poker).to have_received(:deal_new_hand)
    end
  end

  describe '#build_new_hand' do
    before do
      poker.build_new_hand
    end

    it 'player hand has two cards' do
      expect(poker.hand.cards.size).to eq(5)
    end
  end

  describe '#deal_new_hand' do
    let(:hand) { build(:hand, :unknown, poker:) }

    before do
      allow(poker).to receive(:hand).and_return(hand)
      allow(poker).to receive(:draw_hand)
      allow(hand).to receive(:puts)
      allow(described_class).to receive(:getc).and_return('x')
    end

    context 'when shuffling may be required' do
      before do
        allow(poker).to receive(:build_new_hand)
        allow(poker.deck).to receive(:new_regular)
      end

      it 'shuffles' do
        poker.deal_new_hand
        expect(poker.deck).to have_received(:new_regular)
      end
    end

    context 'when the player hand is already paid' do
      before do
        allow(poker).to receive(:build_new_hand)
        allow(hand).to receive(:ask_hand_action)
        allow(poker).to receive(:save_game)
        allow(hand).to receive(:result).and_return(true)
      end

      it 'hands are drawn' do
        poker.deal_new_hand
        expect(poker).to have_received(:draw_hand)
      end

      it 'bet options are drawn' do
        poker.deal_new_hand
        expect(poker).to have_received(:save_game)
      end
    end
  end

  describe '#new_bet' do
    before do
      allow(input).to receive(:gets).and_return('10')
      allow(described_class).to receive(:getc).and_return('s', 'q')
      allow(poker).to receive(:print)
      allow(poker).to receive(:puts)
      allow(poker).to receive(:deal_new_hand)
      allow(poker).to receive(:clear)
      allow(poker).to receive(:draw_hand)
      allow(poker).to receive(:normalize_current_bet)
    end

    it 'clears the screen' do
      poker.new_bet(input)
      expect(poker).to have_received(:clear)
    end

    it 'draws hands' do
      poker.new_bet(input)
      expect(poker).to have_received(:draw_hand)
    end

    it 'draws the current bet' do
      poker.new_bet(input)
      expected = " Current Bet: $5.00\n"
      expect(poker).to have_received(:puts).with(expected)
    end

    it 'updates current bet' do
      poker.new_bet(input)
      expect(poker.current_bet).to eq(1000)
    end

    it 'normalizes the bet' do
      poker.new_bet(input)
      expect(poker).to have_received(:normalize_current_bet)
    end

    it 'deals a new hand' do
      poker.new_bet(input)
      expect(poker).to have_received(:deal_new_hand)
    end
  end

  describe '#draw_bet_options' do
    before do
      allow(poker).to receive(:puts)
    end

    context 'when dealing a new hand' do
      it 'deals a new hand' do
        allow(described_class).to receive(:getc).and_return('d')
        allow(poker).to receive(:deal_new_hand)
        poker.draw_bet_options
        expect(poker).to have_received(:deal_new_hand)
      end
    end

    context 'when updating current bet' do
      it 'deals a new hand' do
        allow(described_class).to receive(:getc).and_return('b')
        allow(poker).to receive(:new_bet)
        poker.draw_bet_options
        expect(poker).to have_received(:new_bet)
      end
    end

    context 'when updating poker options' do
      before do
        poker.hand = hand
        allow(described_class).to receive(:getc).and_return('o')
      end

      it 'draws poker options' do
        allow(poker).to receive(:draw_game_options)
        poker.draw_bet_options
        expect(poker).to have_received(:draw_game_options)
      end

      it 'draws hands' do
        allow(poker).to receive(:draw_game_options)
        allow(poker).to receive(:draw_hand)
        poker.draw_bet_options
        expect(poker).to have_received(:draw_hand)
      end

      it 'clears the screen' do
        allow(poker).to receive(:draw_game_options)
        allow(poker).to receive(:draw_hand)
        allow(poker).to receive(:clear)
        poker.draw_bet_options
        expect(poker).to have_received(:clear)
      end
    end

    context 'when quitting' do
      it 'clears the screen and exits' do
        allow(described_class).to receive(:getc).and_return('q')
        poker.draw_bet_options
        expect(poker.quitting).to be_truthy
      end
    end

    context 'when invalid input' do
      it 'gets the action again' do
        poker.hand = hand
        allow(described_class).to receive(:getc).and_return('x', 'q')
        poker.draw_bet_options
        expect(poker.quitting).to be_truthy
      end
    end
  end

  describe '#new_face_type' do
    before do
      poker.hand = hand
      allow(poker).to receive(:puts)
    end

    context 'when choosing a new face type' do
      it 'draws options' do
        allow(described_class).to receive(:getc).and_return('1')
        poker.new_face_type
        expected = ' (1) 🂡  (2) A♠'
        expect(poker).to have_received(:puts).with(expected)
      end

      it 'sets regular faces' do
        allow(described_class).to receive(:getc).and_return('1')
        allow(poker).to receive(:save_game)
        allow(poker).to receive(:face_type=).with(1)
        poker.new_face_type
        expect(poker).to have_received(:face_type=).with(1)
        expect(poker).to have_received(:save_game)
      end

      it 'sets alternate faces' do
        allow(described_class).to receive(:getc).and_return('2')
        allow(poker).to receive(:save_game)
        allow(poker).to receive(:face_type=).with(2)
        poker.new_face_type
        expect(poker).to have_received(:face_type=).with(2)
        expect(poker).to have_received(:save_game)
      end
    end

    context 'when invalid input' do
      it 'gets the action again' do
        poker.hand = hand
        allow(described_class).to receive(:getc).and_return('x', '1')
        allow(poker).to receive(:face_type=).with(1)
        poker.new_face_type
        expect(poker.face_type).to eq(1)
      end
    end
  end

  describe '#new_deck_type' do
    before do
      poker.hand = hand
      allow(poker).to receive(:puts)
      allow(poker).to receive(:save_game)
    end

    context 'when choosing a new deck type' do
      it 'draws options' do
        allow(described_class).to receive(:getc).and_return('1')
        poker.new_deck_type
        expected = ' (1) Regular  (2) Aces  (3) Jacks  (4) Aces & Jacks  (5) Sevens  (6) Eights'
        expect(poker).to have_received(:puts).with(expected)
      end

      it 'builds a new regular' do
        allow(described_class).to receive(:getc).and_return('1')
        allow(poker.deck).to receive(:new_regular)
        poker.new_deck_type
        expect(poker.deck).to have_received(:new_regular)
        expect(poker).to have_received(:save_game)
      end

      it 'builds a new aces' do
        allow(described_class).to receive(:getc).and_return('2')
        allow(poker.deck).to receive(:new_aces)
        poker.new_deck_type
        expect(poker.deck).to have_received(:new_aces)
        expect(poker).to have_received(:save_game)
      end

      it 'builds a new jacks' do
        allow(described_class).to receive(:getc).and_return('3')
        allow(poker.deck).to receive(:new_jacks)
        poker.new_deck_type
        expect(poker.deck).to have_received(:new_jacks)
        expect(poker).to have_received(:save_game)
      end

      it 'builds a new aces_jacks' do
        allow(described_class).to receive(:getc).and_return('4')
        allow(poker.deck).to receive(:new_aces_jacks)
        poker.new_deck_type
        expect(poker.deck).to have_received(:new_aces_jacks)
        expect(poker).to have_received(:save_game)
      end

      it 'builds a new sevens' do
        allow(described_class).to receive(:getc).and_return('5')
        allow(poker.deck).to receive(:new_sevens)
        poker.new_deck_type
        expect(poker.deck).to have_received(:new_sevens)
        expect(poker).to have_received(:save_game)
      end

      it 'builds a new eights' do
        allow(described_class).to receive(:getc).and_return('6')
        allow(poker.deck).to receive(:new_eights)
        poker.new_deck_type
        expect(poker.deck).to have_received(:new_eights)
        expect(poker).to have_received(:save_game)
      end
    end

    context 'when invalid input' do
      it 'gets the action again' do
        poker.hand = hand
        allow(described_class).to receive(:getc).and_return('x', '1')
        allow(poker).to receive(:deck_type=).with(1)
        poker.new_deck_type
        expect(poker.deck_type).to eq(1)
      end
    end
  end

  describe '#draw_game_options' do
    before do
      poker.hand = hand
    end

    context 'when updating the deck type' do
      before do
        allow(described_class).to receive(:getc).and_return('t')
        allow(poker).to receive(:clear)
        allow(poker).to receive(:draw_hand)
        allow(poker).to receive(:new_deck_type)
        allow(poker).to receive(:draw_bet_options)
        allow(poker).to receive(:puts)
      end

      it 'clears the screen' do
        poker.draw_game_options
        expect(poker).to have_received(:clear).twice
      end

      it 'draws the hands' do
        poker.draw_game_options
        expect(poker).to have_received(:draw_hand).twice
      end

      it 'updates deck type' do
        poker.draw_game_options
        expect(poker).to have_received(:new_deck_type)
      end

      it 'draws the bet options' do
        poker.draw_game_options
        expect(poker).to have_received(:draw_bet_options)
      end
    end

    context 'when updating the face type' do
      before do
        allow(described_class).to receive(:getc).and_return('f')
        allow(poker).to receive(:clear)
        allow(poker).to receive(:draw_hand)
        allow(poker).to receive(:new_face_type)
        allow(poker).to receive(:draw_bet_options)
        allow(poker).to receive(:puts)
      end

      it 'clears the screen' do
        poker.draw_game_options
        expect(poker).to have_received(:clear).twice
      end

      it 'draws the hands' do
        poker.draw_game_options
        expect(poker).to have_received(:draw_hand).twice
      end

      it 'updates face type' do
        poker.draw_game_options
        expect(poker).to have_received(:new_face_type)
      end

      it 'draws the bet options' do
        poker.draw_game_options
        expect(poker).to have_received(:draw_bet_options)
      end
    end

    context 'when going back to previous menu' do
      before do
        allow(described_class).to receive(:getc).and_return('b')
        allow(poker).to receive(:clear)
        allow(poker).to receive(:draw_hand)
        allow(poker).to receive(:draw_bet_options)
        allow(poker).to receive(:puts)
      end

      it 'clears the screen' do
        poker.draw_game_options
        expect(poker).to have_received(:clear)
      end

      it 'draws the hands' do
        poker.draw_game_options
        expect(poker).to have_received(:draw_hand)
      end

      it 'draws the bet options' do
        poker.draw_game_options
        expect(poker).to have_received(:draw_bet_options)
      end
    end

    context 'when invalid input' do
      before do
        allow(described_class).to receive(:getc).and_return('x', 'b')
        allow(poker).to receive(:puts)
        allow(poker).to receive(:new_bet)
        allow(poker).to receive(:draw_bet_options)
        allow(poker).to receive(:draw_hand)
      end

      it 'gets the action again' do
        poker.draw_game_options
        allow(poker).to receive(:draw_game_options)
        expect(poker).to have_received(:draw_bet_options).twice
      end
    end
  end
end
