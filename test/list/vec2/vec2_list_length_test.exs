defmodule Graphmath.Vec2.List.List.Length_Vec2 do
  use ExUnit.Case

  @tag :vec2
  @tag :length
  test "length([3,4]) returns 5" do
    assert 5 == Graphmath.Vec2.List.length([3,4])
  end
  
  @tag :vec2
  @tag :length
  test "length_squared([3,4]) returns 25" do
    assert 25 == Graphmath.Vec2.List.length_squared([3,4])
  end
  
  @tag :vec2
  @tag :length
  test "length_manhattan([3,4]) returns 7" do
    assert 7 == Graphmath.Vec2.List.length_manhattan([3,4])
  end
end
