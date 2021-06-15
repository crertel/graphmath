defmodule GraphmathTest.Vec2.ProjectVec2 do
  use ExUnit.Case

  @tag :vec2
  @tag :project
  test "project( {0,0}, {1,1}) returns {0,0}" do
    {x, y} = Graphmath.Vec2.project({0, 0}, {1, 1})
    assert {0, 0} == {Float.round(x, 6), Float.round(y, 6)}
  end

  @tag :vec2
  @tag :project
  test "project( {1,2}, {1,2}) returns {1,2}" do
    {x, y} = Graphmath.Vec2.project({1, 2}, {1, 2})
    assert {1, 2} == {Float.round(x, 6), Float.round(y, 6)}
  end

  @tag :vec2
  @tag :project
  test "project( {-1,1}, {1,1}) returns {0,0}" do
    {x, y} = Graphmath.Vec2.project({-1, 1}, {1, 1})
    assert {0, 0} == {Float.round(x, 6), Float.round(y, 6)}
  end

  @tag :vec2
  @tag :project
  test "project( {1,1}, {2,2}) returns {1.5,1.5}" do
    {x, y} = Graphmath.Vec2.project({1, 1}, {2, 2})
    assert {1.0, 1.0} == {Float.round(x, 6), Float.round(y, 6)}
  end
end
