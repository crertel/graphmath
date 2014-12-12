defmodule Graphmath.Mat33.Tuple.Selection_Mat33 do
  use ExUnit.Case
  
  @tag :mat33
  @tag :row
  test "row0( 1:1:9 ) returns {1,2,3}" do
    assert { 1, 2, 3 } == Graphmath.Mat33.Tuple.row0( {1,2,3,4,5,6,7,8,9} )
  end

  @tag :mat33
  @tag :row
  test "row1( 1:1:9 ) returns {4,5,6}" do
    assert { 4, 5, 6 } == Graphmath.Mat33.Tuple.row1( {1,2,3,4,5,6,7,8,9} )
  end
  
  @tag :mat33
  @tag :row
  test "row2( 1:1:9 ) returns {7,8,9}" do
    assert { 7, 8, 9 } == Graphmath.Mat33.Tuple.row2( {1,2,3,4,5,6,7,8,9} )
  end
  
  @tag :mat33
  @tag :column
  test "column0( 1:1:9 ) returns {1,4,7}" do
    assert { 1, 4, 7 } == Graphmath.Mat33.Tuple.column0( {1,2,3,4,5,6,7,8,9} )
  end
  
  @tag :mat33
  @tag :column
  test "column1( 1:1:9 ) returns {2,5,8}" do
    assert { 2, 5, 8 } == Graphmath.Mat33.Tuple.column1( {1,2,3,4,5,6,7,8,9} )
  end
  
  @tag :mat33
  @tag :column
  test "column2( 1:1:9 ) returns {3,6,9}" do
    assert { 3, 6, 9 } == Graphmath.Mat33.Tuple.column2( {1,2,3,4,5,6,7,8,9} )
  end
end
