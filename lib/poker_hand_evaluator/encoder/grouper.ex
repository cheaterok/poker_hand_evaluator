defmodule PokerHandEvaluator.Encoder.Grouper do
  @moduledoc false

  @typep element ::
    PokerHandEvaluator.hand_to_value() |
    [PokerHandEvaluator.hand_to_value()]

  @spec group_equal([PokerHandEvaluator.hand_to_value()]) :: [element()]
  def group_equal(hands_to_values) do
    hands_to_values
    |> Enum.reverse()
    |> Enum.reduce([], &add_element/2)
  end

  defp add_element(element, []),
    do: [element]

  defp add_element(element, [head | tail] = list) do
    group? = is_list(head)
    previous_element = if group?, do: hd(head), else: head

    if equal?(element, previous_element) do
      new_group = if group?, do: [element | head], else: [element, head]
      [new_group | tail]
    else
      [element | list]
    end
  end

  defp equal?({_hand_1, value_1}, {_hand_2, value_2}),
    do: value_1 == value_2
end
