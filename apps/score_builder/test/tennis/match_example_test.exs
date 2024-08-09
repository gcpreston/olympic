defmodule Tennis.MatchExampleTest do
  use ExUnit.Case

  alias Tennis.MatchExample
  alias Tennis.SetExample
  alias Tennis.Game

  describe "Match" do
    @set_almost_finished {[4, 5], Game.new()}

    test "new/0 initializes correctly" do
      assert MatchExample.new() == {[0, 0], SetExample.new()}
    end

    test "next_state/2 handles set win" do
      assert {[0, 0], @set_almost_finished}
             |> MatchExample.next_state(1)
             |> MatchExample.next_state(1)
             |> MatchExample.next_state(1)
             |> MatchExample.next_state(1) == {[0, 1], SetExample.new()}
    end

    test "next_state/2 handles match win" do
      assert {[1, 1], @set_almost_finished}
             |> MatchExample.next_state(1)
             |> MatchExample.next_state(1)
             |> MatchExample.next_state(1)
             |> MatchExample.next_state(1) == {:win, 1}
    end
  end
end
