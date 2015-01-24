defmodule GraphmathTest.Quatern.Normalize_Quatern do
  use ExUnit.Case

  @tag :quatern
  @tag :normalize
  test "normalize({5,6,7,8}) returns {0.379049, 0.454859, 0.530669, 0.606478}" do

    { w, x, y, z} = Graphmath.Quatern.normalize({5.0,6.0,7.0,8.0})

    assert { 0.379049,
             0.454859,
             0.530669,
             0.606478 }  == { Float.round(w,6),
                              Float.round(x,6),
                              Float.round(y,6),
                              Float.round(z,6) }
  end
  
end
