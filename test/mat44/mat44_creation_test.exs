defmodule GraphmathTest.Mat44.CreateMat44 do
  use ExUnit.Case

  @tag :mat44
  @tag :identity
  test "identity returns {1,0,0,0, 0,1,0,0, 0,0,1,0 0,0,0,1}" do
    assert {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1} == Graphmath.Mat44.identity()
  end

  @tag :mat44
  @tag :zero
  test "zero returns {0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0}" do
    assert {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} == Graphmath.Mat44.zero()
  end
end
