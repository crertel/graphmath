defmodule GraphmathTest.Quatern.SlerpQuatern do
  use ExUnit.Case

  @tag :quatern
  @tag :slerp
  test "slerp({1,2,3,4},{5,6,7,8}, 0) returns {1,2,3,4}" do
    q = Graphmath.Quatern.normalize({1, 2, 3, 4})
    assert q == Graphmath.Quatern.slerp({1, 2, 3, 4}, {5, 6, 7, 8}, 0)
  end

  @tag :quatern
  @tag :slerp
  test "slerp({1,2,3,4},{5,6,7,8}, 1) returns {5,6,7,8}" do
    q = Graphmath.Quatern.normalize({5, 6, 7, 8})
    assert q == Graphmath.Quatern.slerp({1, 2, 3, 4}, {5, 6, 7, 8}, 1)
  end

  @tag :quatern
  @tag :slerp
  test "slerp({1,2,3,4},{5,6,7,8}, 0.25) returns {0.272166,0.408248,0.544331,0.680414}" do
    {w, x, y, z} = Graphmath.Quatern.slerp({1, 2, 3, 4}, {5, 6, 7, 8}, 0.25)

    assert {0.272166, 0.408248, 0.544331, 0.680414} ==
             {Float.round(w, 6), Float.round(x, 6), Float.round(y, 6), Float.round(z, 6)}
  end

  @tag :quatern
  @tag :slerp
  test "slerp({5,6,7,8},{1,2,3,4}, 0.75) returns {0.272166,0.408248,0.544331,0.680414}" do
    {w, x, y, z} = Graphmath.Quatern.slerp({5, 6, 7, 8}, {1, 2, 3, 4}, 0.75)

    assert {0.272166, 0.408248, 0.544331, 0.680414} ==
             {Float.round(w, 6), Float.round(x, 6), Float.round(y, 6), Float.round(z, 6)}
  end

  @tag :quatern
  @tag :slerp
  test "slerp({0,0.1,0.1,0.1}, {1,0.1,0.1,0.1}, 0) returns {0,0.1,0.1,0.1}" do
    q = Graphmath.Quatern.normalize({0, 0.1, 0.1, 0.1})
    assert q == Graphmath.Quatern.slerp({0.0, 0.1, 0.1, 0.1}, {1.0, 0.1, 0.1, 0.1}, 0)
  end
end
