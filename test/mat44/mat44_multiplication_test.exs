defmodule GraphmathTest.Mat44.MultiplyMat44 do
  use ExUnit.Case

  @tag :mat44
  @tag :multiply
  test "multiply( I, 0 ) returns 0" do
    assert {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} ==
             Graphmath.Mat44.multiply(
               {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1},
               {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
             )
  end

  @tag :mat44
  @tag :multiply
  test "multiply( I, I ) returns I" do
    assert {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1} ==
             Graphmath.Mat44.multiply(
               {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1},
               {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1}
             )
  end

  @tag :mat44
  @tag :multiply
  test "multiply( 1:1:16, I ) returns 1:1:9" do
    assert {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16} ==
             Graphmath.Mat44.multiply(
               {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16},
               {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1}
             )
  end

  @tag :mat44
  @tag :multiply
  test "multiply( 1:1:16, 17:1:32 )" do
    assert {250, 260, 270, 280, 618, 644, 670, 696, 986, 1028, 1070, 1112, 1354, 1412, 1470, 1528} ==
             Graphmath.Mat44.multiply(
               {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16},
               {17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32}
             )
  end

  @tag :mat44
  @tag :multiply
  test "multiply( 10:1:18, 1:1:9 )" do
    assert {538, 612, 686, 760, 650, 740, 830, 920, 762, 868, 974, 1080, 874, 996, 1118, 1240} ==
             Graphmath.Mat44.multiply(
               {17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32},
               {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16}
             )
  end

  @tag :mat44
  @tag :multiply
  test "multiply_transpose( 1:1:9, 10:1:18 )" do
    assert {190, 230, 270, 310, 486, 590, 694, 798, 782, 950, 1118, 1286, 1078, 1310, 1542, 1774} ==
             Graphmath.Mat44.multiply_transpose(
               {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16},
               {17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32}
             )
  end
end
