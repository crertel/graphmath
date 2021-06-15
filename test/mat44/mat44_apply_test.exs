defmodule GraphmathTest.Mat44.ApplyMat44 do
  use ExUnit.Case

  @tag :mat44
  @tag :apply
  test "apply( 1:1:16, {11,13,17,19} ) returns { 16400, 40400, 64400, 88400} " do
    assert {164, 404, 644, 884} ==
             Graphmath.Mat44.apply(
               {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16},
               {11, 13, 17, 19}
             )
  end

  @tag :mat44
  @tag :apply
  test "apply_transpose( 1:1:16, {11,13,17,19} ) returns { 476, 536, 596, 656} " do
    assert {476, 536, 596, 656} ==
             Graphmath.Mat44.apply_transpose(
               {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16},
               {11, 13, 17, 19}
             )
  end

  @tag :mat44
  @tag :apply
  test "apply_left( 1:1:16, {11,13,17,19} ) returns { 476, 536, 596, 656} " do
    assert {476, 536, 596, 656} ==
             Graphmath.Mat44.apply_left(
               {11, 13, 17, 19},
               {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16}
             )
  end

  @tag :mat44
  @tag :apply
  test "apply_left_transpose( 1:1:16, {11,13,17,19} ) returns { 164, 404, 644, 884} " do
    assert {164, 404, 644, 884} ==
             Graphmath.Mat44.apply_left_transpose(
               {11, 13, 17, 19},
               {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16}
             )
  end
end
