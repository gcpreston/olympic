defmodule Tennis.Deuce do
  @type state() :: :"40-40" | :"ad-40" | :"40-ad"

  @spec new() :: :"40-40"
  def new, do: :"40-40"

  @spec next_state(state(), Tennis.player()) :: state() | {:win, Tennis.player()}
  def next_state(:"40-40", 0), do: :"ad-40"
  def next_state(:"40-40", 1), do: :"40-ad"
  def next_state(:"ad-40", 0), do: {:win, 0}
  def next_state(:"ad-40", 1), do: :"40-40"
  def next_state(:"40-ad", 0), do: :"40-40"
  def next_state(:"40-ad", 1), do: {:win, 1}
end
