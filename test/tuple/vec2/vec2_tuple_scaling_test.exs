defmodule Graphmath.Vec2.Tuple.Scale_Vec2 do
  use ExUnit.Case

  @tag :vec2
  @tag :scale
  test "scale({1,2},2) returns {2,4}" do
    assert {2,4} == Graphmath.Vec2.Tuple.scale({1,2},2)
  end
end
