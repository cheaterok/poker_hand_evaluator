defmodule PokerHandEvaluator.Combinations.GroupCombinations do
  @moduledoc false

  alias PokerHandEvaluator.Game

  require TypeUnion

  @groups [
    four_of_a_kind: [4],
    full_house: [3, 2],
    three_of_a_kind: [3],
    two_pairs: [2, 2],
    pair: [2]
  ]

  TypeUnion.type :t, @groups |> Keyword.keys() |> Enum.reverse()

  @typep group_description :: nonempty_list(pos_integer())
  @typep grouped_cards :: [{pos_integer(), Game.cards()}]

  @spec find_group_combination(Game.cards()) :: {t(), Game.cards()} | nil
  def find_group_combination(cards) do
    grouped_cards = split_into_groups(cards)
    Enum.find_value(@groups, fn {combination, group_description} ->
      if combination_cards = find_group(grouped_cards, group_description) do
        {combination, combination_cards}
      end
    end)
  end

  @spec find_group(grouped_cards(), group_description()) :: Game.cards() | nil
  defp find_group(grouped_cards, group_description) do
    {counts, cards_lists} =
      grouped_cards
      |> Stream.take(length(group_description))
      |> Enum.unzip()

    if counts == group_description do
      Enum.concat(cards_lists)
    end
  end

  @spec split_into_groups(Game.cards()) :: grouped_cards()
  defp split_into_groups(cards) do
    cards
    |> Enum.reverse()
    |> Enum.reduce(%{}, fn card, map ->
      rank = card.rank
      case map do
        %{^rank => {count, cards}} ->
          %{map | rank => {count + 1, [card | cards]}}
        _ ->
          Map.put(map, rank, {1, [card]})
      end
    end)
    |> Stream.map(fn {_key, value} -> value end)
    |> Enum.sort_by(fn {count, _cards} -> count end, :desc)
  end
end
