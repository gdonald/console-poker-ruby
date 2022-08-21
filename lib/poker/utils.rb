# frozen_string_literal: true

module Utils
  def load_game
    return unless File.readable?(SAVE_FILE)

    a = File.read(SAVE_FILE).split('|')
    self.deck_type   = a[0].to_i
    self.face_type   = a[1].to_i
    self.money       = a[2].to_i
    self.current_bet = a[3].to_i
  end

  def save_game
    File.open(SAVE_FILE, 'w') do |file|
      file.puts "#{deck_type}|#{face_type}|#{money}|#{current_bet}"
    end
  end

  def clear_draw_hand
    clear
    draw_hand
  end

  def clear_draw_hand_new_deck_type
    clear_draw_hand
    new_deck_type
  end

  def clear_draw_hand_new_face_type
    clear_draw_hand
    new_face_type
  end

  def clear_draw_hand_bet_options
    clear_draw_hand
    draw_bet_options
  end

  def clear_draw_hand_game_options
    clear_draw_hand
    draw_game_options
  end
end
