defmodule GraphmathTest.Mat33.MakeScale do
  use ExUnit.Case

  @tag :mat33
  @tag :make_scale
  test "make_scale( 0 ) returns a matrix of scaling uniformly by 0" do
    assert {0, 0, 0, 0, 0, 0, 0, 0, 0} == Graphmath.Mat33.make_scale(0)
  end

  @tag :mat33
  @tag :make_scale
  test "make_scale( 3.0 ) returns a matrix of scaling uniformly by 3.0" do
    assert {3.0, 0, 0, 0, 3.0, 0, 0, 0, 3.0} == Graphmath.Mat33.make_scale(3.0)
  end

  @tag :mat33
  @tag :make_scale
  test "make_scale( 1, 2, 3 ) returns a matrix of scaling by 1,2,3" do
    assert {1, 0, 0, 0, 2, 0, 0, 0, 3} == Graphmath.Mat33.make_scale(1, 2, 3)
  end
end
