defmodule GraphmathTest.Vec3.SubtractVec3 do
  use ExUnit.Case

  @tag :vec3
  @tag :subtract
  test "subtract({1,3,6},{3,7,9}) returns {-2,-4,-3}" do
    assert {-2, -4, -3} == Graphmath.Vec3.subtract({1, 3, 6}, {3, 7, 9})
  end
end
