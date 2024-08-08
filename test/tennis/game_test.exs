defmodule Tennis.GameTest do
  use ExUnit.Case

  alias Tennis.Game
  alias Tennis.Game.Deuce

  describe "Game" do
    test "new/0 initializes correctly" do
      assert Game.new() == {:regular, {0, 0}}
    end
  end

  describe "Deuce" do
    test "new/0 initializes correctly" do
      assert Deuce.new() == :"40-40"
    end
  end
end
