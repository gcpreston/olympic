defmodule Tennis.Game do
  @moduledoc """
  Model for a single game of tennis.
  """

  alias Tennis.Deuce

  @winning_score 4
  @win_differential 2

  @type score() :: 0..3
  # TODO: except {3, 3}
  @type state() :: [score()] | {:deuce, Deuce.state()}
  @type initial_state() :: [0]

  @spec new() :: initial_state()
  def new, do: [0, 0]

  @spec next_state(state(), Tennis.player()) :: state() | {:win, Tennis.player()}

  def next_state({:deuce, deuce_state}, point_winner) do
    case Deuce.next_state(deuce_state, point_winner) do
      {:win, _winner} = result -> result
      new_deuce_state -> {:deuce, new_deuce_state}
    end
  end

  def next_state(scores, point_winner) do
    winner_new_score = Enum.at(scores, point_winner) + 1
    new_scores = List.replace_at(scores, point_winner, winner_new_score)
    opponent = 1 - point_winner
    opponent_score = Enum.at(scores, opponent)

    cond do
      winner_new_score == @winning_score && winner_new_score - opponent_score >= @win_differential ->
        {:win, point_winner}

      winner_new_score == @winning_score - 1 && opponent_score == @winning_score - 1 ->
        {:deuce, Deuce.new()}

      true ->
        new_scores
    end
  end
end
