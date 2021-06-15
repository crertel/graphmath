defmodule GraphmathTest.Vec2.MultiplyVec2 do
  use ExUnit.Case

  @tag :vec2
  @tag :multiply
  test "multiply({3,4},{5,6}) return {15,24}" do
    assert {15, 24} == Graphmath.Vec2.multiply({3, 4}, {5, 6})
  end
end
