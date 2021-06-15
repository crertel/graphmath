defmodule GraphmathTest.Vec3.NegateVec3 do
  alias Graphmath.Vec3
  use ExUnit.Case

  @tag :vec3
  @tag :negate
  test "negate({0,0,0}) returns {0.0,0.0,0.0}" do
    assert {0.0, 0.0, 0.0} == Vec3.negate({0.0, 0.0, 0.0})
  end

  @tag :vec3
  @tag :negate
  test "negate({1, -1, 1}) returns {-1.0, 1.0, -1.0}" do
    assert {-1.0, 1.0, -1.0} == Vec3.negate({1.0, -1.0, 1.0})
  end
end
