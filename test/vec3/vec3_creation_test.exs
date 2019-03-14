defmodule GraphmathTest.Vec3.CreateVec3 do
  use ExUnit.Case

  @tag :vec3
  @tag :create
  test "create returns {0,0,0}" do
    assert {0, 0, 0} == Graphmath.Vec3.create()
  end

  @tag :vec3
  @tag :create
  test "create returns {x,y,z} given (x,y,z)" do
    assert {4, 5, 6} == Graphmath.Vec3.create(4, 5, 6)
  end

  @tag :vec3
  @tag :create
  test "create returns {x,y,z} given vec3" do
    assert {1, 2, 3} == Graphmath.Vec3.create([1, 2, 3])
  end

  @tag :vec3
  @tag :create
  test "create return {x,y} given vecN" do
    assert {6, 7, 8} == Graphmath.Vec3.create([6, 7, 8, 9])
  end
end
