defmodule GraphmathTest.Mat33.TransformPointMat33 do
  use ExUnit.Case

  @tag :mat33
  @tag :transform_point
  test "transform_point with identity returns same point" do
    assert {1.0, 2.0} ==
             Graphmath.Mat33.transform_point(
               {1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0},
               {1.0, 2.0}
             )
  end

  @tag :mat33
  @tag :transform_point
  test "transform_point (1,2) with (1,1) translation returns (2,3)" do
    assert {2.0, 3.0} ==
             Graphmath.Mat33.transform_point(
               {1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 1.0, 1.0, 1.0},
               {1.0, 2.0}
             )
  end
end
