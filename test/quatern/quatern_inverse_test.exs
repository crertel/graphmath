defmodule GraphmathTest.Quatern.InverseQuatern do
  use ExUnit.Case

  @tag :quatern
  @tag :inverse
  test "inverse({5,6,7,8}) returns {0.029, -0.034, -0.040, -0.046} " do
    {w, x, y, z} = Graphmath.Quatern.inverse({5.0, 6.0, 7.0, 8.0})

    assert {0.028736, -0.034483, -0.040230, -0.045977} ==
             {Float.round(w, 6), Float.round(x, 6), Float.round(y, 6), Float.round(z, 6)}
  end

  @tag :quatern
  @tag :inverse
  test "inverse({0,0,0,0}) returns invalid" do
    {w, x, y, z} = Graphmath.Quatern.inverse({0, 0, 0, 0})

    assert {0, 0, 0, 0} ==
             {Float.round(w, 6), Float.round(x, 6), Float.round(y, 6), Float.round(z, 6)}
  end
end
