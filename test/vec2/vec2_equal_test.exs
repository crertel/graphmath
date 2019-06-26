defmodule GraphmathTest.Vec2.EqualVec2 do
  use ExUnit.Case
  alias Graphmath.Vec2

  @tag :vec2
  @tag :equal
  test "equal( {1.0, 1.0}, {0.0, 0.0}) is false" do
    refute Vec2.equal({1.0, 1.0}, {0.0, 0.0})
  end

  @tag :vec2
  @tag :equal
  test "equal( {1.0, 1.0}, {1.0, 1.0}) is true" do
    assert Vec2.equal({1.0, 1.0}, {1.0, 1.0})
  end

  @tag :vec2
  @tag :equal
  test "equal( {1.0, 1.0}, {0.0, 0.0}, 0.0) is false" do
    refute Vec2.equal({1.0, 1.0}, {0.0, 0.0}, 0.0)
  end

  @tag :vec2
  @tag :equal
  test "equal( {1.0, 1.0, 0.0}, {0.0, 0.0, 0.0}, 2.0) is true" do
    assert Vec2.equal({1.0, 1.0}, {0.0, 0.0}, 2.0)
  end
end
