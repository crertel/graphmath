defmodule GraphmathTest.Quatern.Equality do
  use ExUnit.Case

  @tag :quatern
  @tag :equality
  test "equal_elements({0.0,0.0,0.0,0.0}, {1.0, 0.0, 0.0, 0.0}) is false" do
    refute Graphmath.Quatern.equal_elements({0.0, 0.0, 0.0, 0.0}, {1.0, 0.0, 0.0, 0.0})
  end

  @tag :quatern
  @tag :equality
  test "equal_elements({1.0,0.0,0.0,0.0}, {1.0, 0.0, 0.0, 0.0}) is true" do
    assert Graphmath.Quatern.equal_elements({1.0, 0.0, 0.0, 0.0}, {1.0, 0.0, 0.0, 0.0})
  end

  @tag :quatern
  @tag :equality
  test "equal_elements({0.0,0.0,0.0,0.0}, {1.0, 0.0, 0.0, 0.0},2.0) is true" do
    assert Graphmath.Quatern.equal_elements({0.0, 0.0, 0.0, 0.0}, {1.0, 0.0, 0.0, 0.0}, 2.0)
  end

  @tag :quatern
  @tag :equality
  test "equal({1.0, 0.0, 0.0, 0.0},{1.0, 0.0, 0.0, 0.0}) is true" do
    assert Graphmath.Quatern.equal({1.0, 0.0, 0.0, 0.0}, {1.0, 0.0, 0.0, 0.0})
    assert Graphmath.Quatern.equal({-1.0, 0.0, 0.0, 0.0}, {1.0, 0.0, 0.0, 0.0})
  end

  @tag :quatern
  @tag :equality
  test "equal({1.0, 0.0, 0.0, 0.0},{1.0, 0.0, 0.0, 0.0}, 0) is true" do
    assert Graphmath.Quatern.equal({1.0, 0.0, 0.0, 0.0}, {1.0, 0.0, 0.0, 0.0}, 0.0)
    assert Graphmath.Quatern.equal({-1.0, 0.0, 0.0, 0.0}, {1.0, 0.0, 0.0, 0.0}, 0.0)
  end
end
