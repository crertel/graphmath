defmodule GraphmathTest.Vec3.Create_Vec3 do
  use ExUnit.Case

  @tag :vec3
  @tag :create
  test "create_vec3 returns [0,0,0]" do
    assert [0,0,0] == Graphmath.Vec3.create_vec3()
  end

  @tag :vec3
  @tag :create
  test "create_vec3 returns [x,y,z] given vec3" do
    assert [1,2,3] == Graphmath.Vec3.create_vec3([1,2,3])
  end

  @tag :vec3
  @tag :create
  test "create_vec3 return [x,y] given vecN" do
    assert [6,7,8] == Graphmath.Vec3.create_vec3([6,7,8,9])
  end
end
