defmodule GraphmathTest.Vec3.DotVec3 do
  use ExUnit.Case

  @tag :vec3
  @tag :dot
  test "dot({3,4,5},{5,6,7}) returns 74" do
    assert 74 == Graphmath.Vec3.dot({3, 4, 5}, {5, 6, 7})
  end
end
