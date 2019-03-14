defmodule GraphmathTest.Quatern.RollQuatern do
  use ExUnit.Case

  @tag :quatern
  @tag :get_roll
  # values obtained through another calculator
  test "get_roll({5,6,7,8}) returns 2.51174012251831" do
    assert 2.51174012251831 == Graphmath.Quatern.get_roll({5, 6, 7, 8})
  end
end
