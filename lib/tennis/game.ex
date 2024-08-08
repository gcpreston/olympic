defmodule Tennis.Game do
  @moduledoc """
  Model for a single game of tennis.
  """

  @type score() :: 0 | 15 | 30 | 40
  @type regular_state() :: {:regular, {score(), score()}} # TODO: except 40-40
  @type deuce_state() :: {:deuce, Deuce.state()}
  @type state() :: regular_state() | deuce_state()
  @type player() :: :p1 | :p2

  @spec new() :: {:regular, {0, 0}}
  def new, do: {:regular, {0, 0}}

  @spec next_state(state(), player()) :: {:cont, state()} | {:win, player()}

  def next_state({:deuce, deuce_state}, player), do: Deuce.next_state(deuce_state, player)
  def next_state({:regular, {30, 40}}, :p1), do: {:deuce, Deuce.new()}
  def next_state(:regular, {40, 30}, :p2), do: {:deuce, Deuce.new()}

  def next_state({:regular, {0, p2}}, :p1), do: {:regular, {15, p2}}
  def next_state({:regular, {15, p2}}, :p1), do: {:regular, {30, p2}}
  def next_state({:regular, {30, p2}}, :p1), do: {:regular, 40, p2}
  def next_state({:regular, {40, _p2}}, :p1), do: {:win, :p1}

  def next_state({:regular, {p1, 0}}, :p2), do: {:regular, {p1, 15}}
  def next_state({:regular, {p1, 15}}, :p2), do: {:regular, {p1, 30}}
  def next_state({:regular, {p1, 30}}, :p2), do: {:regular, {p1, 40}}
  def next_state({:regular, {_p1, 40}}, :p2), do: {:win, :p2}

  defmodule Deuce do
    @type state() :: :"40-40" | :"ad-40" | :"40-ad"
    @type player() :: :p1 | :p2

    @spec new() :: :"40-40"
    def new, do: :"40-40"

    @spec next_state(state(), player()) :: {:cont, state()} | {:win, player()}

    def next_state(:"40-40", :p1), do: {:cont, :"ad-40"}
    def next_state(:"40-40", :p2), do: {:cont, :"40-ad"}
    def next_state(:"ad-40", :p1), do: {:win, :p1}
    def next_state(:"ad-40", :p2), do: {:cont, :"40-40"}
    def next_state(:"40-ad", :p1), do: {:cont, :"40-40"}
    def next_state(:"40-ad", :p2), do: {:win, :p2}
  end
end
