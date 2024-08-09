defmodule Tennis.TiebreakTest do
  use ExUnit.Case

  alias Tennis.Tiebreak

  describe "Tiebreak" do
    test "new/0 initializes correctly" do
      assert Tiebreak.new() == [0, 0]
    end

    test "next_state/2 increments for win" do
      t =
        Tiebreak.new()
        |> Tiebreak.next_state(0)
        |> Tiebreak.next_state(0)
        |> Tiebreak.next_state(1)

      assert t == [2, 1]

      assert t
             |> Tiebreak.next_state(0)
             |> Tiebreak.next_state(0)
             |> Tiebreak.next_state(0)
             |> Tiebreak.next_state(0)
             |> Tiebreak.next_state(0) == {:win, 0}
    end

    test "next_state/2 must win by 2" do
      assert Tiebreak.next_state([5, 6], 1) == {:win, 1}
      assert Tiebreak.next_state([6, 6], 1) == [6, 7]
      assert Tiebreak.next_state([8, 8], 0) == [9, 8]
      assert Tiebreak.next_state([12, 11], 0) == {:win, 0}
    end
  end
end
