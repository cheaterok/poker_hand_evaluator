defmodule PokerHandEvaluator.Combinations do
  @moduledoc false

  alias PokerHandEvaluator.{Card, Game}
  alias __MODULE__.{SpecialCombinations, GroupCombinations}

  require TypeUnion
  require DryStruct

  @combinations ~w[
    high_card
    pair
    two_pairs
    three_of_a_kind
    low_straight
    straight
    flush
    full_house
    four_of_a_kind
    low_straight_flush
    straight_flush
  ]a
  TypeUnion.type :t, @combinations

  @opaque comparison_value :: {pos_integer(), [pos_integer()], [pos_integer(), ...]}

  @spec calculate_hand_value(Game.cards()) :: comparison_value()
  def calculate_hand_value(cards) do
    {combination, combination_cards} = detect_combination(cards)

    combination_value = combination_value(combination)
    cards_values = Enum.map(combination_cards, &Card.value/1)
    hand_cards_values =
      cards
      |> Stream.map(&Card.value/1)
      |> Enum.sort(:desc)

    {combination_value, cards_values, hand_cards_values}
  end

  defp detect_combination(cards) do
    sorted_cards = Enum.sort_by(cards, &Card.value/1, :desc)

    [
      SpecialCombinations.find_special_combination(sorted_cards),
      GroupCombinations.find_group_combination(cards),
    ]
    |> Stream.reject(&is_nil/1)
    |> Enum.max_by(
      fn {combination, _cards} -> combination_value(combination) end,
      fn -> {:high_card, [hd(sorted_cards)]} end
    )
  end

  combinations2values = Enum.with_index(@combinations, 1)

  defp combination_value(combination)

  for {combination, value} <- combinations2values do
    defp combination_value(unquote(combination)), do: unquote(value)
  end

  if Mix.env() == :test do
    def integer_to_combination(integer)
    for {combination, value} <- combinations2values do
      def integer_to_combination(unquote(value)), do: unquote(combination)
    end
  end
end
