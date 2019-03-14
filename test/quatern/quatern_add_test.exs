defmodule GraphmathTest.Quatern.AddQuatern do
  use ExUnit.Case

  @tag :quatern
  @tag :add
  test "add({1,2,3,4},{5,6,7,8}) returns {6,8,10,12}" do
    assert {6, 8, 10, 12} == Graphmath.Quatern.add({1, 2, 3, 4}, {5, 6, 7, 8})
  end
end
