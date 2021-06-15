defmodule GraphmathTest.Vec2.RotateVec2 do
  use ExUnit.Case

  @tag :vec2
  @tag :rotate
  test "rotate( {0,0}, 0) returns {0,0}" do
    assert {0, 0} == Graphmath.Vec2.rotate({0, 0}, 0)
  end

  @tag :vec2
  @tag :rotate
  test "rotate( {0,0}, :math.pi) returns {0,0}" do
    {x, y} = Graphmath.Vec2.rotate({0, 0}, :math.pi())
    assert {0, 0} == {Float.round(x, 6), Float.round(y, 6)}
  end

  @tag :vec2
  @tag :rotate
  test "rotate( {1,0}, 0) returns {1,0}" do
    {x, y} = Graphmath.Vec2.rotate({1, 0}, 0)
    assert {1, 0} == {Float.round(x, 6), Float.round(y, 6)}
  end

  @tag :vec2
  @tag :rotate
  test "rotate( {1,0}, :math.pi//2) returns {0,1}" do
    {x, y} = Graphmath.Vec2.rotate({1, 0}, :math.pi() / 2)
    assert {0, 1} == {Float.round(x, 6), Float.round(y, 6)}
  end

  @tag :vec2
  @tag :rotate
  test "rotate( {1,0}, :math.pi) returns {-1,0}" do
    {x, y} = Graphmath.Vec2.rotate({1, 0}, :math.pi())
    assert {-1, 0} == {Float.round(x, 6), Float.round(y, 6)}
  end

  @tag :vec2
  @tag :rotate
  test "rotate( {0,1}, :math.pi) returns {0,-1}" do
    {x, y} = Graphmath.Vec2.rotate({0, 1}, :math.pi())
    assert {0, -1} == {Float.round(x, 6), Float.round(y, 6)}
  end

  @tag :vec2
  @tag :rotate
  test "rotate( {0,-1}, :math.pi) returns {0,1}" do
    {x, y} = Graphmath.Vec2.rotate({0, -1}, :math.pi())
    assert {0, 1} == {Float.round(x, 6), Float.round(y, 6)}
  end

  @tag :vec2
  @tag :rotate
  test "rotate( {0,1}, :math.pi//2) returns {-1,0}" do
    {x, y} = Graphmath.Vec2.rotate({0, 1}, :math.pi() / 2)
    assert {-1, 0} == {Float.round(x, 6), Float.round(y, 6)}
  end

  @tag :vec2
  @tag :rotate
  test "rotate( {0,-1}, :math.pi//2) returns {1,0}" do
    {x, y} = Graphmath.Vec2.rotate({0, -1}, :math.pi() / 2)
    assert {1, 0} == {Float.round(x, 6), Float.round(y, 6)}
  end

  @tag :vec2
  @tag :rotate
  test "rotate( {0,1}, -(:math.pi//2)) returns {1,0}" do
    {x, y} = Graphmath.Vec2.rotate({0, 1}, -:math.pi() / 2)
    assert {1, 0} == {Float.round(x, 6), Float.round(y, 6)}
  end

  @tag :vec2
  @tag :rotate
  test "rotate( {0,-1}, -(:math.pi//2)) returns {-1,0}" do
    {x, y} = Graphmath.Vec2.rotate({0, -1}, -:math.pi() / 2)
    assert {-1, 0} == {Float.round(x, 6), Float.round(y, 6)}
  end
end
