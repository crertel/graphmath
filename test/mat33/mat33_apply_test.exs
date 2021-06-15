defmodule GraphmathTest.Mat33.ApplyMat33 do
  use ExUnit.Case

  @tag :mat33
  @tag :apply
  test "apply( 1:1:9, {13,17,19} ) returns { 104, 251, 398} " do
    assert {104, 251, 398} ==
             Graphmath.Mat33.apply(
               {1, 2, 3, 4, 5, 6, 7, 8, 9},
               {13, 17, 19}
             )
  end

  @tag :mat33
  @tag :apply
  test "apply_transpose( 1:1:9, {13,17,19} ) returns { 104, 251, 398} " do
    assert {214, 263, 312} ==
             Graphmath.Mat33.apply_transpose(
               {1, 2, 3, 4, 5, 6, 7, 8, 9},
               {13, 17, 19}
             )
  end

  @tag :mat33
  @tag :apply
  test "apply_left( 1:1:9, {13,17,19} ) returns { 104, 251, 398} " do
    assert {214, 263, 312} ==
             Graphmath.Mat33.apply_left(
               {13, 17, 19},
               {1, 2, 3, 4, 5, 6, 7, 8, 9}
             )
  end

  @tag :mat33
  @tag :apply
  test "apply_left_transpose( 1:1:9, {13,17,19} ) returns { 104, 251, 398} " do
    assert {104, 251, 398} ==
             Graphmath.Mat33.apply_left_transpose(
               {13, 17, 19},
               {1, 2, 3, 4, 5, 6, 7, 8, 9}
             )
  end
end
