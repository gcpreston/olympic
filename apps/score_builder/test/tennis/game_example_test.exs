defmodule Tennis.GameExampleTest do
  use ExUnit.Case

  alias Tennis.GameExample
  alias Tennis.Deuce

  describe "Game" do
    test "new/0 initializes correctly" do
      assert GameExample.new() == [0, 0]
    end

    test "next_state/2 increments scores correctly" do
      Enum.each([0, 1, 2], fn score ->
        assert GameExample.next_state([0, score], 0) == [1, score]
        assert GameExample.next_state([1, score], 0) == [2, score]
        assert GameExample.next_state([2, score], 0) == [3, score]

        assert GameExample.next_state([score, 0], 1) == [score, 1]
        assert GameExample.next_state([score, 1], 1) == [score, 2]
        assert GameExample.next_state([score, 2], 1) == [score, 3]
      end)
    end

    test "next_state/2 wins non-deuce games correctly" do
      Enum.each([0, 1, 2], fn score ->
        assert GameExample.next_state([3, score], 0) == {:win, 0}
        assert GameExample.next_state([score, 3], 1) == {:win, 1}
      end)
    end

    test "next_state/2 enters deuce states correctly" do
      assert GameExample.next_state([2, 3], 0) == {:deuce, Deuce.new()}
      assert GameExample.next_state([3, 2], 1) == {:deuce, Deuce.new()}
    end

    test "next_state/2 transitions through deuce states correctly" do
      return_to_deuce =
        {:deuce, Deuce.new()}
        |> GameExample.next_state(0)
        |> GameExample.next_state(1)

      assert return_to_deuce == {:deuce, Deuce.new()}

      p1_win =
        return_to_deuce
        |> GameExample.next_state(0)
        |> GameExample.next_state(0)

      assert p1_win == {:win, 0}
    end
  end
end
