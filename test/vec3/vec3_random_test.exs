defmodule GraphmathTest.Vec3.RandomVec3 do
  use ExUnit.Case
  import TestUtils

  @tag :vec3
  @tag :random
  test "random_ball/0 works" do
    v = Graphmath.Vec3.random_ball()
    assert Graphmath.Vec3.length_squared(v) <= 1.0
  end

  @tag :vec3
  @tag :random
  test "random_sphere/0 works" do
    v = Graphmath.Vec3.random_sphere()
    assert within_eps(Graphmath.Vec3.length_squared(v), 1.0)
  end

  @tag :vec3
  @tag :random
  test "random_box/0 works" do
    {x, y, z} = Graphmath.Vec3.random_box()
    assert abs(x) <= 1.0
    assert abs(y) <= 1.0
    assert abs(z) <= 1.0
  end
end
