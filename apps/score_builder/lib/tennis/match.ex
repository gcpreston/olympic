defmodule Tennis.Match do
  alias Tennis.Set

  @type score() :: 0..1
  @type state() :: {{score(), score()}, Set.state()}
  @type initial_state :: {{0, 0}, Set.initial_state()}
  # TODO: Stop redefining
  @type player() :: :p1 | :p2

  @spec new() :: initial_state()
  def new, do: {{0, 0}, Set.new()}

  defp set_win({1, _}, :p1), do: {:win, :p1}
  defp set_win({_, 1}, :p2), do: {:win, :p2}
  defp set_win({p1_score, p2_score}, :p1), do: {{p1_score + 1, p2_score}, Set.new()}
  defp set_win({p1_score, p2_score}, :p2), do: {{p1_score, p2_score + 1}, Set.new()}

  @spec next_state(state(), player()) :: state() | {:win, player()}
  def next_state({match_score, set_state}, player) do
    case Set.next_state(set_state, player) do
      {:win, winner} -> set_win(match_score, winner)
      new_set_state -> {match_score, new_set_state}
    end
  end
end
