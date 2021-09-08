defmodule PokerHandEvaluatorTest.Support.HelperFunctions do
  @moduledoc false

  alias PokerHandEvaluator.Card

  @spec pairs_to_cards([{Card.rank(), Card.suit()}]) :: [Card.t()]
  def pairs_to_cards(pairs) do
    Enum.map(pairs, fn {rank, suit} -> %Card{rank: rank, suit: suit} end)
  end
end
