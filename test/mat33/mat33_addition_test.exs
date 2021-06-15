defmodule GraphmathTest.Mat33.AddMat33 do
  use ExUnit.Case

  @tag :mat33
  @tag :add
  test "add( I, 0 ) returns I" do
    assert {1, 0, 0, 0, 1, 0, 0, 0, 1} ==
             Graphmath.Mat33.add(
               {1, 0, 0, 0, 1, 0, 0, 0, 1},
               {0, 0, 0, 0, 0, 0, 0, 0, 0}
             )
  end

  @tag :mat33
  @tag :add
  test "add( [1:1:9], [10:10:90] ) returns I" do
    assert {11, 22, 33, 44, 55, 66, 77, 88, 99} ==
             Graphmath.Mat33.add(
               {1, 2, 3, 4, 5, 6, 7, 8, 9},
               {10, 20, 30, 40, 50, 60, 70, 80, 90}
             )
  end
end
