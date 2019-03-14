defmodule GraphmathTest.Vec3.LerpVec3 do
  use ExUnit.Case

  @tag :vec3
  @tag :lerp
  test "lerp( {0,0,0}, {2,4,6}, 0) returns {0,0,0}" do
    assert {0, 0, 0} == Graphmath.Vec3.lerp({0, 0, 0}, {2, 4, 6}, 0)
  end

  @tag :vec3
  @tag :lerp
  test "lerp( {0,0,0}, {2,4,6}, 0.5) returns {1,2,3}" do
    assert {1, 2, 3} == Graphmath.Vec3.lerp({0, 0, 0}, {2, 4, 6}, 0.5)
  end

  @tag :vec3
  @tag :lerp
  test "lerp( {0,0,0}, {2,4,6}, 1) returns {2,4,6}" do
    assert {2, 4, 6} == Graphmath.Vec3.lerp({0, 0, 0}, {2, 4, 6}, 1)
  end
end
