defmodule Tennis.DeuceTest do
  use ExUnit.Case

  alias Tennis.Deuce

  describe "Deuce" do
    test "new/0 initializes correctly" do
      assert Deuce.new() == :"40-40"
    end

    test "next_state/2 transitions between continue states" do
      assert Deuce.next_state(:"40-40", 0) == :"ad-40"
      assert Deuce.next_state(:"ad-40", 1) == :"40-40"
      assert Deuce.next_state(:"40-ad", 0) == :"40-40"
    end

    test "next_state/2 transitions to win states" do
      assert Deuce.next_state(:"ad-40", 0) == {:win, 0}
      assert Deuce.next_state(:"40-ad", 1) == {:win, 1}
    end
  end
end
