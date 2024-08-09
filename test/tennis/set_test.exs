defmodule Tennis.SetTest do
  use ExUnit.Case

  alias Tennis.Set
  alias Tennis.Game
  alias Tennis.Tiebreak

  describe "Set" do
    test "new/0 initializes correctly" do
      assert Set.new() == {{0, 0}, Game.new()}
    end

    test "next_state/2 handles game win" do
      assert Set.new()
             |> Set.next_state(:p1)
             |> Set.next_state(:p1)
             |> Set.next_state(:p1)
             |> Set.next_state(:p1) == {{1, 0}, Game.new()}
    end

    test "next_state/2 handles set win" do
      assert {{4, 5}, Game.new()}
             |> Set.next_state(:p2)
             |> Set.next_state(:p2)
             |> Set.next_state(:p2)
             |> Set.next_state(:p2) == {:win, :p2}
    end

    test "next_state/2 does not give set win on 6-5" do
      assert {{5, 5}, Game.new()}
             |> Set.next_state(:p1)
             |> Set.next_state(:p1)
             |> Set.next_state(:p1)
             |> Set.next_state(:p1) == {{6, 5}, Game.new()}

      assert {{5, 5}, Game.new()}
             |> Set.next_state(:p2)
             |> Set.next_state(:p2)
             |> Set.next_state(:p2)
             |> Set.next_state(:p2) == {{5, 6}, Game.new()}
    end

    test "next_state/2 enters tiebreak" do
      assert {{5, 6}, Game.new()}
             |> Set.next_state(:p1)
             |> Set.next_state(:p1)
             |> Set.next_state(:p1)
             |> Set.next_state(:p1) == {:tiebreak, Tiebreak.new()}
    end

    test "next_state/2 goes through tiebreak" do
      assert {:tiebreak, Tiebreak.new()}
             |> Set.next_state(:p2)
             |> Set.next_state(:p2)
             |> Set.next_state(:p2)
             |> Set.next_state(:p2)
             |> Set.next_state(:p2)
             |> Set.next_state(:p2)
             |> Set.next_state(:p2) == {:win, :p2}

      assert {:tiebreak, [5, 6]}
             |> Set.next_state(:p1)
             |> Set.next_state(:p1)
             |> Set.next_state(:p2)
             |> Set.next_state(:p1)
             |> Set.next_state(:p1) == {:win, :p1}
    end
  end
end
