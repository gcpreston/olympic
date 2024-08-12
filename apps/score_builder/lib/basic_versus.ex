defmodule BasicVersus do
  defmacro __using__(sub_versus: sub_versus, winning_score: winning_score, win_differential: win_differential, tiebreak_versus: tiebreak_versus) do
    common_ast =
      quote do
        defp win(scores, point_winner) do
          winner_new_score = Enum.at(scores, point_winner) + 1
          new_scores = List.replace_at(scores, point_winner, winner_new_score)
          opponent = 1 - point_winner
          opponent_score = Enum.at(scores, opponent)

          cond do
            winner_new_score == unquote(winning_score) && winner_new_score - opponent_score >= unquote(win_differential) ->
              {:win, point_winner}

            winner_new_score == unquote(winning_score) && opponent_score == unquote(winning_score) ->
              {:tiebreak, apply(unquote(tiebreak_versus), :new, [])}

            true ->
              unless is_nil(unquote(sub_versus)) do
                {new_scores, apply(unquote(sub_versus), :new, [])}
              else
                new_scores
              end
          end
        end
      end

    specific_ast =
      if is_nil(sub_versus) do
        quote do
          def new, do: [0, 0]

          def next_state({:tiebreak, tiebreak_state}, point_winner) do
            case apply(unquote(tiebreak_versus), :next_state, [tiebreak_state, point_winner]) do
              {:win, _winner} = result -> result
              next_tiebreak_state -> {:tiebreak, next_tiebreak_state}
            end
          end

          def next_state(score, point_winner) do
            win(score, point_winner)
          end
        end
      else
        quote do
          def new, do: {[0, 0], apply(unquote(sub_versus), :new, [])}

          def next_state({:tiebreak, tiebreak_state}, point_winner) do
            case apply(unquote(tiebreak_versus), :next_state, [tiebreak_state, point_winner]) do
              {:win, _winner} = result -> result
              next_tiebreak_state -> {:tiebreak, next_tiebreak_state}
            end
          end

          def next_state({score, sub_state}, point_winner) do
            case apply(unquote(sub_versus), :next_state, [sub_state, point_winner]) do
              {:win, winner} -> win(score, winner)
              new_sub_state -> {score, new_sub_state}
            end
          end
        end
      end

    [common_ast, specific_ast]
  end
end
