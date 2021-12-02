defmodule PokerHandEvaluator.Encoder do
  @moduledoc false

  alias PokerHandEvaluator.Card
  alias __MODULE__.Grouper

  @spec encode([PokerHandEvaluator.hand_to_value()]) :: String.t()
  def encode(hands_to_values) do
    hands_to_values
    |> Enum.sort_by(fn {_hand, value} -> value end)
    |> Grouper.group_equal()
    |> Stream.map(&encode_element/1)
    |> Enum.join(" ")
  end

  defp encode_element(element) when is_list(element) do
    element
    |> Stream.map(&encode_element/1)
    |> Enum.sort()
    |> Enum.join("=")
  end

  defp encode_element({hand, _value}) do
    hand
    |> Stream.map(&encode_card/1)
    |> Enum.join("")
  end

  defp encode_card(card) do
    Card.Rank.to_string(card.rank) <> Card.Suit.to_string(card.suit)
  end
end
