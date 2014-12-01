defmodule GraphmathTest.Vec2.Create_Vec2 do
  use ExUnit.Case

  @tag :vec2
  @tag :create
  test "create_vec2 returns [0,0]" do
    assert [0,0] == Graphmath.Vec2.create_vec2()
  end

  @tag :vec2
  @tag :create
  test "create_vec2 returns [x,y] given vec2" do
    assert [1,2] == Graphmath.Vec2.create_vec2([1,2])
  end

  @tag :vec2
  @tag :create
  test "create_vec2 returns [x,y] given vec3" do
    assert [4,5] == Graphmath.Vec2.create_vec2([4,5,6])
  end

  @tag :vec2
  @tag :create
  test "create_vec2 return [x,y] given vecN" do
    assert [6,7] == Graphmath.Vec2.create_vec2([6,7,8,9])
  end
end
