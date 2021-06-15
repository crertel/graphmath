defmodule GraphmathTest.Vec2.LerpVec2 do
  use ExUnit.Case

  @tag :vec2
  @tag :lerp
  test "lerp( {0,0}, {2,4}, 0) returns {0,0}" do
    assert {0, 0} == Graphmath.Vec2.lerp({0, 0}, {2, 4}, 0)
  end

  @tag :vec2
  @tag :lerp
  test "lerp( {0,0}, {2,4}, 0.5) returns {1,2}" do
    assert {1, 2} == Graphmath.Vec2.lerp({0, 0}, {2, 4}, 0.5)
  end

  @tag :vec2
  @tag :lerp
  test "lerp( {0,0}, {2,4}, 1) returns {2,4}" do
    assert {2, 4} == Graphmath.Vec2.lerp({0, 0}, {2, 4}, 1)
  end
end
