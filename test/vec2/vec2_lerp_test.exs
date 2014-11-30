defmodule GraphmathTest.Vec2.Lerp_Vec2 do
  use ExUnit.Case

  test "lerp_vec2( [0,0], [2,4], 0) returns [0,0]" do
    assert [0,0] == Graphmath.Vec2.lerp_vec2( [0,0], [2,4], 0)
  end
  test "lerp_vec2( [0,0], [2,4], 0.5) returns [1,2]" do
    assert [1,2] == Graphmath.Vec2.lerp_vec2( [0,0], [2,4], 0.5)
  end
  test "lerp_vec2( [0,0], [2,4], 1) returns [2,4]" do
    assert [2,4] == Graphmath.Vec2.lerp_vec2( [0,0], [2,4], 1)
  end
end
