defmodule PokerHandEvaluatorTest.ParserTest do
  use ExUnit.Case

  alias PokerHandEvaluator.{Parser, Game}

  alias PokerHandEvaluatorTest.Support.HelperFunctions

  describe "parse/1 correct input" do
    test "texas-holdem" do
      input = "texas-holdem 5c6dAcAsQs Ks4c KdJs 2hAh Kh4h Kc7h 6h7d 2cJc"

      [board_cards | hands] = [
        ["5": :clubs, "6": :diamonds, A: :clubs, A: :spades, Q: :spades],

        [K: :spades, "4": :clubs],
        [K: :diamonds, J: :spades],
        ["2": :hearts, A: :hearts],
        [K: :hearts, "4": :hearts],
        [K: :clubs, "7": :hearts],
        ["6": :hearts, "7": :diamonds],
        ["2": :clubs, J: :clubs]
      ] |> Enum.map(&HelperFunctions.pairs_to_cards/1)

      expected_gamestate = %Game{
        type: :texas_holdem,
        board_cards: board_cards,
        hands: hands
      }

      assert Parser.parse(input) == {:ok, expected_gamestate}
    end

    test "omaha-holdem" do
      input = "omaha-holdem 4s5hTsQh9h Qc8d7cTcJd 5s5d7s4dQd 3cKs4cKdJs 2hAhKh4hKc 7h6h7d2cJc As6d5cQsAc"

      [board_cards | hands] =
        [
          ["4": :spades, "5": :hearts, T: :spades, Q: :hearts, "9": :hearts],

          [Q: :clubs, "8": :diamonds, "7": :clubs, T: :clubs, J: :diamonds],
          ["5": :spades, "5": :diamonds, "7": :spades, "4": :diamonds, Q: :diamonds],
          ["3": :clubs, K: :spades, "4": :clubs, K: :diamonds, J: :spades],
          ["2": :hearts, A: :hearts, K: :hearts, "4": :hearts, K: :clubs],
          ["7": :hearts, "6": :hearts, "7": :diamonds, "2": :clubs, J: :clubs],
          [A: :spades, "6": :diamonds, "5": :clubs, Q: :spades, A: :clubs]
        ] |> Enum.map(&HelperFunctions.pairs_to_cards/1)

      expected_gamestate = %Game{
        type: :omaha_holdem,
        board_cards: board_cards,
        hands: hands
      }

      assert Parser.parse(input) == {:ok, expected_gamestate}
    end

    test "five-card-draw" do
      input = "five-card-draw 5c6dAcAsQs TsQh9hQc 8d7cTcJd 5s5d7s4d Qd3cKs4c KdJs2hAh Kh4hKc7h 6h7d2cJc"

      hands = [
        ["5": :clubs, "6": :diamonds, A: :clubs, A: :spades, Q: :spades],
        [T: :spades, Q: :hearts, "9": :hearts, Q: :clubs],
        ["8": :diamonds, "7": :clubs, T: :clubs, J: :diamonds],
        ["5": :spades, "5": :diamonds, "7": :spades, "4": :diamonds],
        [Q: :diamonds, "3": :clubs, K: :spades, "4": :clubs],
        [K: :diamonds, J: :spades, "2": :hearts, A: :hearts],
        [K: :hearts, "4": :hearts, K: :clubs, "7": :hearts],
        ["6": :hearts, "7": :diamonds, "2": :clubs, J: :clubs]
      ] |> Enum.map(&HelperFunctions.pairs_to_cards/1)

      expected_gamestate = %Game{
        type: :five_card_draw,
        board_cards: nil,
        hands: hands
      }

      assert Parser.parse(input) == {:ok, expected_gamestate}
    end
  end
end
