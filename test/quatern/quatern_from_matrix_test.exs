defmodule GraphmathTest.Quatern.From_Matrix_Quatern do
  use ExUnit.Case

  @tag :quatern
  @tag :from_matrix
  #values obtained through another calculator
  test "from_rotation_matrix({1,2,3,4,5,6,7,8,9}) returns {2, 0.25, -0.5, 0.25}" do
    assert {2, 0.25, -0.5, 0.25} == Graphmath.Quatern.from_rotation_matrix({1,2,3,4,5,6,7,8,9})
  end
  
  @tag :quatern
  @tag :from_matrix
  #values obtained through another calculator
  test "from_rotation_matrix({9,8,7,6,5,4,3,2,1}) returns {2, -0.25, 0.5, -0.25}" do
    assert {2, -0.25, 0.5, -0.25} == Graphmath.Quatern.from_rotation_matrix({9,8,7,6,5,4,3,2,1})
  end
end
