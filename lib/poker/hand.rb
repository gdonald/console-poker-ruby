# frozen_string_literal: true

require_relative 'hand_ranker'

class Hand
  PAYOUT = {
    royal_flush: 800,
    straight_flush: 50,
    four_of_a_kind: 25,
    full_house: 9,
    flush: 6,
    straight: 4,
    three_of_a_kind: 3,
    two_pair: 2,
    one_pair: 1
  }.freeze

  attr_accessor :poker, :bet, :result, :cards, :rank, :current_card, :discards

  def initialize(poker, bet)
    @poker = poker
    @bet = bet
    @result = nil
    @cards = []
    @discards = []
    @current_card = 0
    @rank = :unknown
  end

  def deal_card
    cards << poker.deck.next_card
  end

  def pay
    return if result

    HandRanker.new(self)

    self.result = rank == :unknown ? -bet : PAYOUT[rank] * bet
    poker.money += result
  end

  def draw
    out = String.new(' ')
    out << draw_cards
    out << draw_money
    out << draw_card_selector
    out << "\n\n"
    out
  end

  def draw_card_selector
    space = poker.face_type == 2 ? '  ' : ' '

    out = String.new("\n ")
    5.times do |i|
      out << (current_card == i ? '⇑' : ' ')
      out << space
    end
    out
  end

  def draw_money
    out = String.new('')
    out << (result.negative? ? '-' : '+') if result
    out << '$' << Format.money((result || bet).abs / 100.0)
    out << '  '
    out
  end

  def draw_cards
    faces = poker.face_type == 2 ? Card.faces2 : Card.faces
    card_back = faces[13][0]

    out = String.new('')
    5.times do |i|
      out << (discards.include?(i) ? card_back : cards[i].to_s)
      out << ' '
    end
    out << rank_display
    out
  end

  def rank_display
    if rank == :unknown
      ' '
    else
      rank_name = rank.to_s.split(/ |_/).map(&:capitalize).join(' ')
      " ⇒ #{rank_name} "
    end
  end

  def ask_hand_action
    puts ' (K) Keep  (D) Discard  (N) Next  (P) Prev  (X) Draw'
    c = Poker.getc($stdin)
    case c
    when 'k'
      discards.delete(current_card)
      self.current_card = current_card.succ
      clear_draw_hand_actions
    when 'd'
      discards << current_card unless discards.include?(current_card)
      self.current_card = current_card.succ
      clear_draw_hand_actions
    when 'n'
      self.current_card = current_card.succ
      clear_draw_hand_actions
    when 'p'
      self.current_card = current_card.pred
      clear_draw_hand_actions
    when 'x'
      self.current_card = nil
      replace_discards
      pay
    else
      clear_draw_hand_actions
    end
  end

  def clear_draw_hand_actions
    normalize_current_card
    poker.clear
    poker.draw_hand
    ask_hand_action
  end

  def normalize_current_card
    self.current_card = 0 if current_card.negative?
    self.current_card = 4 if current_card > 4
  end

  def replace_discards
    5.times do |i|
      next unless discards.include?(i)

      cards[i] = poker.deck.next_card
    end

    discards.clear
  end
end
