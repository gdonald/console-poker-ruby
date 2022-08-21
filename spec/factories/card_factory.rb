# frozen_string_literal: true

FactoryBot.define do
  factory :card do
    poker { nil }
    value { 0 }
    suit { 0 }

    trait :ace do
      value { 0 }
    end

    trait :two do
      value { 1 }
    end

    trait :three do
      value { 2 }
    end

    trait :four do
      value { 3 }
    end

    trait :five do
      value { 4 }
    end

    trait :six do
      value { 5 }
    end

    trait :seven do
      value { 6 }
    end

    trait :eight do
      value { 7 }
    end

    trait :nine do
      value { 8 }
    end

    trait :ten do
      value { 9 }
    end

    trait :jack do
      value { 10 }
    end

    trait :queen do
      value { 11 }
    end

    trait :king do
      value { 12 }
    end

    trait :spades do
      suit { 0 }
    end

    trait :hearts do
      suit { 1 }
    end

    trait :clubs do
      suit { 2 }
    end

    trait :diamonds do
      suit { 3 }
    end

    initialize_with { new(poker, value, suit) }
  end
end
