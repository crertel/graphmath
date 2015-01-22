defmodule GraphmathTest.Quatern.Unity_Inverse_Quatern do
  use ExUnit.Case

  @tag :quatern
  @tag :unit_inverse
  test "unit_inverse({5,6,7,8}) returns {5,-6,-7,-8}" do
    assert {5,-6,-7,-8} == Graphmath.Quatern.unit_inverse({5,6,7,8})
  end
end
