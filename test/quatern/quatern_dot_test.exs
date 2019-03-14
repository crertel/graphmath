defmodule GraphmathTest.Quatern.DotQuatern do
  use ExUnit.Case

  @tag :quatern
  @tag :dot
  test "dot({1,2,3,4},{5,6,7,8}) returns 70" do
    assert 70 == Graphmath.Quatern.dot({1, 2, 3, 4}, {5, 6, 7, 8})
  end
end
