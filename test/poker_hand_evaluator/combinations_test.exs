defmodule PokerHandEvaluatorTest.CombinationsTest do
  use ExUnit.Case

  alias PokerHandEvaluator.Combinations

  alias PokerHandEvaluatorTest.Support.HelperFunctions

  inputs = [
    {
      "straight-flush",
      [
        "3": :spades,
        "2": :spades,
        "6": :spades,
        "5": :spades,
        "4": :spades
      ],
      :straight_flush
    },
    {
      "straight-flush from A to 5 with different Aces",
      [
        "3": :spades,
        "2": :spades,
        A: :diamonds,
        A: :spades,
        A: :clubs,
        "4": :spades,
        "5": :spades
      ],
      :low_straight_flush
    },
    {
      "flush",
      [
        J: :clubs,
        "2": :clubs,
        Q: :clubs,
        "4": :clubs,
        "9": :clubs
      ],
      :flush
    },
    {
      "straight",
      [
        "3": :clubs,
        "2": :spades,
        "6": :hearts,
        "5": :spades,
        "4": :diamonds
      ],
      :straight
    },
    {
      "straight from A to 5",
      [
        "2": :hearts,
        "5": :clubs,
        "3": :spades,
        A: :clubs,
        "4": :hearts
      ],
      :low_straight
    },
    {
      "straight and flush but from different combinations",
      [
        "2": :hearts,
        "3": :clubs,
        "4": :clubs,
        "5": :clubs,
        "6": :clubs,
        Q: :clubs
      ],
      :flush
    },
    {
      "straight earlier than straight-flush",
      [
        Q: :hearts,
        J: :clubs,
        T: :clubs,
        "9": :clubs,
        "8": :clubs,
        "7": :clubs
      ],
      :straight_flush
    },
    {
      "flush later than straight-flush",
      [
        K: :clubs,
        J: :clubs,
        T: :clubs,
        "9": :clubs,
        "8": :clubs,
        "7": :clubs
      ],
      :straight_flush
    },
    {
      "straight with duplicate ranks",
      [
        J: :clubs,
        T: :spades,
        "9": :clubs,
        "9": :diamonds,
        "8": :clubs,
        "7": :hearts
      ],
      :straight
    },
    {
      "four of a kind",
      [
        K: :hearts,
        "2": :clubs,
        K: :clubs,
        K: :spades,
        "6": :spades,
        K: :diamonds
      ],
      :four_of_a_kind
    },
    {
      "full house",
      [
        K: :hearts,
        "2": :clubs,
        K: :clubs,
        "2": :spades,
        "6": :spades,
        K: :diamonds
      ],
      :full_house
    },
    {
      "ace to five straight needs 5 cards (bug case)",
      [
        A: :hearts,
        A: :spades,
        "5": :clubs,
        "4": :diamonds,
        "3": :hearts
      ],
      :pair
    }
  ]

  code =
    for {name, pairs, expected_combination} <- inputs do
      quote do
        test unquote(name) do
          cards = HelperFunctions.pairs_to_cards(unquote(pairs))

          combination =
            cards
            |> Combinations.calculate_hand_value()
            |> elem(0)
            |> Combinations.integer_to_combination()

          assert combination == unquote(expected_combination)
        end
      end
    end

  Module.eval_quoted(__ENV__, code)
end
