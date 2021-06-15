defmodule GraphmathTest.Vec2.NearVec2 do
  use ExUnit.Case

  @tag :vec2
  @tag :comaprison
  test "near({0,0}, {0,0}, 0.5) returns true" do
    assert true == Graphmath.Vec2.near({0, 0}, {0, 0}, 0.5)
  end

  @tag :vec2
  @tag :near
  test "near({0,0}, {1,1}, 0.5) returns false" do
    assert false == Graphmath.Vec2.near({0, 0}, {1, 1}, 0.5)
  end

  @tag :vec2
  @tag :near
  test "near({0,0}, {1,1}, 1) returns false" do
    assert false == Graphmath.Vec2.near({0, 0}, {1, 1}, 1)
  end

  @tag :vec2
  @tag :near
  test "near({0,0}, {1,1}, 2) returns true" do
    assert true == Graphmath.Vec2.near({0, 0}, {1, 1}, 2)
  end

  @tag :vec2
  @tag :near
  test "near({2,0}, {2,1}, 2) returns true" do
    assert true == Graphmath.Vec2.near({2, 0}, {2, 1}, 2)
  end

  @tag :vec2
  @tag :near
  test "near({2,0}, {2,1}, .5) returns false" do
    assert false == Graphmath.Vec2.near({2, 0}, {2, 1}, 0.5)
  end
end
