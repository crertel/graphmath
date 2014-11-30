defmodule GraphmathTest.Vec2.Compare_Vec2 do
  use ExUnit.Case

  test "compare_vec2([0,0], [0,0], 0.5) returns true" do
    assert true == Graphmath.Vec2.compare_vec2( [0,0], [0,0], 0.5)
  end

  test "compare_vec2([0,0], [1,1], 0.5) returns false" do
    assert false == Graphmath.Vec2.compare_vec2( [0,0], [1,1], 0.5)
  end
  
  test "compare_vec2([0,0], [1,1], 1) returns false" do
    assert false == Graphmath.Vec2.compare_vec2( [0,0], [1,1], 1)
  end
  
  test "compare_vec2([0,0], [1,1], 2) returns true" do
    assert true == Graphmath.Vec2.compare_vec2( [0,0], [1,1], 2)
  end

  test "compare_vec2([2,0], [2,1], 2) returns true" do
    assert true == Graphmath.Vec2.compare_vec2( [2,0], [2,1], 2)
  end
  
  test "compare_vec2([2,0], [2,1], .5) returns false" do
    assert false == Graphmath.Vec2.compare_vec2( [2,0], [2,1], 0.5)
  end

end
