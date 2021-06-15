defmodule GraphmathTest.Mat33.MakeRotate do
  use ExUnit.Case

  @tag :mat33
  @tag :make_rotate
  test "make_rotate( 0 ) returns a matrix of 0 radians about the +Z access" do
    assert {1, 0, 0, 0, 1, 0, 0, 0, 1} == Graphmath.Mat33.make_rotate(0)
  end

  @tag :mat33
  @tag :make_rotate
  test "make_rotate( PI/2 ) returns a matrix of PI/2 radians about the +Z access" do
    res = Graphmath.Mat33.make_rotate(:math.pi() / 2.0)

    assert {0, 1, 0, -1, 0, 0, 0, 0, 1} == Graphmath.Mat33.round(res, 0)
  end
end
