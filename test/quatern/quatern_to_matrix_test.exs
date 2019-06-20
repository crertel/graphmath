defmodule GraphmathTest.Quatern.ToMatrixQuatern do
  use ExUnit.Case

  @tag :quatern
  @tag :to_matrix
  # values obtained through another calculator
  test "to_rotation_matrix_33({2, 0.25, -0.5, 0.25}) returns {0.375,-1.25,-1.875,0.75,0.75,-1.25,2.125,0.75,0.375}" do
    assert {0.375, -1.25, -1.875, 0.75, 0.75, -1.25, 2.125, 0.75, 0.375} ==
             Graphmath.Quatern.to_rotation_matrix_33({2, 0.25, -0.5, 0.25})
  end

  @tag :quatern
  @tag :to_matrix
  # values obtained through another calculator
  test "to_rotation_matrix_33({2, -0.25, 0.5, -0.25}) returns {0.375,0.75,2.125,-1.25,0.75,0.75,-1.875,-1.25,0.375}" do
    assert {0.375, 0.75, 2.125, -1.25, 0.75, 0.75, -1.875, -1.25, 0.375} ==
             Graphmath.Quatern.to_rotation_matrix_33({2, -0.25, 0.5, -0.25})
  end

  @tag :quatern
  @tag :to_matrix
  # values obtained through another calculator
  test "to_rotation_matrix_44({2, 0.25, -0.5, 0.25}) returns {0.375,-1.25,-1.875,0.75,0.75,-1.25,2.125,0.75,0.375}" do
    assert {0.375, -1.25, -1.875, 0.0, 0.75, 0.75, -1.25, 0.0, 2.125, 0.75, 0.375, 0.0, 0.0, 0.0,
            0.0,
            1.0} ==
             Graphmath.Quatern.to_rotation_matrix_44({2, 0.25, -0.5, 0.25})
  end

  @tag :quatern
  @tag :to_matrix
  # values obtained through another calculator
  test "to_rotation_matrix_44({2, -0.25, 0.5, -0.25}) returns {0.375,0.75,2.125,-1.25,0.75,0.75,-1.875,-1.25,0.375}" do
    assert {0.375, 0.75, 2.125, 0.0, -1.25, 0.75, 0.75, 0.0, -1.875, -1.25, 0.375, 0.0, 0.0, 0.0,
            0.0,
            1.0} ==
             Graphmath.Quatern.to_rotation_matrix_44({2, -0.25, 0.5, -0.25})
  end
end
