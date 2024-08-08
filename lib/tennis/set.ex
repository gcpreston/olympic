defmodule Tennis.Set do
  alias Tennis.Game

  # TODO: Refine for tiebreak
  @type score() :: 0..5
  @type state() :: {{score(), score()}, Game.state()}
  @type initial_state :: {{0, 0}, Game.initial_state()}
  # TODO: Stop redefining
  @type player() :: :p1 | :p2

  @spec new() :: initial_state()
  def new, do: {{0, 0}, Game.new()}

  defp game_win({5, _}, :p1), do: {:win, :p1}
  defp game_win({_, 5}, :p2), do: {:win, :p2}
  defp game_win({p1_score, p2_score}, :p1), do: {{p1_score + 1, p2_score}, Game.new()}
  defp game_win({p1_score, p2_score}, :p2), do: {{p1_score, p2_score + 1}, Game.new()}

  @spec next_state(state(), player()) :: state() | {:win, player()}
  def next_state({set_score, game_state}, player) do
    case Game.next_state(game_state, player) do
      {:win, winner} -> game_win(set_score, winner)
      new_game_state -> {set_score, new_game_state}
    end
  end
end
