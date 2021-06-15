defmodule GraphmathTest.Mat33.CreateMat33 do
  use ExUnit.Case

  @tag :mat33
  @tag :identity
  test "identity returns {1,0,0,0,1,0,0,0,1}" do
    assert {1, 0, 0, 0, 1, 0, 0, 0, 1} == Graphmath.Mat33.identity()
  end

  @tag :mat33
  @tag :zero
  test "zero returns {0,0,0,0,0,0,0,0,0}" do
    assert {0, 0, 0, 0, 0, 0, 0, 0, 0} == Graphmath.Mat33.zero()
  end
end
