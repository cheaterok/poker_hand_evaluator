defmodule PokerHandEvaluator.Parser do
  @moduledoc false

  alias PokerHandEvaluator.{Game, Card}

  use TypeUnion

  @parsing_errors ~w[
    invalid_game_type
    invalid_board_cards
    invalid_hands
  ]a
  typeunion(:parsing_error, @parsing_errors)

  @spec parse(String.t()) :: {:ok, Game.t()} | {:error, parsing_error()}
  def parse(input) do
    elements = String.split(input)

    with {:ok, game_type, elements} <- parse_game_type(elements),
         {:ok, board_cards, elements} <- parse_board_cards(elements, game_type),
         {:ok, hands} <- parse_hands(elements)
    do
      game = %Game{
        type: game_type,
        board_cards: board_cards,
        hands: hands
      }
      {:ok, game}
    end
  end

  defp parse_game_type(elements) do
    with [game_type_s | elements] <- elements,
         {:ok, game_type} <- Game.type_from_string(game_type_s)
    do
      {:ok, game_type, elements}
    else
      _ -> {:error, :invalid_game_type}
    end
  end

  defp parse_board_cards(elements, :five_card_draw) do
    {:ok, nil, elements}
  end

  defp parse_board_cards(elements, _game_type) do
    with [board_cards_s | elements] <- elements,
         {:ok, board_cards} <- parse_hand(board_cards_s)
    do
      {:ok, board_cards, elements}
    else
      _ -> {:error, :invalid_board_cards}
    end
  end

  defp parse_hands(elements) do
    case try_map(elements, &parse_hand/1) do
      {:ok, _hands} = v -> v
      :error -> {:error, :invalid_hands}
    end
  end

  defp parse_hand(hand_s) do
    hand_s
    |> String.codepoints()
    |> Stream.chunk_every(2)
    |> try_map(&parse_card/1)
  end

  defp parse_card(input) do
    with [rank_s, suit_s] <- input,
         {:ok, rank} <- Card.Rank.from_string(rank_s),
         {:ok, suit} <- Card.Suit.from_string(suit_s)
    do
      {:ok, %Card{rank: rank, suit: suit}}
    else
      _ -> :error
    end
  end

  defp try_map(enumerable, function) do
    reducer = fn element, acc ->
      case function.(element) do
        {:ok, result} -> {:cont, [result | acc]}
        :error -> {:halt, :error}
      end
    end

    result = Enum.reduce_while(enumerable, [], reducer)
    case result do
      :error -> :error
      list -> {:ok, Enum.reverse(list)}
    end
  end
end
