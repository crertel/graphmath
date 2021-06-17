defmodule GraphmathTest.Vec2.MinkowskiDistanceVec2 do
  use ExUnit.Case

  @tag :vec2
  @tag :minkowski_distance
  test "minkowski_distance({1,0},{1,0}, 1) returns 0" do
    assert 0.0 == Graphmath.Vec2.minkowski_distance({1, 0}, {1, 0}, 1)
  end

  @tag :vec2
  @tag :minkowski_distance
  test "minkowski_distance({1,0},{1,0}, 2) returns 0" do
    assert 0.0 == Graphmath.Vec2.minkowski_distance({1, 0}, {1, 0}, 2)
  end

  @tag :vec2
  @tag :minkowski_distance
  test "minkowski_distance({0,0},{1,1}, 1) returns 0" do
    assert 2 == Graphmath.Vec2.minkowski_distance({0, 0}, {1,1}, 1)
  end

  @tag :vec2
  @tag :minkowski_distance
  test "minkowski_distance({0,0},{1,1}, 2) returns 0" do
    assert :math.sqrt(2) == Graphmath.Vec2.minkowski_distance({0, 0}, {1,1}, 2)
  end
end
