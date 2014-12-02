defmodule GraphmathTest.Vec3.Length_Vec3 do
  use ExUnit.Case

  @tag :vec3
  @tag :length
  test "length_vec3([3,0,4]) returns 5" do
    assert 5 == Graphmath.Vec3.length_vec3([3,0,4])
  end
  
  @tag :vec3
  @tag :length
  test "length_squared_vec3([3,2,4]) returns 29" do
    assert 29 == Graphmath.Vec3.length_squared_vec3([3,2,4])
  end
  
  @tag :vec3
  @tag :length
  test "length_manhattan_vec3([3,4,5]) returns 12" do
    assert 12 == Graphmath.Vec3.length_manhattan_vec3([3,4,5])
  end
end
