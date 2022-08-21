# frozen_string_literal: true

class Card
  attr_reader :poker, :value, :suit

  def initialize(poker, value, suit)
    @poker = poker
    @value = value
    @suit = suit
  end

  def to_s
    return Card.faces[value][suit] if poker.face_type == 1

    Card.faces2[value][suit]
  end

  def self.faces
    [%w[🂡 🂱 🃁 🃑], %w[🂢 🂲 🃂 🃒], %w[🂣 🂳 🃃 🃓], %w[🂤 🂴 🃄 🃔],
     %w[🂥 🂵 🃅 🃕], %w[🂦 🂶 🃆 🃖], %w[🂧 🂷 🃇 🃗], %w[🂨 🂸 🃈 🃘],
     %w[🂩 🂹 🃉 🃙], %w[🂪 🂺 🃊 🃚], %w[🂫 🂻 🃋 🃛], %w[🂭 🂽 🃍 🃝],
     %w[🂮 🂾 🃎 🃞], %w[🂠]]
  end

  def self.faces2
    [%w[A♠ A♥ A♣ A♦], %w[2♠ 2♥ 2♣ 2♦],
     %w[3♠ 3♥ 3♣ 3♦], %w[4♠ 4♥ 4♣ 4♦],
     %w[5♠ 5♥ 5♣ 5♦], %w[6♠ 6♥ 6♣ 6♦],
     %w[7♠ 7♥ 7♣ 7♦], %w[8♠ 8♥ 8♣ 8♦],
     %w[9♠ 9♥ 9♣ 9♦], %w[T♠ T♥ T♣ T♦],
     %w[J♠ J♥ J♣ J♦], %w[Q♠ Q♥ Q♣ Q♦],
     %w[K♠ K♥ K♣ K♦], %w[??]]
  end
end
