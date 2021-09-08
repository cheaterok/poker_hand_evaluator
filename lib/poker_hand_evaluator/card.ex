defmodule PokerHandEvaluator.Card do
  @moduledoc false

  alias __MODULE__.{Rank, Suit}

  use DryStruct

  drystruct enforce: true do
    field :rank, Rank.t()
    field :suit, Suit.t()
  end

  @spec value(t()) :: pos_integer()
  def value(card), do: Rank.value(card.rank)
end
