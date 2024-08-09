defmodule Tennis.SetExample do
  use BasicVersus, sub_versus: Tennis.Game, winning_score: 6, win_differential: 2, tiebreak_versus: Tennis.Tiebreak
end
