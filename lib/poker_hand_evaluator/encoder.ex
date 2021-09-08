defmodule PokerHandEvaluator.Encoder do
  @moduledoc false

  alias PokerHandEvaluator.{Game, Combinations, Card}

  @spec encode([Game.cards()], [Combinations.comparison_value()]) :: String.t()
  def encode(hands, combination_values) do
    hands
    |> Stream.zip(combination_values)
    |> Enum.sort_by(fn {_hand, value} -> value end)
    |> group_equal()
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

  defp group_equal(enumerable) do
    enumerable
    |> Enum.reverse()
    |> Enum.reduce([], &group_equal_add_element/2)
  end

  defp group_equal_add_element(element, [[hd | _tl] = equal_group | tail] = list) do
    if equal_by(hd, element) do
      [[element | equal_group] | tail]
    else
      [element | list]
    end
  end

  defp group_equal_add_element(element, [hd | tl] = list) do
    if equal_by(hd, element) do
      [[element, hd] | tl]
    else
      [element | list]
    end
  end

  defp group_equal_add_element(element, []) do
    [element]
  end

  defp equal_by({_hand_1, value_1}, {_hand_2, value_2}), do: value_1 == value_2
end
