# frozen_string_literal: true

require_relative 'card'

DECKS = {
  1 => :regular,
  2 => :aces,
  3 => :jacks,
  4 => :aces_jacks,
  5 => :sevens,
  6 => :eights
}.freeze

class Deck
  TOTAL_CARDS = 52

  attr_accessor :poker, :cards

  def initialize(poker)
    @poker = poker
    @cards = []
  end

  def shuffle
    7.times { cards.shuffle! }
  end

  def new_regular
    self.cards = []
    4.times do |suit_value|
      13.times do |value|
        cards << Card.new(poker, value, suit_value)
      end
    end
    shuffle
  end

  def new_irregular(values = [])
    self.cards = []
    while cards.count < TOTAL_CARDS
      4.times do |suit_value|
        next if cards.count >= TOTAL_CARDS

        values.each do |value|
          cards << Card.new(poker, value, suit_value)
        end
      end
    end
    shuffle
  end

  def new_aces
    new_irregular([0])
  end

  def new_jacks
    new_irregular([10])
  end

  def new_aces_jacks
    new_irregular([0, 10])
  end

  def new_sevens
    new_irregular([6])
  end

  def new_eights
    new_irregular([7])
  end

  def next_card
    cards.shift
  end
end
