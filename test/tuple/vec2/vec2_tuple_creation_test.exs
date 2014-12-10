defmodule Graphmath.Vec2.Tuple.Create_Vec2 do
  use ExUnit.Case

  @tag :vec2
  @tag :create
  test "create returns {0,0}" do
    assert {0,0} == Graphmath.Vec2.Tuple.create()
  end

  @tag :vec2
  @tag :create
  test "create returns {x,y} given (x,y)" do
    assert {4,5} == Graphmath.Vec2.Tuple.create(4,5)
  end

  @tag :vec2
  @tag :create
  test "create returns {x,y} given vec2 list" do
    assert {1,2} == Graphmath.Vec2.Tuple.create([1,2])
  end

  @tag :vec2
  @tag :create
  test "create returns {x,y} given vec3 list" do
    assert {4,5} == Graphmath.Vec2.Tuple.create([4,5,6])
  end

  @tag :vec2
  @tag :create
  test "create return {x,y} given vecN list" do
    assert {6,7} == Graphmath.Vec2.Tuple.create([6,7,8,9])
  end
end
