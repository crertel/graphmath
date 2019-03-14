defmodule GraphmathTest.Quatern.CreateQuatern do
  use ExUnit.Case

  @tag :quatern
  @tag :create
  test "create returns {0,0,0}" do
    assert {0, 0, 0, 0} == Graphmath.Quatern.create()
  end

  @tag :quatern
  @tag :create
  test "create returns {w,x,y,z} given (w,x,y,z)" do
    assert {3, 4, 5, 6} == Graphmath.Quatern.create(3, 4, 5, 6)
  end

  @tag :quatern
  @tag :create
  test "create returns {w,x,y,z} given quatern" do
    assert {1, 2, 3, 4} == Graphmath.Quatern.create([1, 2, 3, 4])
  end

  @tag :quatern
  @tag :create
  test "create return {w,x,y,z} given quatern" do
    assert {6, 7, 8, 9} == Graphmath.Quatern.create([6, 7, 8, 9, 10])
  end

  @tag :quatern
  @tag :create
  test "create return {w,x,y,z} given (w, vec3)" do
    assert {1, 2, 3, 4} == Graphmath.Quatern.create(1, {2, 3, 4})
  end
end
