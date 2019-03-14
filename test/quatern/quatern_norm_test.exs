defmodule GraphmathTest.Quatern.NormQuatern do
  use ExUnit.Case

  @tag :quatern
  @tag :norm
  test "norm({5,6,7,8}) returns sqrt 174" do
    assert 13.190906 == Float.round(Graphmath.Quatern.norm({5, 6, 7, 8}), 6)
  end

  @tag :quatern
  @tag :norm
  test "norm({-5,-6,-7,-8}) returns sqrt 174" do
    assert 13.190906 == Float.round(Graphmath.Quatern.norm({-5, -6, -7, -8}), 6)
  end

  @tag :quatern
  @tag :norm
  test "norm({0,0,0,0}) returns 0" do
    assert 0 == Graphmath.Quatern.norm({0, 0, 0, 0})
  end
end
