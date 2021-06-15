defmodule GraphmathTest.Vec2.WeightedSumVec2 do
  alias Graphmath.Vec2
  use ExUnit.Case

  @tag :vec2
  @tag :weighted_sum
  test "weighted_sum(1.0, {1,2}, -4.0, {3,5}) returns {-11.0, -18.0}" do
    assert {-11.0, -18.0} == Vec2.weighted_sum(1.0, {1, 2}, -4.0, {3, 5})
  end
end
