defmodule Tennis.Tiebreak do
  @type score() :: 0..6
  # TODO: Exactly 2 elements
  @type state() :: [score()]
  @type initial_state() :: {0, 0}
  @type player() :: 0..1

  @spec new() :: initial_state()
  def new, do: [0, 0]

  @spec next_state(state(), player()) :: state() | {:win, player()}
  def next_state(scores, point_winner) do
    winner_new_score = Enum.at(scores, point_winner) + 1
    new_scores = List.replace_at(scores, point_winner, winner_new_score)
    # TODO: Give name (function)
    opponent = 1 - point_winner
    opponent_score = Enum.at(scores, opponent)

    if winner_new_score >= 7 && winner_new_score - opponent_score >= 2 do
      {:win, point_winner}
    else
      new_scores
    end
  end
end
