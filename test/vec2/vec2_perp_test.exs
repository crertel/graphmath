defmodule GraphmathTest.Vec2.PerpVec2 do
  use ExUnit.Case

  @tag :vec2
  @tag :perp
  test "perp({0,0}) returns {0,0}" do
    assert {0, 0} == Graphmath.Vec2.perp({0, 0})
  end

  @tag :vec2
  @tag :perp
  test "perp({1,0}) returns {0,1}" do
    assert {0, 1} == Graphmath.Vec2.perp({1, 0})
  end

  @tag :vec2
  @tag :perp
  test "perp({1,1}) returns {-1,1}" do
    assert {-1, 1} == Graphmath.Vec2.perp({1, 1})
  end
end
