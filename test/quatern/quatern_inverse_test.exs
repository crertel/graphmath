defmodule GraphmathTest.Quatern.Inverse_Quatern do
  use ExUnit.Case

  @tag :quatern
  @tag :inverse
  test "inverse({5,6,7,8}) returns 174" do
    assert 174 == Graphmath.Quatern.norm({5,6,7,8})
  end
end
