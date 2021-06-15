defmodule GraphmathTest.Mat44.TransformPointMat44 do
  use ExUnit.Case

  @tag :mat44
  @tag :transform_point
  test "transform_point with identity returns same point" do
    assert {1.0, 2.0, 3.0} ==
             Graphmath.Mat44.transform_point(
               {1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0},
               {1.0, 2.0, 3.0}
             )
  end

  @tag :mat44
  @tag :transform_point
  test "transform_point (1,2,3) with (1,1,1) tranlation returns (2,3,4)" do
    assert {2.0, 3.0, 4.0} ==
             Graphmath.Mat44.transform_point(
               {1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 1.0, 1.0, 1.0, 1.0},
               {1.0, 2.0, 3.0}
             )
  end
end
