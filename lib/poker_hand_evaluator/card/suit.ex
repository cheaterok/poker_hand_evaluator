defmodule PokerHandEvaluator.Card.Suit do
  @moduledoc false

  require TypeUnion

  @suits ~w[diamonds clubs hearts spades]a
  TypeUnion.type :t, @suits

  suits2strings = Enum.map(@suits, &{&1, &1 |> Atom.to_string() |> String.first()})

  @spec suits() :: [t(), ...]
  def suits, do: @suits

  @spec from_string(String.t()) :: {:ok, t()} | :error
  def from_string(suit_s)

  for {suit, suit_s} <- suits2strings do
    def from_string(unquote(suit_s)), do: {:ok, unquote(suit)}
  end

  def from_string(_), do: :error

  @spec to_string(t()) :: String.t()
  def to_string(suit)

  for {suit, suit_s} <- suits2strings do
    def to_string(unquote(suit)), do: unquote(suit_s)
  end
end
