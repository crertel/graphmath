defmodule GraphmathTest.Mat33.SubtractMat33 do
  use ExUnit.Case

  @tag :mat33
  @tag :subtract
  test "subtract( I, 0 ) returns I" do
    assert {1, 0, 0, 0, 1, 0, 0, 0, 1} ==
             Graphmath.Mat33.subtract(
               {1, 0, 0, 0, 1, 0, 0, 0, 1},
               {0, 0, 0, 0, 0, 0, 0, 0, 0}
             )
  end

  @tag :mat33
  @tag :subtract
  test "subtract( [1:1:9], [10:10:90] ) returns I" do
    assert {-9, -18, -27, -36, -45, -54, -63, -72, -81} ==
             Graphmath.Mat33.subtract(
               {1, 2, 3, 4, 5, 6, 7, 8, 9},
               {10, 20, 30, 40, 50, 60, 70, 80, 90}
             )
  end
end
