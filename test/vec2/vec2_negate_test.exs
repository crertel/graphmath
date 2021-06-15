defmodule GraphmathTest.Vec2.NegateVec2 do
  alias Graphmath.Vec2
  use ExUnit.Case

  @tag :vec2
  @tag :negate
  test "negate({0,0}) returns {0.0,0.0}" do
    assert {0.0, 0.0} == Vec2.negate({0.0, 0.0})
  end

  @tag :vec2
  @tag :negate
  test "negate({1,-1}) returns {-1.0,1.0}" do
    assert {-1.0, 1.0} == Vec2.negate({1.0, -1.0})
  end
end
