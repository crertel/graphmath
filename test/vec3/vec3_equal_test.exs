defmodule GraphmathTest.Vec3.EqualVec3 do
  use ExUnit.Case
  alias Graphmath.Vec3

  @tag :vec3
  @tag :equal
  test "equal( {1.0, 1.0, 0.0}, {0.0, 0.0, 0.0}) is false" do
    refute Vec3.equal({1.0, 1.0, 0.0}, {0.0, 0.0, 0.0})
  end

  @tag :vec3
  @tag :equal
  test "equal( {1.0, 1.0, 1.0}, {1.0, 1.0, 1.0}) is true" do
    assert Vec3.equal({1.0, 1.0, 1.0}, {1.0, 1.0, 1.0})
  end

  @tag :vec3
  @tag :equal
  test "equal( {1.0, 1.0, 0.0}, {0.0, 0.0, 0.0}, 0.0) is false" do
    refute Vec3.equal({1.0, 1.0, 0.0}, {0.0, 0.0, 0.0}, 0.0)
  end

  @tag :vec3
  @tag :equal
  test "equal( {1.0, 1.0, 0.0}, {0.0, 0.0, 0.0}, 2.0) is true" do
    assert Vec3.equal({1.0, 1.0, 0.0}, {0.0, 0.0, 0.0}, 2.0)
  end
end
