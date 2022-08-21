# frozen_string_literal: true

class HandRanker
  attr_reader :hand, :vals

  def initialize(hand)
    @hand = hand
    @vals = hand.cards.map(&:value).compact.sort
    raise ArgumentError, 'hand must have exactly five Cards' unless vals.count == 5

    hand.rank = rank_hand
  end

  private

  def rank_hand
    if royal_flush?
      :royal_flush
    elsif straight_flush?
      :straight_flush
    elsif four_of_a_kind?
      :four_of_a_kind
    elsif full_house?
      :full_house
    elsif flush?
      :flush
    elsif straight?
      :straight
    elsif three_of_a_kind?
      :three_of_a_kind
    elsif two_pair?
      :two_pair
    elsif one_pair?
      :one_pair
    else
      :unknown
    end
  end

  def royal_flush?
    flush? && vals == [0, 9, 10, 11, 12]
  end

  def straight_flush?
    flush? && straight?
  end

  def four_of_a_kind?
    uniq_count_one?(vals, 0, 1, 2, 3) || uniq_count_one?(vals, 1, 2, 3, 4)
  end

  def full_house?
    (uniq_count_one?(vals, 0, 1, 2) && uniq_count_one?(vals, 3, 4)) ||
      (uniq_count_one?(vals, 0, 1) && uniq_count_one?(vals, 2, 3, 4))
  end

  def flush?
    hand.cards.map(&:suit).uniq.count == 1
  end

  def straight?
    vals == [vals[0], vals[0] + 1, vals[0] + 2, vals[0] + 3, vals[0] + 4]
  end

  def three_of_a_kind?
    uniq_count_one?(vals, 0, 1, 2) ||
      uniq_count_one?(vals, 1, 2, 3) ||
      uniq_count_one?(vals, 2, 3, 4)
  end

  def two_pair?
    (uniq_count_one?(vals, 0, 1) && uniq_count_one?(vals, 2, 3)) ||
      (uniq_count_one?(vals, 0, 1) && uniq_count_one?(vals, 3, 4)) ||
      (uniq_count_one?(vals, 1, 2) && uniq_count_one?(vals, 3, 4))
  end

  def one_pair?
    uniq_count_one?(vals, 0, 1) ||
      uniq_count_one?(vals, 1, 2) ||
      uniq_count_one?(vals, 2, 3) ||
      uniq_count_one?(vals, 3, 4)
  end

  def uniq_count_one?(array, *args)
    array.values_at(*args).uniq.count == 1
  end
end
