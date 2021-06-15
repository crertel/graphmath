defmodule GraphmathTest.Vec2.ScaleVec2 do
  use ExUnit.Case

  @tag :vec2
  @tag :scale
  test "scale({1,2},2) returns {2,4}" do
    assert {2, 4} == Graphmath.Vec2.scale({1, 2}, 2)
  end
end
