defmodule Tennis.Set do
  alias Tennis.Game
  alias Tennis.Tiebreak

  @winning_score 6
  @win_differential 2

  @type score() :: 0..6
  @type state() :: {[score()], Game.state()} | {:tiebreak, Tiebreak.state()}
  @type initial_state :: {[0], Game.initial_state()}

  @spec new() :: initial_state()
  def new, do: {[0, 0], Game.new()}

  @spec next_state(state(), Tennis.player()) :: state() | {:win, Tennis.player()}
  def next_state({:tiebreak, tiebreak_state}, point_winner) do
    case Tiebreak.next_state(tiebreak_state, point_winner) do
      {:win, _winner} = result -> result
      next_tiebreak_state -> {:tiebreak, next_tiebreak_state}
    end
  end

  def next_state({set_score, game_state}, point_winner) do
    case Game.next_state(game_state, point_winner) do
      {:win, winner} -> game_win(set_score, winner)
      new_game_state -> {set_score, new_game_state}
    end
  end

  defp game_win(scores, point_winner) do
    winner_new_score = Enum.at(scores, point_winner) + 1
    new_scores = List.replace_at(scores, point_winner, winner_new_score)
    opponent = 1 - point_winner
    opponent_score = Enum.at(scores, opponent)

    cond do
      winner_new_score == @winning_score && winner_new_score - opponent_score >= @win_differential ->
        {:win, point_winner}

      winner_new_score == @winning_score && opponent_score == @winning_score ->
        {:tiebreak, Tiebreak.new()}

      true ->
        {new_scores, Game.new()}
    end
  end
end
