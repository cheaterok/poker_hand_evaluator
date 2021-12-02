defmodule PokerHandEvaluator.Game do
  @moduledoc false

  alias PokerHandEvaluator.Card

  require TypeUnion

  use DryStruct

  @game_types ~w[texas_holdem omaha_holdem five_card_draw]a
  TypeUnion.type :type, @game_types

  @type cards() :: nonempty_list(Card.t())

  drystruct enforce: true do
    field :type, type()
    field :board_cards, cards(), enforce: false
    field :hands, [cards()]
  end

  @spec type_from_string(String.t()) :: {:ok, type()} | :error
  def type_from_string(type_s)

  for type <- @game_types do
    type_s = type |> Atom.to_string() |> String.replace("_", "-")
    def type_from_string(unquote(type_s)), do: {:ok, unquote(type)}
  end

  def type_from_string(_), do: :error
end
