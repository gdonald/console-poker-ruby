# frozen_string_literal: true

require 'pry'

require_relative 'poker/deck'
require_relative 'poker/format'
require_relative 'poker/hand'
require_relative 'poker/menus'
require_relative 'poker/utils'

SAVE_FILE = 'poker.txt'
MIN_BET = 500
MAX_BET = 10_000_000

class Poker
  include Utils
  include Menus

  attr_accessor :deck, :money, :hand, :deck_type, :face_type, :current_bet, :quitting

  def initialize
    @face_type = 2
    @deck_type = 1
    @money = 10_000
    @current_bet = 500
  end

  def run
    load_game
    @deck = Deck.new(self)

    deal_new_hand
    clear_draw_hand_bet_options until quitting
  end

  def build_new_hand
    self.hand = Hand.new(self, current_bet)
    5.times { hand.deal_card }
  end

  def deal_new_hand
    deck.send("new_#{DECKS[deck_type]}")
    build_new_hand

    clear
    draw_hand
    hand.ask_hand_action
    save_game
  end

  def clear
    return if ENV['CLEAR_TERM'] == '0'

    system('export TERM=linux; clear')
  end

  def draw_hand
    out = String.new
    out << "\n Player $"
    out << Format.money(money / 100.0)
    out << ":\n"
    out << hand.draw
    puts out
  end

  def new_bet(input)
    clear
    draw_hand

    puts " Current Bet: $#{Format.money(current_bet / 100)}\n"
    print ' Enter New Bet: $'

    self.current_bet = input.gets.to_i * 100

    normalize_current_bet
    deal_new_hand
  end

  def normalize_current_bet
    if current_bet < MIN_BET
      self.current_bet = MIN_BET
    elsif current_bet > MAX_BET
      self.current_bet = MAX_BET
    end

    self.current_bet = money if current_bet > money
  end

  def self.getc(input)
    begin
      system('stty raw -echo')
      c = input.getc
    ensure
      system('stty -raw echo')
    end
    c.chr
  end
end
