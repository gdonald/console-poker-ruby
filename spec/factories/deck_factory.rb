# frozen_string_literal: true

FactoryBot.define do
  factory :deck do
    poker { nil }
    cards { [] }

    trait :new_regular do
      after(:build, &:new_regular)
    end

    initialize_with { new(poker) }
  end
end
