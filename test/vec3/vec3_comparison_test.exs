defmodule GraphmathTest.Vec3.Compare_Vec3 do
  use ExUnit.Case

  @tag :vec3
  @tag :comaprison
  test "compare_vec3([0,0,0], [0,0,0], 0.5) returns true" do
    assert true == Graphmath.Vec3.compare_vec3( [0,0,0], [0,0,0], 0.5)
  end

  @tag :vec3
  @tag :comparison
  test "compare_vec3([0,0,0], [1,1,1], 0.5) returns false" do
    assert false == Graphmath.Vec3.compare_vec3( [0,0,0], [1,1,1], 0.5)
  end
  
  @tag :vec3
  @tag :comparison
  test "compare_vec3([0,0,0], [1,1,1], 1) returns false" do
    assert false == Graphmath.Vec3.compare_vec3( [0,0,0], [1,1,1], 1)
  end
  
  @tag :vec3
  @tag :comparison
  test "compare_vec3([0,0,0], [1,1,1], 2) returns true" do
    assert true == Graphmath.Vec3.compare_vec3( [0,0,0], [1,1,1], 2)
  end

  @tag :vec3
  @tag :comparison
  test "compare_vec3([2,0,0], [2,0,1], 2) returns true" do
    assert true == Graphmath.Vec3.compare_vec3( [2,0,0], [2,0,1], 2)
  end
  
  @tag :vec3
  @tag :comparison
  test "compare_vec3([2,0,0], [2,0,1], .5) returns false" do
    assert false == Graphmath.Vec3.compare_vec3( [2,0,0], [2,0,1], 0.5)
  end

end
