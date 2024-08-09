defmodule Tennis.Set do
  alias Tennis.Game
  alias Tennis.Tiebreak

  @type score() :: 0..5
  @type state() :: {{score(), score()}, Game.state()} | {:tiebreak, Tiebreak.state()}
  @type initial_state :: {{0, 0}, Game.initial_state()}
  # TODO: Stop redefining
  @type player() :: :p1 | :p2

  @spec new() :: initial_state()
  def new, do: {{0, 0}, Game.new()}

  # tiebreak entry states
  defp game_win({5, 6}, :p1), do: {:tiebreak, Tiebreak.new()}
  defp game_win({6, 5}, :p2), do: {:tiebreak, Tiebreak.new()}

  # win states
  defp game_win({5, p2}, :p1) when p2 <= 4, do: {:win, :p1}
  defp game_win({p1, 5}, :p2) when p1 <= 4, do: {:win, :p2}

  # point increment states
  defp game_win({p1_score, p2_score}, :p1), do: {{p1_score + 1, p2_score}, Game.new()}
  defp game_win({p1_score, p2_score}, :p2), do: {{p1_score, p2_score + 1}, Game.new()}

  @spec next_state(state(), player()) :: state() | {:win, player()}
  def next_state({:tiebreak, tiebreak_state}, :p1) do
    case Tiebreak.next_state(tiebreak_state, 0) do
      {:win, 0} -> {:win, :p1}
      next_tiebreak_state -> {:tiebreak, next_tiebreak_state}
    end
  end

  def next_state({:tiebreak, tiebreak_state}, :p2) do
    case Tiebreak.next_state(tiebreak_state, 1) do
      {:win, 1} -> {:win, :p2}
      next_tiebreak_state -> {:tiebreak, next_tiebreak_state}
    end
  end

  def next_state({set_score, game_state}, player) do
    case Game.next_state(game_state, player) do
      {:win, winner} -> game_win(set_score, winner)
      new_game_state -> {set_score, new_game_state}
    end
  end
end
