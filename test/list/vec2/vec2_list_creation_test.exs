defmodule Graphmath.Vec2.List.List.Create_Vec2 do
  use ExUnit.Case

  @tag :vec2
  @tag :create
  test "create returns [0,0]" do
    assert [0,0] == Graphmath.Vec2.List.create()
  end

  @tag :vec2
  @tag :create
  test "create returns [x,y] given (x,y)" do
    assert [4,5] == Graphmath.Vec2.List.create(4,5)
  end

  @tag :vec2
  @tag :create
  test "create returns [x,y] given vec2" do
    assert [1,2] == Graphmath.Vec2.List.create([1,2])
  end

  @tag :vec2
  @tag :create
  test "create returns [x,y] given vec3" do
    assert [4,5] == Graphmath.Vec2.List.create([4,5,6])
  end

  @tag :vec2
  @tag :create
  test "create return [x,y] given vecN" do
    assert [6,7] == Graphmath.Vec2.List.create([6,7,8,9])
  end
end
