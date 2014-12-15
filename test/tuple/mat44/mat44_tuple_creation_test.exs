defmodule Graphmath.Mat44.Tuple.Create_Mat44 do
  use ExUnit.Case

  @tag :mat44
  @tag :identity
  test "identity returns {1,0,0,0, 0,1,0,0, 0,0,1,0 0,0,0,1}" do
    assert {1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            0, 0, 0, 1} == Graphmath.Mat44.Tuple.identity()
  end

  @tag :mat44
  @tag :zero
  test "zero returns {0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0}" do
    assert {0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0} == Graphmath.Mat44.Tuple.zero()
  end

end
