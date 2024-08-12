defmodule Tennis.GameExample do
  use BasicVersus, sub_versus: nil, winning_score: 4, win_differential: 2, tiebreak_versus: Tennis.Deuce
  # TODO
  # Set and game tiebreakers are different because on game, the tiebreaker gets initialized before the
  # winning point value, but on set we reach the winning point value and then initialize the tiebreaker.
end
