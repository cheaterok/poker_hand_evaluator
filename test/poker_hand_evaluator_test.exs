defmodule PokerHandEvaluatorTest do
  use ExUnit.Case

  inputs = [
    texas_holdem: [
      {
        "texas-holdem 5c6dAcAsQs Ks4c KdJs 2hAh Kh4h Kc7h 6h7d 2cJc",
        "2cJc Kh4h=Ks4c Kc7h KdJs 6h7d 2hAh"
      },
      {
        "texas-holdem 2h5c8sAsKc Qs9h KdQh 3cKh Jc6s",
        "Jc6s Qs9h 3cKh KdQh"
      },
      {
        "texas-holdem 3d4s5dJsQd 5c4h 7sJd KcAs 9h7h 2dTc Qh8c TsJc",
        "9h7h 2dTc KcAs 7sJd TsJc Qh8c 5c4h"
      },
      {
        "texas-holdem 4cKs4h8s7s Ad4s Ac4d As9s KhKd 5d6d",
        "Ac4d=Ad4s 5d6d As9s KhKd"
      },
      {
        "texas-holdem 2h3h4h5d8d KdKs 9hJh",
        "KdKs 9hJh"
      }
    ],
    omaha_holdem: [
      {
        "omaha-holdem 5c6dAcAsQs TsQh9hQc 8d7cTcJd 5s5d7s4d Qd3cKs4c KdJs2hAh Kh4hKc7h 6h7d2cJc",
        "8d7cTcJd 6h7d2cJc Qd3cKs4c Kh4hKc7h KdJs2hAh 5s5d7s4d TsQh9hQc"
      },
      {
        "omaha-holdem 3d4s5dJsQd 8s2h6s8h 7cThKs5s 5hJh2s7d 8d9s5c4h 7sJdKcAs 9h7h2dTc Qh8cTsJc",
        "9h7h2dTc 7cThKs5s 7sJdKcAs 8d9s5c4h 5hJh2s7d Qh8cTsJc 8s2h6s8h"
      },
      {
        "omaha-holdem 3d3s4d6hJc Js2dKd8c KsAsTcTs Jh2h3c9c Qc8dAd6c 7dQsAc5d",
        "Qc8dAd6c KsAsTcTs Js2dKd8c 7dQsAc5d Jh2h3c9c"
      },
      {
        "omaha-holdem 3d3s4d6hJc Js2dKd8c KsAsTcTs Jh2h3c9c Qc8dAd6c 7dQsAc5d",
        "Qc8dAd6c KsAsTcTs Js2dKd8c 7dQsAc5d Jh2h3c9c"
      }
    ],
    five_card_draw: [
      {
        "five-card-draw 4s5hTsQh9h Qc8d7cTcJd 5s5d7s4dQd 3cKs4cKdJs 2hAhKh4hKc 7h6h7d2cJc As6d5cQsAc",
        "4s5hTsQh9h Qc8d7cTcJd 5s5d7s4dQd 7h6h7d2cJc 3cKs4cKdJs 2hAhKh4hKc As6d5cQsAc"
      },
      {
        "five-card-draw 7h4s4h8c9h Tc5h6dAc5c Kd9sAs3cQs Ah9d6s2cKh 4c8h2h6c9c",
        "4c8h2h6c9c Ah9d6s2cKh Kd9sAs3cQs 7h4s4h8c9h Tc5h6dAc5c"
      },
      {
        "five-card-draw 5s3s4c2h9d 8dKsTc6c2c 4h6s8hJd5d 5c3cQdTd9s AhQhKcQc2d KhJs9c5h9h 8c3d7h7dTs",
        "5s3s4c2h9d 4h6s8hJd5d 5c3cQdTd9s 8dKsTc6c2c 8c3d7h7dTs KhJs9c5h9h AhQhKcQc2d"
      },
      {
        "five-card-draw 7h4s4h8c9h Tc5h6dAc5c Kd9sAs3cQs Ah9d6s2cKh 4c8h2h6c9c",
        "4c8h2h6c9c Ah9d6s2cKh Kd9sAs3cQs 7h4s4h8c9h Tc5h6dAc5c"
      }
    ]
  ]

  code =
    for {poker_type, pairs} <- inputs do
      tests =
        for {{input, output}, index} <- Enum.with_index(pairs, 1) do
          quote do
            test unquote(index) do
              assert PokerHandEvaluator.process(unquote(input)) == unquote(output)
            end
          end
        end

      poker_type = Atom.to_string(poker_type)
      quote do
        describe unquote(poker_type) do
          unquote_splicing(tests)
        end
      end
    end

  Module.eval_quoted(__ENV__, code)
end
