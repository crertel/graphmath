defmodule GraphmathTest.Quatern.MultiplyQuatern do
  use ExUnit.Case

  @tag :quatern
  @tag :multiply
  test "multiply({1,2,3,4},{5,6,7,8}) returns {-60,12,30,24}" do
    assert {-60, 12, 30, 24} == Graphmath.Quatern.multiply({1, 2, 3, 4}, {5, 6, 7, 8})
  end

  @tag :quatern
  @tag :multiply
  test "multiply({5,6,7,8},{1,2,3,4}) returns {-60,20,14,32}" do
    assert {-60, 20, 14, 32} == Graphmath.Quatern.multiply({5, 6, 7, 8}, {1, 2, 3, 4})
  end
end
