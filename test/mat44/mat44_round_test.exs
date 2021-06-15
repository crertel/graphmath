defmodule GraphmathTest.Mat44.RoundMat44 do
  use ExUnit.Case

  @tag :mat44
  @tag :round
  test "round with 0 sigfigs and without fractional part" do
    assert {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16} ==
             Graphmath.Mat44.round(
               {1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0,
                16.0},
               0
             )
  end

  @tag :mat44
  @tag :round
  test "round with 0 sigfigs" do
    assert {1.0, 2.0, 3.0, 4.0, 6.0, 7.0, 8.0, 9.0, 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0} ==
             Graphmath.Mat44.round(
               {1.3, 2.2, 3.3, 4.4, 5.5, 6.6, 7.7, 8.8, 8.7, 10.3, 10.84, 12.23, 13.0, 14.0, 15.0,
                16.0},
               0
             )
  end
end
