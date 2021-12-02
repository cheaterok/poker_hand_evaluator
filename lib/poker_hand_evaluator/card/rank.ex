defmodule PokerHandEvaluator.Card.Rank do
  @moduledoc false

  require TypeUnion

  @ranks ~w[2 3 4 5 6 7 8 9 T J Q K A]a
  TypeUnion.type :t, @ranks

  ranks2values = Enum.with_index(@ranks, 1)

  TypeUnion.typep :values, Keyword.values(ranks2values)

  @spec ranks() :: [t(), ...]
  def ranks, do: @ranks

  @spec value(t()) :: values()
  def value(rank)

  for {rank, value} <- ranks2values do
    def value(unquote(rank)), do: unquote(value)
  end

  ranks2strings = Enum.map(@ranks, fn rank -> {rank, Atom.to_string(rank)} end)

  @spec from_string(String.t()) :: {:ok, t()} | :error
  def from_string(rank_s)

  for {rank, rank_s} <- ranks2strings do
    def from_string(unquote(rank_s)), do: {:ok, unquote(rank)}
  end

  def from_string(_), do: :error

  @spec to_string(t()) :: String.t()
  def to_string(rank)

  for {rank, rank_s} <- ranks2strings do
    def to_string(unquote(rank)), do: unquote(rank_s)
  end
end
