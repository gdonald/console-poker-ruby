# frozen_string_literal: true

FactoryBot.define do
  factory :hand do
    poker { nil }
    bet { 500 }
    cards { [] }

    trait :unknown do
      cards do
        [
          build(:card, :ace, suit: 1),
          build(:card, :five),
          build(:card, :six),
          build(:card, :seven),
          build(:card, :eight)
        ]
      end
    end

    trait :royal_flush do
      cards do
        [
          build(:card, :ace),
          build(:card, :king),
          build(:card, :queen),
          build(:card, :jack),
          build(:card, :ten)
        ]
      end
    end

    trait :straight_flush do
      cards do
        [
          build(:card, :king),
          build(:card, :queen),
          build(:card, :jack),
          build(:card, :ten),
          build(:card, :nine)
        ]
      end
    end

    trait :four_of_a_kind do
      cards do
        [
          build(:card, :king),
          build(:card, :ace),
          build(:card, :ace),
          build(:card, :ace),
          build(:card, :ace)
        ]
      end
    end

    trait :full_house do
      cards do
        [
          build(:card, :king),
          build(:card, :king),
          build(:card, :ace),
          build(:card, :ace),
          build(:card, :ace)
        ]
      end
    end

    trait :flush do
      cards do
        [
          build(:card, :king),
          build(:card, :queen),
          build(:card, :jack),
          build(:card, :ten),
          build(:card, :eight)
        ]
      end
    end

    trait :straight do
      cards do
        [
          build(:card, :king, suit: 1),
          build(:card, :queen),
          build(:card, :jack),
          build(:card, :ten),
          build(:card, :nine)
        ]
      end
    end

    trait :three_of_a_kind do
      cards do
        [
          build(:card, :king),
          build(:card, :queen),
          build(:card, :ace, suit: 1),
          build(:card, :ace),
          build(:card, :ace)
        ]
      end
    end

    trait :two_pair do
      cards do
        [
          build(:card, :king),
          build(:card, :king, suit: 1),
          build(:card, :queen),
          build(:card, :queen, suit: 1),
          build(:card, :ace)
        ]
      end
    end

    trait :one_pair do
      cards do
        [
          build(:card, :king),
          build(:card, :king, suit: 1),
          build(:card, :queen),
          build(:card, :jack),
          build(:card, :ace)
        ]
      end
    end

    initialize_with { new(poker, bet) }
  end
end
