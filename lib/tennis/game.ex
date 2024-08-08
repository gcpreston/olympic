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

  @type score() :: 0 | 15 | 30 | 40
  # TODO: except 40-40
  @type regular_state() :: {:regular, {score(), score()}}
  @type deuce_state() :: {:deuce, Deuce.state()}
  @type state() :: regular_state() | deuce_state()
  @type initial_state() :: {:regular, {0, 0}}
  @type player() :: :p1 | :p2

  @spec new() :: initial_state()
  def new, do: {:regular, {0, 0}}

  @spec next_state(state(), player()) :: state() | {:win, player()}

  # TODO: I don't totally like this...wish I could send through directly
  def next_state({:deuce, deuce_state}, player) do
    case Deuce.next_state(deuce_state, player) do
      {:win, winner} -> {:win, winner}
      new_deuce_state -> {:deuce, new_deuce_state}
    end
  end

  def next_state({:regular, {30, 40}}, :p1), do: {:deuce, Deuce.new()}
  def next_state({:regular, {40, 30}}, :p2), do: {:deuce, Deuce.new()}

  def next_state({:regular, {0, p2}}, :p1), do: {:regular, {15, p2}}
  def next_state({:regular, {15, p2}}, :p1), do: {:regular, {30, p2}}
  def next_state({:regular, {30, p2}}, :p1), do: {:regular, {40, p2}}
  def next_state({:regular, {40, _p2}}, :p1), do: {:win, :p1}

  def next_state({:regular, {p1, 0}}, :p2), do: {:regular, {p1, 15}}
  def next_state({:regular, {p1, 15}}, :p2), do: {:regular, {p1, 30}}
  def next_state({:regular, {p1, 30}}, :p2), do: {:regular, {p1, 40}}
  def next_state({:regular, {_p1, 40}}, :p2), do: {:win, :p2}
end
