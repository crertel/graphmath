defmodule GraphmathTest.Mat44.SelectionMat44 do
  use ExUnit.Case

  @tag :mat44
  @tag :row
  test "row0( 1:1:16 ) returns {1,2,3,4}" do
    assert {1, 2, 3, 4} ==
             Graphmath.Mat44.row0({1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16})
  end

  @tag :mat44
  @tag :row
  test "row1( 1:1:16 ) returns {5,6,7,8}" do
    assert {5, 6, 7, 8} ==
             Graphmath.Mat44.row1({1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16})
  end

  @tag :mat44
  @tag :row
  test "row2( 1:1:16 ) returns {9,10,11,12}" do
    assert {9, 10, 11, 12} ==
             Graphmath.Mat44.row2({1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16})
  end

  @tag :mat44
  @tag :row
  test "row3( 1:1:16 ) returns {13,14,15,16}" do
    assert {13, 14, 15, 16} ==
             Graphmath.Mat44.row3({1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16})
  end

  @tag :mat44
  @tag :column
  test "column0( 1:1:16 ) returns {1,5,9,13}" do
    assert {1, 5, 9, 13} ==
             Graphmath.Mat44.column0({1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16})
  end

  @tag :mat44
  @tag :column
  test "column1( 1:1:16 ) returns {2,6,10,14}" do
    assert {2, 6, 10, 14} ==
             Graphmath.Mat44.column1({1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16})
  end

  @tag :mat44
  @tag :column
  test "column2( 1:1:16 ) returns {2,6,10,14}" do
    assert {3, 7, 11, 15} ==
             Graphmath.Mat44.column2({1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16})
  end

  @tag :mat44
  @tag :column
  test "column3( 1:1:16 ) returns {4,8,12,16}" do
    assert {4, 8, 12, 16} ==
             Graphmath.Mat44.column3({1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16})
  end

  @tag :mat44
  @tag :diag
  test "diag( 1:1:16 ) returns {1,6,11,16}" do
    assert {1, 6, 11, 16} ==
             Graphmath.Mat44.diag({1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16})
  end

  @tag :mat44
  @tag :at
  test "at( 1:1:16, i, j ) returns element at [i,j] " do
    a = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16}

    assert 1 == Graphmath.Mat44.at(a, 0, 0)
    assert 2 == Graphmath.Mat44.at(a, 0, 1)
    assert 3 == Graphmath.Mat44.at(a, 0, 2)
    assert 4 == Graphmath.Mat44.at(a, 0, 3)

    assert 5 == Graphmath.Mat44.at(a, 1, 0)
    assert 6 == Graphmath.Mat44.at(a, 1, 1)
    assert 7 == Graphmath.Mat44.at(a, 1, 2)
    assert 8 == Graphmath.Mat44.at(a, 1, 3)

    assert 9 == Graphmath.Mat44.at(a, 2, 0)
    assert 10 == Graphmath.Mat44.at(a, 2, 1)
    assert 11 == Graphmath.Mat44.at(a, 2, 2)
    assert 12 == Graphmath.Mat44.at(a, 2, 3)

    assert 13 == Graphmath.Mat44.at(a, 3, 0)
    assert 14 == Graphmath.Mat44.at(a, 3, 1)
    assert 15 == Graphmath.Mat44.at(a, 3, 2)
    assert 16 == Graphmath.Mat44.at(a, 3, 3)
  end
end
