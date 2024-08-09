defmodule Tennis.GameTest do
  use ExUnit.Case

  alias Tennis.Game
  alias Tennis.Game.Deuce

  describe "Deuce" do
    test "new/0 initializes correctly" do
      assert Deuce.new() == :"40-40"
    end

    test "next_state/2 transitions between continue states" do
      assert Deuce.next_state(:"40-40", :p1) == :"ad-40"
      assert Deuce.next_state(:"ad-40", :p2) == :"40-40"
      assert Deuce.next_state(:"40-ad", :p1) == :"40-40"
    end

    test "next_state/2 transitions to win states" do
      assert Deuce.next_state(:"ad-40", :p1) == {:win, :p1}
      assert Deuce.next_state(:"40-ad", :p2) == {:win, :p2}
    end
  end

  describe "Game" do
    test "new/0 initializes correctly" do
      assert Game.new() == {0, 0}
    end

    test "next_state/2 increments scores correctly" do
      Enum.each([0, 1, 2], fn score ->
        assert Game.next_state({0, score}, :p1) == {1, score}
        assert Game.next_state({1, score}, :p1) == {2, score}
        assert Game.next_state({2, score}, :p1) == {3, score}

        assert Game.next_state({score, 0}, :p2) == {score, 1}
        assert Game.next_state({score, 1}, :p2) == {score, 2}
        assert Game.next_state({score, 2}, :p2) == {score, 3}
      end)
    end

    test "next_state/2 wins non-deuce games correctly" do
      Enum.each([0, 1, 2], fn score ->
        assert Game.next_state({3, score}, :p1) == {:win, :p1}
        assert Game.next_state({score, 3}, :p2) == {:win, :p2}
      end)
    end

    test "next_state/2 enters deuce states correctly" do
      assert Game.next_state({2, 3}, :p1) == {:deuce, Deuce.new()}
      assert Game.next_state({3, 2}, :p2) == {:deuce, Deuce.new()}
    end

    test "next_state/2 transitions through deuce states correctly" do
      return_to_deuce =
        {:deuce, Deuce.new()}
        |> Game.next_state(:p1)
        |> Game.next_state(:p2)

      assert return_to_deuce == {:deuce, Deuce.new()}

      p1_win =
        return_to_deuce
        |> Game.next_state(:p1)
        |> Game.next_state(:p1)

      assert p1_win == {:win, :p1}
    end
  end
end
