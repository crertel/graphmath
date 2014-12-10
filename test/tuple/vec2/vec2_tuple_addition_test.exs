defmodule Graphmath.Vec2.Tuple.Add_Vec2 do
  use ExUnit.Case

  @tag :vec2
  @tag :add
  test "add({1,2},{3,4}) returns {4,6}" do
    assert {4,6} == Graphmath.Vec2.Tuple.add({1,2},{3,4})
  end
end
