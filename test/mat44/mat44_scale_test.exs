defmodule GraphmathTest.Mat44.ScaleMat44 do
  use ExUnit.Case

  @tag :mat44
  @tag :scale
  test "scale( I, 3 ) returns I*3" do
    assert {3, 0, 0, 0, 0, 3, 0, 0, 0, 0, 3, 0, 0, 0, 0, 3} ==
             Graphmath.Mat44.scale(
               {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1},
               3
             )
  end

  @tag :mat44
  @tag :scale
  test "scale( [1:1:9], 10 ) returns I*3" do
    assert {10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160} ==
             Graphmath.Mat44.scale(
               {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16},
               10
             )
  end
end
