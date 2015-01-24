defmodule GraphmathTest.Quatern.Norm_Quatern do
  use ExUnit.Case

  @tag :quatern
  @tag :norm
  test "norm({5,6,7,8}) returns 174" do
    assert 174 == Graphmath.Quatern.norm({5,6,7,8})
  end
  
  @tag :quatern
  @tag :norm
  test "norm({-5,-6,-7,-8}) returns 174" do
    assert 174 == Graphmath.Quatern.norm({-5,-6,-7,-8})
  end
  
  @tag :quatern
  @tag :norm
  test "norm({0,0,0,0}) returns 0" do
    assert 0 == Graphmath.Quatern.norm({0,0,0,0})
  end
end
