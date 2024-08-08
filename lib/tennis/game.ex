defmodule Tennis.Game do
  @moduledoc """
  Model for a single game of tennis.
  """

  defmodule Deuce do
    @type state() :: :"40-40" | :"ad-40" | :"40-ad"
    @type player() :: :p1 | :p2

    @spec new() :: :"40-40"
    def new, do: :"40-40"

    @spec next_state(state(), player()) :: state() | {:win, player()}
    def next_state(:"40-40", :p1), do: :"ad-40"
    def next_state(:"40-40", :p2), do: :"40-ad"
    def next_state(:"ad-40", :p1), do: {:win, :p1}
    def next_state(:"ad-40", :p2), do: :"40-40"
    def next_state(:"40-ad", :p1), do: :"40-40"
    def next_state(:"40-ad", :p2), do: {:win, :p2}
  end

  @type score() :: 0..3
  # TODO: except {3, 3}
  @type state() :: {score(), score()} | {:deuce, Deuce.state()}
  @type initial_state() :: {0, 0}
  @type player() :: :p1 | :p2

  @spec new() :: initial_state()
  def new, do: {0, 0}

  @spec next_state(state(), player()) :: state() | {:win, player()}

  def next_state({:deuce, deuce_state}, player) do
    case Deuce.next_state(deuce_state, player) do
      {:win, winner} -> {:win, winner}
      new_deuce_state -> {:deuce, new_deuce_state}
    end
  end

  # deuce entry states
  def next_state({2, 3}, :p1), do: {:deuce, Deuce.new()}
  def next_state({3, 2}, :p2), do: {:deuce, Deuce.new()}

  # win states
  def next_state({3, _p2}, :p1), do: {:win, :p1}
  def next_state({_p1, 3}, :p2), do: {:win, :p2}

  # point increment states
  def next_state({p1, p2}, :p1), do: {p1 + 1, p2}
  def next_state({p1, p2}, :p2), do: {p1, p2 + 1}
end
