defmodule Graphmath.Mat33.Transform_Vector_Mat33 do
  use ExUnit.Case

  @tag :mat33
  @tag :transform_vector
  test "transform_vector (1,2) with identity returns same vector" do
    assert {1.0, 2.0} ==
             Graphmath.Mat33.transform_vector(
               {1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0},
               {1.0, 2.0}
             )
  end

  @tag :mat33
  @tag :transform_vector
  test "transform_vector (1,2) with (1,1) translation returns same vector" do
    assert {1.0, 2.0} ==
             Graphmath.Mat33.transform_vector(
               {1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 1.0, 1.0, 1.0},
               {1.0, 2.0}
             )
  end
end
