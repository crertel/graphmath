defmodule GraphmathTest.Quatern.Basics do
  use ExUnit.Case

  @tag :quatern
  @tag :basics
  test "identity() returns {1.0, 0.0, 0.0, 0.0}" do
    assert {1.0, 0.0, 0.0, 0.0} == Graphmath.Quatern.identity()
  end

  @tag :quatern
  @tag :basics
  test "zero() returns {0.0, 0.0, 0.0, 0.0}" do
    assert {0.0, 0.0, 0.0, 0.0} == Graphmath.Quatern.zero()
  end
end
