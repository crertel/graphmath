defmodule GraphmathTest.Vec3.CrossVec3 do
  use ExUnit.Case

  @tag :vec3
  @tag :cross
  test "cross({1,0,0},{0,1,0}) returns {0,0,1}" do
    assert {0, 0, 1} == Graphmath.Vec3.cross({1, 0, 0}, {0, 1, 0})
  end

  @tag :vec3
  @tag :cross
  test "cross({0,1,0},{1,0,0}) returns {0,0,-1}" do
    assert {0, 0, -1} == Graphmath.Vec3.cross({0, 1, 0}, {1, 0, 0})
  end

  @tag :vec3
  @tag :cross
  test "cross({2,0,0},{0,3,0}) returns {0,0,6}" do
    assert {0, 0, 6} == Graphmath.Vec3.cross({2, 0, 0}, {0, 3, 0})
  end

  @tag :vec3
  @tag :cross
  test "cross({1,0,0},{0,0,1}) returns {0,-1,0}" do
    assert {0, -1, 0} == Graphmath.Vec3.cross({1, 0, 0}, {0, 0, 1})
  end

  @tag :vec3
  @tag :cross
  test "cross({1,0,0},{0,0,-1}) returns {0,1,0}" do
    assert {0, 1, 0} == Graphmath.Vec3.cross({1, 0, 0}, {0, 0, -1})
  end

  @tag :vec3
  @tag :cross
  test "cross({0,1,0},{0,0,1}) returns {1,0,0}" do
    assert {1, 0, 0} == Graphmath.Vec3.cross({0, 1, 0}, {0, 0, 1})
  end

  @tag :vec3
  @tag :cross
  test "cross({0,1,0},{0,0,-1}) returns {-1,0,0}" do
    assert {-1, 0, 0} == Graphmath.Vec3.cross({0, 1, 0}, {0, 0, -1})
  end
end
