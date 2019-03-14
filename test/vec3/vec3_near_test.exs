defmodule GraphmathTest.Vec3.NearVec3 do
  use ExUnit.Case

  @tag :vec3
  @tag :comaprison
  test "near({0,0,0}, {0,0,0}, 0.5) returns true" do
    assert true == Graphmath.Vec3.near({0, 0, 0}, {0, 0, 0}, 0.5)
  end

  @tag :vec3
  @tag :comparison
  test "near({0,0,0}, {1,1,1}, 0.5) returns false" do
    assert false == Graphmath.Vec3.near({0, 0, 0}, {1, 1, 1}, 0.5)
  end

  @tag :vec3
  @tag :comparison
  test "near({0,0,0}, {1,1,1}, 1) returns false" do
    assert false == Graphmath.Vec3.near({0, 0, 0}, {1, 1, 1}, 1)
  end

  @tag :vec3
  @tag :comparison
  test "near({0,0,0}, {1,1,1}, 2) returns true" do
    assert true == Graphmath.Vec3.near({0, 0, 0}, {1, 1, 1}, 2)
  end

  @tag :vec3
  @tag :comparison
  test "near({2,0,0}, {2,0,1}, 2) returns true" do
    assert true == Graphmath.Vec3.near({2, 0, 0}, {2, 0, 1}, 2)
  end

  @tag :vec3
  @tag :comparison
  test "near({2,0,0}, {2,0,1}, .5) returns false" do
    assert false == Graphmath.Vec3.near({2, 0, 0}, {2, 0, 1}, 0.5)
  end
end
