defmodule GraphmathTest.Quatern.FromMatrixQuatern do
  use ExUnit.Case

  @tag :quatern
  @tag :from_matrix
  # values obtained through another calculator
  test "from_rotation_matrix({1,2,3,4,5,6,7,8,9}) returns {2, 0.25, -0.5, 0.25}" do
    assert {2, 0.25, -0.5, 0.25} ==
             Graphmath.Quatern.from_rotation_matrix({1, 2, 3, 4, 5, 6, 7, 8, 9})
  end

  @tag :quatern
  @tag :from_matrix
  # values obtained through another calculator
  test "from_rotation_matrix({9,8,7,6,5,4,3,2,1}) returns {2, -0.25, 0.5, -0.25}" do
    assert {2, -0.25, 0.5, -0.25} ==
             Graphmath.Quatern.from_rotation_matrix({9, 8, 7, 6, 5, 4, 3, 2, 1})
  end

  @tag :quatern
  @tag :from_matrix
  # values obtained through another calculator
  test "from_rotation_matrix({0,1,0,1,0,0,0,0,-1}) returns {.707, .707,0,0}" do
    {x, y, z, w} = Graphmath.Quatern.from_rotation_matrix({0, 1, 0, 1, 0, 0, 0, 0, -1})

    assert {0.707, 0.707, 0.0, 0.0} ==
             {Float.round(x, 3), Float.round(y, 3), Float.round(z, 3), Float.round(w, 3)}
  end
end
