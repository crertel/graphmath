defmodule GraphmathTest.Mat33.RoundMat33 do
  use ExUnit.Case

  @tag :mat33
  @tag :round
  test "round with 0 sigfigs" do
    assert {1, 2, 3, 5, 6, 7, 7, 8, 10} ==
             Graphmath.Mat33.round(
               {1.1, 2.1, 3.3, 4.5, 5.6, 6.7, 7.0, 8.3, 9.9},
               0
             )
  end

  @tag :mat33
  @tag :round
  test "round with 2 sigfigs" do
    assert {1.1, 2.1, 3.1, 4.5, 5.7, 6.8, 7.0, 8.4, 10.0} ==
             Graphmath.Mat33.round(
               {1.14, 2.14, 3.14, 4.54, 5.66, 6.77, 7.03, 8.36, 9.99},
               1
             )
  end
end
