defmodule GraphmathTest.Vec3.MinkowskiDistanceVec3 do
  use ExUnit.Case

  @tag :vec3
  @tag :minkowski_distance
  test "minkowski_distance({1,0,0},{1,0,0}, 1) returns 0" do
    assert 0.0 == Graphmath.Vec3.minkowski_distance({1, 0, 0}, {1, 0, 0}, 1)
  end

  @tag :vec3
  @tag :minkowski_distance
  test "minkowski_distance({1,0,0},{1,0,0}, 2) returns 0" do
    assert 0.0 == Graphmath.Vec3.minkowski_distance({1, 0, 0}, {1, 0, 0}, 2)
  end

  @tag :vec3
  @tag :minkowski_distance
  test "minkowski_distance({0,0},{1,1,1}, 1) returns 0" do
    assert 3 == Graphmath.Vec3.minkowski_distance({0, 0, 0}, {1,1,1}, 1)
  end

  @tag :vec3
  @tag :minkowski_distance
  test "minkowski_distance({0,0},{1,1,1}, 2) returns 0" do
    assert :math.sqrt(3) == Graphmath.Vec3.minkowski_distance({0, 0,0}, {1,1,1}, 2)
  end
end
