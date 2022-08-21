# frozen_string_literal: true

FactoryBot.define do
  factory :poker do
    deck { nil }
    money { 10_000 }
    hand { nil }
    face_type { 1 }
    current_bet { 500 }
  end

  trait :with_deck do
    deck { build(:deck, :new_regular) }
  end

  initialize_with { new }
end
