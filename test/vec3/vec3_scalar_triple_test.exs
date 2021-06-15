defmodule GraphmathTest.Vec3.ScalarTripleVec3 do
  alias Graphmath.Vec3
  use ExUnit.Case

  @tag :vec3
  @tag :scalar_triple
  test "scalar_triple( {1.0,2.0,3.0}, {4.0,5.0,6.0}, {7.0,8.0,9.0} ) returns 0.0" do
    a = {1.0, 2.0, 3.0}
    b = {4.0, 5.0, 6.0}
    c = {7.0, 8.0, 9.0}
    assert 0.0 == Vec3.scalar_triple(a, b, c)
  end

  @tag :vec3
  @tag :scalar_triple
  test "scalar_triple( {1, 0, 0}, {0,1,0}, {0,0,1} ) returns 1.0" do
    a = {1.0, 0.0, 0.0}
    b = {0.0, 1.0, 0.0}
    c = {0.0, 0.0, 1.0}
    assert 1.0 == Vec3.scalar_triple(a, b, c)
  end
end
