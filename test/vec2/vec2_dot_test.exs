defmodule Graphmath.Vec2.Dot_Vec2 do
  use ExUnit.Case

  @tag :vec2
  @tag :dot
  test "dot({3,4},{5,6}) returns 39" do
    assert 39 == Graphmath.Vec2.dot({3, 4}, {5, 6})
  end
end
