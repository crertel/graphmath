defmodule GraphmathTest.Mat44.TransformVectorMat44 do
  use ExUnit.Case

  @tag :mat44
  @tag :transform_vector
  test "transform_vector with identity returns same vector" do
    assert {1.0, 2.0, 3.0} ==
             Graphmath.Mat44.transform_vector(
               {1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0},
               {1.0, 2.0, 3.0}
             )
  end

  @tag :mat44
  @tag :transform_vector
  test "transform_vector (1,2,3) with (1,1,1) tranlation returns (1,2,3)" do
    assert {1.0, 2.0, 3.0} ==
             Graphmath.Mat44.transform_vector(
               {1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 1.0, 1.0, 1.0, 1.0},
               {1.0, 2.0, 3.0}
             )
  end
end
