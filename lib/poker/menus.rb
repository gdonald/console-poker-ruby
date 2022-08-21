# frozen_string_literal: true

module Menus
  def draw_bet_options
    puts ' (D) Deal Hand  (B) Change Bet  (O) Options  (Q) Quit'
    c = Poker.getc($stdin)
    case c
    when 'd'
      deal_new_hand
    when 'b'
      new_bet($stdin)
    when 'o'
      clear_draw_hand_game_options
    when 'q'
      self.quitting = true
    else
      clear_draw_hand_bet_options
    end
  end

  def new_face_type
    puts ' (1) 🂡  (2) A♠'
    loop do
      c = Poker.getc($stdin).to_i
      case c
      when (1..2)
        self.face_type = c
        save_game
      else
        clear_draw_hand_new_face_type
      end
      break if (1..2).include?(c)
    end
  end

  def new_deck_type
    puts ' (1) Regular  (2) Aces  (3) Jacks  (4) Aces & Jacks  (5) Sevens  (6) Eights'
    loop do
      c = Poker.getc($stdin).to_i
      case c
      when (1..6)
        self.deck_type = c
        deck.send("new_#{DECKS[c]}")
        save_game
      else
        clear_draw_hand_new_deck_type
      end
      break if (1..6).include?(c)
    end
  end

  def draw_game_options
    puts ' (T) Deck Type  (F) Face Type  (B) Back'
    loop do
      c = Poker.getc($stdin)
      case c
      when 't'
        clear_draw_hand_new_deck_type
        clear_draw_hand_bet_options
      when 'f'
        clear_draw_hand_new_face_type
        clear_draw_hand_bet_options
      when 'b'
        clear_draw_hand_bet_options
      else
        clear_draw_hand_game_options
      end
      break if %w[t b f].include?(c)
    end
  end
end
