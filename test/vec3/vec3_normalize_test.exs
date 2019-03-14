defmodule GraphmathTest.Vec3.NormalizeVec3 do
  use ExUnit.Case

  @tag :vec3
  @tag :normalize
  test "normalize({1,0,0}) returns {1,0,0}" do
    assert {1, 0, 0} == Graphmath.Vec3.normalize({1, 0, 0})
  end

  @tag :vec3
  @tag :normalize
  test "normalize({2,0,2}) returns ~{.707,0,.707}" do
    sqrt2o2 = :math.sqrt(2) / 2
    {x, y, z} = Graphmath.Vec3.normalize({2, 0, 2})
    assert Float.round(sqrt2o2, 8) == Float.round(x, 8)
    assert Float.round(0.0, 8) == Float.round(y, 8)
    assert Float.round(sqrt2o2, 8) == Float.round(z, 8)
  end
end
