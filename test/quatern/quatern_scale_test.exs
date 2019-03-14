defmodule GraphmathTest.Quatern.Scale_Quatern do
  use ExUnit.Case

  @tag :quatern
  @tag :scale
  test "scale({1,2,3,4},2) returns {2,4,6,8}" do
    assert {2, 4, 6, 8} == Graphmath.Quatern.scale({1, 2, 3, 4}, 2)
  end
end
