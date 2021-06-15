defmodule GraphmathTest.Vec2.NormalizeVec2 do
  use ExUnit.Case

  @tag :vec2
  @tag :normalize
  test "normalize({1,0}) returns {1,0}" do
    assert {1, 0} == Graphmath.Vec2.normalize({1, 0})
  end

  @tag :vec2
  @tag :normalize
  test "normalize({2,2}) returns ~{.707,.707}" do
    sqrt2o2 = :math.sqrt(2) / 2
    {x, y} = Graphmath.Vec2.normalize({2, 2})
    assert Float.round(sqrt2o2, 8) == Float.round(x, 8)
    assert Float.round(sqrt2o2, 8) == Float.round(y, 8)
  end
end
