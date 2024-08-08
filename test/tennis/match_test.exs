defmodule Tennis.MatchTest do
  use ExUnit.Case

  alias Tennis.Match
  alias Tennis.Set
  alias Tennis.Game

  describe "Match" do
    @set_almost_finished {{4, 5}, Game.new()}

    test "new/0 initializes correctly" do
      assert Match.new() == {{0, 0}, Set.new()}
    end

    test "next_state/2 handles set win" do
      assert {{0, 0}, @set_almost_finished}
             |> Match.next_state(:p2)
             |> Match.next_state(:p2)
             |> Match.next_state(:p2)
             |> Match.next_state(:p2) == {{0, 1}, Set.new()}
    end

    test "next_state/2 handles match win" do
      assert {{1, 1}, @set_almost_finished}
             |> Match.next_state(:p2)
             |> Match.next_state(:p2)
             |> Match.next_state(:p2)
             |> Match.next_state(:p2) == {:win, :p2}
    end
  end
end
