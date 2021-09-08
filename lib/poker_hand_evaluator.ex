defmodule PokerHandEvaluator do
  @moduledoc false

  alias PokerHandEvaluator.{Parser, Game, Combinations, Encoder}

  @spec process(String.t()) :: String.t()
  def process(input) do
    {:ok, gamestate} = Parser.parse(input)

    hand_values = Enum.map(gamestate.hands, &calculate_hand_value(gamestate, &1))

    Encoder.encode(gamestate.hands, hand_values)
  end

  defp calculate_hand_value(%Game{type: :texas_holdem} = game, hand) do
    Combinations.calculate_hand_value(hand ++ game.board_cards)
  end
  defp calculate_hand_value(%Game{type: :five_card_draw}, hand) do
    Combinations.calculate_hand_value(hand)
  end
  defp calculate_hand_value(%Game{type: :omaha_holdem} = game, hand) do
    for board_cards <- combinations(game.board_cards, 3),
        hand <- combinations(hand, 2),
        reduce: nil
    do
      cur_max ->
        (hand ++ board_cards)
        |> Combinations.calculate_hand_value()
        |> max(cur_max)
    end
  end

  defp combinations(_, 0), do: [[]]
  defp combinations([], _), do: []
  defp combinations([h | t], count) do
    (for l <- combinations(t, count - 1), do: [h | l]) ++ combinations(t, count)
  end
end
