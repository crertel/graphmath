defmodule GraphmathTest.Mat33.MultiplyMat33 do
  use ExUnit.Case

  @tag :mat33
  @tag :multiply
  test "multiply( I, 0 ) returns 0" do
    assert {0, 0, 0, 0, 0, 0, 0, 0, 0} ==
             Graphmath.Mat33.multiply(
               {1, 0, 0, 0, 1, 0, 0, 0, 1},
               {0, 0, 0, 0, 0, 0, 0, 0, 0}
             )
  end

  @tag :mat33
  @tag :multiply
  test "multiply( I, I ) returns I" do
    assert {1, 0, 0, 0, 1, 0, 0, 0, 1} ==
             Graphmath.Mat33.multiply(
               {1, 0, 0, 0, 1, 0, 0, 0, 1},
               {1, 0, 0, 0, 1, 0, 0, 0, 1}
             )
  end

  @tag :mat33
  @tag :multiply
  test "multiply( 1:1:9, I ) returns 1:1:9" do
    assert {1, 2, 3, 4, 5, 6, 7, 8, 9} ==
             Graphmath.Mat33.multiply(
               {1, 2, 3, 4, 5, 6, 7, 8, 9},
               {1, 0, 0, 0, 1, 0, 0, 0, 1}
             )
  end

  @tag :mat33
  @tag :multiply
  test "multiply( 1:1:9, 10:1:18 )" do
    assert {84, 90, 96, 201, 216, 231, 318, 342, 366} ==
             Graphmath.Mat33.multiply(
               {1, 2, 3, 4, 5, 6, 7, 8, 9},
               {10, 11, 12, 13, 14, 15, 16, 17, 18}
             )
  end

  @tag :mat33
  @tag :multiply
  test "multiply( 10:1:18, 1:1:9 )" do
    assert {138, 171, 204, 174, 216, 258, 210, 261, 312} ==
             Graphmath.Mat33.multiply(
               {10, 11, 12, 13, 14, 15, 16, 17, 18},
               {1, 2, 3, 4, 5, 6, 7, 8, 9}
             )
  end

  @tag :mat33
  @tag :multiply
  test "multiply_transpose( 1:1:9, 10:1:18 )" do
    assert {68, 86, 104, 167, 212, 257, 266, 338, 410} ==
             Graphmath.Mat33.multiply_transpose(
               {1, 2, 3, 4, 5, 6, 7, 8, 9},
               {10, 11, 12, 13, 14, 15, 16, 17, 18}
             )
  end
end
