defmodule GraphmathTest.Mat44.MakeScale do
  use ExUnit.Case

  @tag :mat44
  @tag :make_scale
  test "make_scale( 3 ) returns a matrix of scaling uniformly by 3" do
    assert {3, 0, 0, 0, 0, 3, 0, 0, 0, 0, 3, 0, 0, 0, 0, 3} == Graphmath.Mat44.make_scale(3)
  end

  @tag :mat44
  @tag :make_scale
  test "make_scale( 1, 2, 3, 4 ) returns a matrix of scaling by 1,2,3,4" do
    assert {1, 0, 0, 0, 0, 2, 0, 0, 0, 0, 3, 0, 0, 0, 0, 4} ==
             Graphmath.Mat44.make_scale(1, 2, 3, 4)
  end
end
