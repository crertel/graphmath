defmodule GraphmathTest.Vec2.Length_Vec2 do
  use ExUnit.Case

  test "length_vec2([3,4]) returns 5" do
    assert 5 == Graphmath.Vec2.length_vec2([3,4])
  end
  
  test "length_squared_vec2([3,4]) returns 25" do
    assert 25 == Graphmath.Vec2.length_squared_vec2([3,4])
  end
  
  test "length_manhattan_vec2([3,4]) returns 7" do
    assert 7 == Graphmath.Vec2.length_manhattan_vec2([3,4])
  end
end
