defmodule PokerHandEvaluatorTest.CardTest do
  use ExUnit.Case

  alias PokerHandEvaluator.Card

  describe "Rank.value/1" do
    test "same rank" do
      assert Card.Rank.value(:A) == Card.Rank.value(:A)
    end

    test "Ace > King" do
      assert Card.Rank.value(:A) > Card.Rank.value(:K)
    end

    test "9 < Jack" do
      assert Card.Rank.value(:"9") < Card.Rank.value(:J)
    end
  end

  describe "value/1" do
    test "cards sorted by ranks" do
      cards = for rank <- Card.Rank.ranks(), do: %Card{rank: rank, suit: :spades}
      cards_reversed = Enum.reverse(cards)

      assert cards == Enum.sort_by(cards_reversed, &Card.value/1)
      assert cards_reversed == Enum.sort_by(cards, &Card.value/1, :desc)
    end
  end
end
