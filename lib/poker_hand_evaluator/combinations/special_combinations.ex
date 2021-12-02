defmodule PokerHandEvaluator.Combinations.SpecialCombinations do
  @moduledoc false

  alias PokerHandEvaluator.{Game, Card}

  require TypeUnion

  @combinations ~w[
    low_straight
    straight
    flush
    low_straight_flush
    straight_flush
  ]a

  TypeUnion.type :t, @combinations

  @cards_in_combination 5

  @spec find_special_combination(Game.cards()) :: {t(), Game.cards()} | nil
  def find_special_combination(sorted_cards) do
    if flush_all = find_flush_all(sorted_cards) do
      if straight_flush = find_straight(flush_all) do
        wrap_straight({:straight_flush, straight_flush})
      else
        {:flush, Enum.take(flush_all, @cards_in_combination)}
      end
    else
      if straight = find_straight(sorted_cards) do
        wrap_straight({:straight, straight})
      end
    end
  end

  defp find_flush_all(cards) do
    cards
    |> Enum.group_by(& &1.suit)
    |> Map.values()
    |> Enum.find(&(length(&1) >= @cards_in_combination))
  end

  defp find_straight(cards) do
    cards = Enum.dedup_by(cards, & &1.rank)

    cond do
      straight = find_regular_straight(cards) -> {:regular, straight}
      straight = find_low_straight(cards) -> {:low, straight}
      true -> nil
    end
  end

  defp find_regular_straight(cards) do
    cards
    |> Stream.chunk_every(@cards_in_combination, 1, :discard)
    |> Enum.find(&regular_straight?/1)
  end

  defp find_low_straight(cards) do
    picked = [
      hd(cards) |
      Enum.take(cards, -(@cards_in_combination - 1))
    ]

    if low_straight?(picked), do: picked
  end

  defp regular_straight?(cards) do
    cards
    |> Stream.map(&Card.value/1)
    |> Stream.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [prev, curr] -> (prev - curr) == 1 end)
  end

  defp low_straight?(cards) do
    Enum.map(cards, & &1.rank) == ~w[A 5 4 3 2]a
  end

  defp wrap_straight({straight_combination, {straight_type, cards}}) do
    straight_combination_precise =
      case {straight_combination, straight_type} do
        {:straight_flush, :regular} -> :straight_flush
        {:straight_flush, :low} -> :low_straight_flush
        {:straight, :regular} -> :straight
        {:straight, :low} -> :low_straight
      end

    {straight_combination_precise, cards}
  end

end
