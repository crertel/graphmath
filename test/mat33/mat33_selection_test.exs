defmodule GraphmathTest.Mat33.SelectionMat33 do
  use ExUnit.Case

  @tag :mat33
  @tag :row
  test "row0( 1:1:9 ) returns {1,2,3}" do
    assert {1, 2, 3} == Graphmath.Mat33.row0({1, 2, 3, 4, 5, 6, 7, 8, 9})
  end

  @tag :mat33
  @tag :row
  test "row1( 1:1:9 ) returns {4,5,6}" do
    assert {4, 5, 6} == Graphmath.Mat33.row1({1, 2, 3, 4, 5, 6, 7, 8, 9})
  end

  @tag :mat33
  @tag :row
  test "row2( 1:1:9 ) returns {7,8,9}" do
    assert {7, 8, 9} == Graphmath.Mat33.row2({1, 2, 3, 4, 5, 6, 7, 8, 9})
  end

  @tag :mat33
  @tag :column
  test "column0( 1:1:9 ) returns {1,4,7}" do
    assert {1, 4, 7} == Graphmath.Mat33.column0({1, 2, 3, 4, 5, 6, 7, 8, 9})
  end

  @tag :mat33
  @tag :column
  test "column1( 1:1:9 ) returns {2,5,8}" do
    assert {2, 5, 8} == Graphmath.Mat33.column1({1, 2, 3, 4, 5, 6, 7, 8, 9})
  end

  @tag :mat33
  @tag :column
  test "column2( 1:1:9 ) returns {3,6,9}" do
    assert {3, 6, 9} == Graphmath.Mat33.column2({1, 2, 3, 4, 5, 6, 7, 8, 9})
  end

  @tag :mat33
  @tag :diag
  test "diag( 1:1:9 ) returns {1,5,9}" do
    assert {1, 5, 9} == Graphmath.Mat33.diag({1, 2, 3, 4, 5, 6, 7, 8, 9})
  end

  @tag :mat33
  @tag :at
  test "at( 1:1:9, i, j ) returns element at [i,j] " do
    assert 1 == Graphmath.Mat33.at({1, 2, 3, 4, 5, 6, 7, 8, 9}, 0, 0)
    assert 2 == Graphmath.Mat33.at({1, 2, 3, 4, 5, 6, 7, 8, 9}, 0, 1)
    assert 3 == Graphmath.Mat33.at({1, 2, 3, 4, 5, 6, 7, 8, 9}, 0, 2)

    assert 4 == Graphmath.Mat33.at({1, 2, 3, 4, 5, 6, 7, 8, 9}, 1, 0)
    assert 5 == Graphmath.Mat33.at({1, 2, 3, 4, 5, 6, 7, 8, 9}, 1, 1)
    assert 6 == Graphmath.Mat33.at({1, 2, 3, 4, 5, 6, 7, 8, 9}, 1, 2)

    assert 7 == Graphmath.Mat33.at({1, 2, 3, 4, 5, 6, 7, 8, 9}, 2, 0)
    assert 8 == Graphmath.Mat33.at({1, 2, 3, 4, 5, 6, 7, 8, 9}, 2, 1)
    assert 9 == Graphmath.Mat33.at({1, 2, 3, 4, 5, 6, 7, 8, 9}, 2, 2)
  end
end
