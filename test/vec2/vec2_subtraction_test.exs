defmodule GraphmathTest.Vec2.Subtract_Vec2 do
  use ExUnit.Case

  @tag :vec2
  @tag :subtract
  test "subtract_vec2([1,3],[3,7]) returns [-2,-4]" do
    assert [-2,-4] == Graphmath.Vec2.subtract_vec2([1,3],[3,7])
  end
end
