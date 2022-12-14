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
    [%w[ğ¡ ğ± ğ ğ], %w[ğ¢ ğ² ğ ğ], %w[ğ£ ğ³ ğ ğ], %w[ğ¤ ğ´ ğ ğ],
     %w[ğ¥ ğµ ğ ğ], %w[ğ¦ ğ¶ ğ ğ], %w[ğ§ ğ· ğ ğ], %w[ğ¨ ğ¸ ğ ğ],
     %w[ğ© ğ¹ ğ ğ], %w[ğª ğº ğ ğ], %w[ğ« ğ» ğ ğ], %w[ğ­ ğ½ ğ ğ],
     %w[ğ® ğ¾ ğ ğ], %w[ğ ]]
  end

  def self.faces2
    [%w[Aâ  Aâ¥ Aâ£ Aâ¦], %w[2â  2â¥ 2â£ 2â¦],
     %w[3â  3â¥ 3â£ 3â¦], %w[4â  4â¥ 4â£ 4â¦],
     %w[5â  5â¥ 5â£ 5â¦], %w[6â  6â¥ 6â£ 6â¦],
     %w[7â  7â¥ 7â£ 7â¦], %w[8â  8â¥ 8â£ 8â¦],
     %w[9â  9â¥ 9â£ 9â¦], %w[Tâ  Tâ¥ Tâ£ Tâ¦],
     %w[Jâ  Jâ¥ Jâ£ Jâ¦], %w[Qâ  Qâ¥ Qâ£ Qâ¦],
     %w[Kâ  Kâ¥ Kâ£ Kâ¦], %w[??]]
  end
end
