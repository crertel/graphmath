defmodule GraphmathTest.Quatern.SubQuatern do
  use ExUnit.Case

  @tag :quatern
  @tag :sub
  test "substract({1,2,3,4},{5,6,7,8}) returns {-4,-4,-4,-4}" do
    assert {-4, -4, -4, -4} == Graphmath.Quatern.subtract({1, 2, 3, 4}, {5, 6, 7, 8})
  end
end
