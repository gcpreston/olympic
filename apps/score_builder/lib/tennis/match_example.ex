defmodule Tennis.MatchExample do
  use BasicVersus, sub_versus: Tennis.Set, winning_score: 2, win_differential: 1, tiebreak_versus: nil
end
