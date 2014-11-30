defmodule GraphmathTest.Vec2.Rotate_Vec2 do
  use ExUnit.Case

  test "rotate_vec2( [0,0], 0) returns [0,0]" do
    assert [0,0] == Graphmath.Vec2.rotate_vec2( [0,0], 0)
  end
  
  test "rotate_vec2( [0,0], :math.pi) returns [0,0]" do
    [x, y] = Graphmath.Vec2.rotate_vec2( [0,0], :math.pi)
    assert [0,0] == [ Float.round(x,6), Float.round(y,6)]
  end

  test "rotate_vec2( [1,0], 0) returns [1,0]" do
    [x, y] = Graphmath.Vec2.rotate_vec2( [1,0], 0)
    assert [1,0] == [ Float.round(x,6), Float.round(y,6)]
  end
  
  test "rotate_vec2( [1,0], :math.pi//2) returns [0,1]" do
    [x,y] = Graphmath.Vec2.rotate_vec2( [1,0], :math.pi/2)
    assert [0,1] == [ Float.round(x,6), Float.round(y,6)]
  end
  
  test "rotate_vec2( [1,0], :math.pi) returns [-1,0]" do
    [x,y] = Graphmath.Vec2.rotate_vec2( [1,0], :math.pi)
    assert [-1,0] == [ Float.round(x,6), Float.round(y,6)]
  end
end
