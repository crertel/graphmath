defmodule GraphmathTest.Vec2.Scale_Vec2 do
  use ExUnit.Case

  @tag :vec2
  @tag :scale
  test "scale_vec2([1,2],2) returns [2,4]" do
    assert [2,4] == Graphmath.Vec2.scale_vec2([1,2],2)
  end

  @tag :vec2
  @tag :scale
  test "scale_vec2([3,4],[5,6]) return [15,24]" do
    assert [15,24] == Graphmath.Vec2.scale_vec2([3,4],[5,6])
  end
end
