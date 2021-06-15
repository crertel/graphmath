defmodule GraphmathTest.Vec3.WeightedSumVec2 do
  alias Graphmath.Vec3
  use ExUnit.Case

  @tag :vec3
  @tag :weighted_sum
  test "weighted_sum(1.0, {1,2,3}, -4.0, {3,5,7}) returns {-11.0, -18.0, -25.0}" do
    assert {-11.0, -18.0, -25.0} == Vec3.weighted_sum(1.0, {1, 2, 3}, -4.0, {3, 5, 7})
  end
end
