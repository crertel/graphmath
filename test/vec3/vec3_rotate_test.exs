defmodule GraphmathTest.Vec3.RotateVec3 do
  use ExUnit.Case

  @tag :vec3
  @tag :rotate
  test "rotate({1,0,0},{1,0,0},0) returns {1,0,0}" do
    assert {1, 0, 0} == Graphmath.Vec3.rotate({1, 0, 0}, {1, 0, 0}, 0)
  end

  @tag :vec3
  @tag :rotate
  test "rotate({1,0,0},{0,1,0},0) returns {1,0,0}" do
    assert {1, 0, 0} == Graphmath.Vec3.rotate({1, 0, 0}, {0, 1, 0}, 0)
  end

  @tag :vec3
  @tag :rotate
  test "rotate({1,0,0},{0,0,1},0) returns {1,0,0}" do
    assert {1, 0, 0} == Graphmath.Vec3.rotate({1, 0, 0}, {0, 0, 1}, 0)
  end

  @tag :vec3
  @tag :rotate
  test "rotate({0,1,0},{1,0,0},0) returns {1,0,0}" do
    assert {0, 1, 0} == Graphmath.Vec3.rotate({0, 1, 0}, {1, 0, 0}, 0)
  end

  @tag :vec3
  @tag :rotate
  test "rotate({0,1,0},{0,1,0},0) returns {1,0,0}" do
    assert {0, 1, 0} == Graphmath.Vec3.rotate({0, 1, 0}, {0, 1, 0}, 0)
  end

  @tag :vec3
  @tag :rotate
  test "rotate({0,1,0},{0,0,1},0) returns {1,0,0}" do
    assert {0, 1, 0} == Graphmath.Vec3.rotate({0, 1, 0}, {0, 0, 1}, 0)
  end

  @tag :vec3
  @tag :rotate
  test "rotate({0,0,1},{1,0,0},0) returns {1,0,0}" do
    assert {0, 0, 1} == Graphmath.Vec3.rotate({0, 0, 1}, {1, 0, 0}, 0)
  end

  @tag :vec3
  @tag :rotate
  test "rotate({0,0,1},{0,1,0},0) returns {1,0,0}" do
    assert {0, 0, 1} == Graphmath.Vec3.rotate({0, 0, 1}, {0, 1, 0}, 0)
  end

  @tag :vec3
  @tag :rotate
  test "rotate({0,0,1},{0,0,1},0) returns {1,0,0}" do
    assert {0, 0, 1} == Graphmath.Vec3.rotate({0, 0, 1}, {0, 0, 1}, 0)
  end

  @tag :vec3
  @tag :rotate
  test "rotate({1,0,0},{1,0,0},:math.pi/2) returns {0,0,1}" do
    {x, y, z} = Graphmath.Vec3.rotate({1, 0, 0}, {1, 0, 0}, :math.pi() / 2)
    assert {1, 0, 0} == {Float.round(x, 6), Float.round(y, 6), Float.round(z, 6)}
  end

  @tag :vec3
  @tag :rotate
  test "rotate({0,1,0},{1,0,0},:math.pi/2) returns {0,1,0}" do
    {x, y, z} = Graphmath.Vec3.rotate({0, 1, 0}, {1, 0, 0}, :math.pi() / 2)
    assert {0, 0, 1} == {Float.round(x, 6), Float.round(y, 6), Float.round(z, 6)}
  end

  @tag :vec3
  @tag :rotate
  test "rotate({0,0,1},{1,0,0},:math.pi/2) returns {0,0,1}" do
    {x, y, z} = Graphmath.Vec3.rotate({0, 0, 1}, {1, 0, 0}, :math.pi() / 2)
    assert {0, -1, 0} == {Float.round(x, 6), Float.round(y, 6), Float.round(z, 6)}
  end

  @tag :vec3
  @tag :rotate
  test "rotate({1,0,0},{0,1,0},:math.pi/2) returns {0,0,-1}" do
    {x, y, z} = Graphmath.Vec3.rotate({1, 0, 0}, {0, 1, 0}, :math.pi() / 2)
    assert {0, 0, -1} == {Float.round(x, 6), Float.round(y, 6), Float.round(z, 6)}
  end

  @tag :vec3
  @tag :rotate
  test "rotate({0,1,0},{0,1,0},:math.pi/2) returns {0,1,0}" do
    {x, y, z} = Graphmath.Vec3.rotate({0, 1, 0}, {0, 1, 0}, :math.pi() / 2)
    assert {0, 1, 0} == {Float.round(x, 6), Float.round(y, 6), Float.round(z, 6)}
  end

  @tag :vec3
  @tag :rotate
  test "rotate({0,0,1},{0,1,0},:math.pi/2) returns {0,0,1}" do
    {x, y, z} = Graphmath.Vec3.rotate({0, 0, 1}, {0, 1, 0}, :math.pi() / 2)
    assert {1, 0, 0} == {Float.round(x, 6), Float.round(y, 6), Float.round(z, 6)}
  end

  @tag :vec3
  @tag :rotate
  test "rotate({1,0,0},{0,0,1},:math.pi/2) returns {0,0,-1}" do
    {x, y, z} = Graphmath.Vec3.rotate({1, 0, 0}, {0, 0, 1}, :math.pi() / 2)
    assert {0, 1, 0} == {Float.round(x, 6), Float.round(y, 6), Float.round(z, 6)}
  end

  @tag :vec3
  @tag :rotate
  test "rotate({0,1,0},{0,0,1},:math.pi/2) returns {0,1,0}" do
    {x, y, z} = Graphmath.Vec3.rotate({0, 1, 0}, {0, 0, 1}, :math.pi() / 2)
    assert {-1, 0, 0} == {Float.round(x, 6), Float.round(y, 6), Float.round(z, 6)}
  end

  @tag :vec3
  @tag :rotate
  test "rotate({0,0,1},{0,0,1},:math.pi/2) returns {0,0,1}" do
    {x, y, z} = Graphmath.Vec3.rotate({0, 0, 1}, {0, 0, 1}, :math.pi() / 2)
    assert {0, 0, 1} == {Float.round(x, 6), Float.round(y, 6), Float.round(z, 6)}
  end
end
