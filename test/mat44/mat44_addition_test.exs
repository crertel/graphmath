defmodule GraphmathTest.Mat44.AddMat44 do
  use ExUnit.Case

  @tag :mat44
  @tag :add
  test "add( I, 0 ) returns I" do
    assert {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1} ==
             Graphmath.Mat44.add(
               {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1},
               {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
             )
  end

  @tag :mat44
  @tag :add
  test "add( [1:1:16], [100:100:1600] ) returns I" do
    assert {101, 202, 303, 404, 505, 606, 707, 808, 909, 1010, 1111, 1212, 1313, 1414, 1515, 1616} ==
             Graphmath.Mat44.add(
               {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16},
               {100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500,
                1600}
             )
  end
end
