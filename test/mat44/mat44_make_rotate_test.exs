defmodule GraphmathTest.Mat44.MakeRotate do
  use ExUnit.Case

  @tag :mat44
  @tag :make_rotate_x
  test "make_rotate_x( 0 ) returns a matrix of rotation 0 radians about the X axis (identity)." do
    assert {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1} ==
             Graphmath.Mat44.round(Graphmath.Mat44.make_rotate_x(0), 0)
  end

  @tag :mat44
  @tag :make_rotate_x
  test "make_rotate_x( PI/2 ) returns a matrix of rotation PI/2 radians about the X axis." do
    assert {1, 0, 0, 0, 0, 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1} ==
             Graphmath.Mat44.round(Graphmath.Mat44.make_rotate_x(:math.pi() / 2.0), 0)
  end

  @tag :mat44
  @tag :make_rotate_y
  test "make_rotate_y( 0 ) returns a matrix of rotation 0 radians about the Y axis (identity)." do
    assert {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1} ==
             Graphmath.Mat44.round(Graphmath.Mat44.make_rotate_y(0), 0)
  end

  @tag :mat44
  @tag :make_rotate_y
  test "make_rotate_y( PI/2 ) returns a matrix of rotation PI/2 radians about the Y axis." do
    assert {0, 0, 1, 0, 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 1} ==
             Graphmath.Mat44.round(Graphmath.Mat44.make_rotate_y(:math.pi() / 2.0), 0)
  end

  @tag :mat44
  @tag :make_rotate_z
  test "make_rotate_z( 0 ) returns a matrix of rotation 0 radians about the Z axis (identity)." do
    assert {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1} ==
             Graphmath.Mat44.round(Graphmath.Mat44.make_rotate_z(0), 0)
  end

  @tag :mat44
  @tag :make_rotate_z
  test "make_rotate_z( PI/2 ) returns a matrix of rotation PI/2 radians about the Z axis." do
    assert {0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1} ==
             Graphmath.Mat44.round(Graphmath.Mat44.make_rotate_z(:math.pi() / 2.0), 0)
  end
end
