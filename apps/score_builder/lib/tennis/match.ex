defmodule Tennis.Match do
  alias Tennis.Set

  @winning_score 2

  @type score() :: 0..1
  @type state() :: {[score()], Set.state()}
  @type initial_state :: {[0], Set.initial_state()}

  @spec new() :: initial_state()
  def new, do: {[0, 0], Set.new()}

  @spec next_state(state(), Tennis.player()) :: state() | {:win, Tennis.player()}
  def next_state({match_score, set_state}, point_winner) do
    case Set.next_state(set_state, point_winner) do
      {:win, winner} -> set_win(match_score, winner)
      new_set_state -> {match_score, new_set_state}
    end
  end

  defp set_win(scores, point_winner) do
    winner_new_score = Enum.at(scores, point_winner) + 1
    new_scores = List.replace_at(scores, point_winner, winner_new_score)

    if winner_new_score == @winning_score do
      {:win, point_winner}
    else
      {new_scores, Set.new()}
    end
  end
end
