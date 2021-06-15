defmodule GraphmathTest.Mat44.SubtractMat44 do
  use ExUnit.Case

  @tag :mat44
  @tag :subtract
  test "subtract( I, 0 ) returns I" do
    assert {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1} ==
             Graphmath.Mat44.subtract(
               {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1},
               {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
             )
  end

  @tag :mat44
  @tag :subtract
  test "subtract( [1:1:16], [100:100:1600] ) returns I" do
    assert {-99, -198, -297, -396, -495, -594, -693, -792, -891, -990, -1089, -1188, -1287, -1386,
            -1485,
            -1584} ==
             Graphmath.Mat44.subtract(
               {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16},
               {100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500,
                1600}
             )
  end
end
