# frozen_string_literal: true

FactoryBot.define do
  factory :deck do
    poker { nil }
    cards { [] }

    after(:build, &:new_regular)

    initialize_with { new(poker) }
  end
end
