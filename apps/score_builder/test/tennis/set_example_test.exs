defmodule Tennis.SetExampleTest do
  use ExUnit.Case

  alias Tennis.SetExample
  alias Tennis.Game
  alias Tennis.Tiebreak

  describe "Set" do
    test "new/0 initializes correctly" do
      assert SetExample.new() == {[0, 0], Game.new()}
    end

    test "next_state/2 handles game win" do
      assert SetExample.new()
             |> SetExample.next_state(0)
             |> SetExample.next_state(0)
             |> SetExample.next_state(0)
             |> SetExample.next_state(0) == {[1, 0], Game.new()}
    end

    test "next_state/2 handles set win" do
      assert {[4, 5], Game.new()}
             |> SetExample.next_state(1)
             |> SetExample.next_state(1)
             |> SetExample.next_state(1)
             |> SetExample.next_state(1) == {:win, 1}
    end

    test "next_state/2 does not give set win on 6-5" do
      assert {[5, 5], Game.new()}
             |> SetExample.next_state(0)
             |> SetExample.next_state(0)
             |> SetExample.next_state(0)
             |> SetExample.next_state(0) == {[6, 5], Game.new()}

      assert {[5, 5], Game.new()}
             |> SetExample.next_state(1)
             |> SetExample.next_state(1)
             |> SetExample.next_state(1)
             |> SetExample.next_state(1) == {[5, 6], Game.new()}
    end

    test "next_state/2 enters tiebreak" do
      assert {[5, 6], Game.new()}
             |> SetExample.next_state(0)
             |> SetExample.next_state(0)
             |> SetExample.next_state(0)
             |> SetExample.next_state(0) == {:tiebreak, Tiebreak.new()}
    end

    test "next_state/2 goes through tiebreak" do
      assert {:tiebreak, Tiebreak.new()}
             |> SetExample.next_state(1)
             |> SetExample.next_state(1)
             |> SetExample.next_state(1)
             |> SetExample.next_state(1)
             |> SetExample.next_state(1)
             |> SetExample.next_state(1)
             |> SetExample.next_state(1) == {:win, 1}

      assert {:tiebreak, [5, 6]}
             |> SetExample.next_state(0)
             |> SetExample.next_state(0)
             |> SetExample.next_state(1)
             |> SetExample.next_state(0)
             |> SetExample.next_state(0) == {:win, 0}
    end
  end
end
