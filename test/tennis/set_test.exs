defmodule Tennis.SetTest do
  use ExUnit.Case

  alias Tennis.Set
  alias Tennis.Game

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
  end
end
