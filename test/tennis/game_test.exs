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
      assert Game.new() == {:regular, {0, 0}}
    end

    test "next_state/2 increments scores correctly" do
      Enum.each([0, 15, 30], fn score ->
        assert Game.next_state({:regular, {0, score}}, :p1) == {:regular, {15, score}}
        assert Game.next_state({:regular, {15, score}}, :p1) == {:regular, {30, score}}
        assert Game.next_state({:regular, {30, score}}, :p1) == {:regular, {40, score}}

        assert Game.next_state({:regular, {score, 0}}, :p2) == {:regular, {score, 15}}
        assert Game.next_state({:regular, {score, 15}}, :p2) == {:regular, {score, 30}}
        assert Game.next_state({:regular, {score, 30}}, :p2) == {:regular, {score, 40}}
      end)
    end

    test "next_state/2 enters deuce states correctly" do
      assert Game.next_state({:regular, {30, 40}}, :p1) == {:deuce, Deuce.new()}
      assert Game.next_state({:regular, {40, 30}}, :p2) == {:deuce, Deuce.new()}
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
