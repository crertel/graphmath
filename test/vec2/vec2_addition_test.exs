defmodule GraphmathTest.Vec2.AddVec2 do
  use ExUnit.Case

  @tag :vec2
  @tag :add
  test "add({1,2},{3,4}) returns {4,6}" do
    assert {4, 6} == Graphmath.Vec2.add({1, 2}, {3, 4})
  end
end
