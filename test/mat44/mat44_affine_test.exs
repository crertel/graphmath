defmodule GraphmathTest.Mat44.Affine do
  use ExUnit.Case, async: true
  alias Graphmath.Mat44

  @moduletag :mat44

  @tag :inverse
  @tag :transform_point
  @tag :transform_vector
  test "scale and shear transform points and directions through numeric clauses" do
    for {matrix, v} <- [
          {{2, 1, -1, 0, -1, 3, 2, 0, 1, -2, 4, 0, 5, -7, 11, 1}, {4, -2, 3}},
          {{2.0, 1.0, -1.0, 0.0, -1.0, 3.0, 2.0, 0.0, 1.0, -2.0, 4.0, 0.0, 5.0, -7.0, 11.0, 1.0},
           {4.0, -2.0, 3.0}},
          {{2, 1.0, -1, 0.0, -1, 3.0, 2, 0.0, 1, -2.0, 4, 0.0, 5, -7.0, 11, 1.0}, {4.0, -2, 3}}
        ] do
      assert Mat44.transform_point(matrix, v) == {18, -15, 15}
      assert Mat44.transform_vector(matrix, v) == {13, -8, 4}
      inverse = Mat44.inverse(matrix)
      assert_close(Mat44.transform_point(inverse, Mat44.transform_point(matrix, v)), v)
      assert_close(Mat44.transform_vector(inverse, Mat44.transform_vector(matrix, v)), v)
    end
  end

  @tag :apply_left
  @tag :apply_transpose
  @tag :inverse
  @tag :make_rotate_z
  @tag :make_scale
  @tag :make_translate
  @tag :multiply
  @tag :transform_point
  @tag :transform_vector
  test "nonuniform scale, quarter turn and translation compose left to right" do
    scale = Mat44.make_scale(2.0, -3.0, 0.5, 1.0)
    rotate = Mat44.make_rotate_z(:math.pi() / 2)
    translate = Mat44.make_translate(5.0, -7.0, 11.0)
    composed = scale |> Mat44.multiply(rotate) |> Mat44.multiply(translate)

    assert_close(Mat44.transform_point(scale, {4.0, -2.0, 6.0}), {8, 6, 3})
    assert_close(Mat44.transform_vector(rotate, {8.0, 6.0, 3.0}), {-6, 8, 3})
    assert_close(Mat44.transform_point(composed, {4.0, -2.0, 6.0}), {-1, 1, 14})
    assert_close(Mat44.transform_vector(composed, {4.0, -2.0, 6.0}), {-6, 8, 3})
    assert_close(Mat44.apply_left({4.0, -2.0, 6.0, 1.0}, composed), {-1, 1, 14, 1})
    assert_close(Mat44.apply_transpose(composed, {4.0, -2.0, 6.0, 0.0}), {-6, 8, 3, 0})
    inverse = Mat44.inverse(composed)
    assert_close(Mat44.transform_point(inverse, {-1.0, 1.0, 14.0}), {4, -2, 6})
    assert_close(Mat44.transform_vector(inverse, {-6.0, 8.0, 3.0}), {4, -2, 6})
  end

  @tag :identity
  @tag :make_rotate_x
  @tag :make_rotate_y
  @tag :make_rotate_z
  @tag :transform_vector
  test "quarter turns about all axes preserve the axial coordinate" do
    for v <- [{2, -3, 4}, {2.0, -3.0, 4.0}, {2, -3.0, 4}] do
      assert_close(Mat44.transform_vector(Mat44.make_rotate_x(:math.pi() / 2), v), {2, -4, -3})
      assert_close(Mat44.transform_vector(Mat44.make_rotate_y(:math.pi() / 2), v), {4, -3, -2})
      assert_close(Mat44.transform_vector(Mat44.make_rotate_z(:math.pi() / 2), v), {3, 2, 4})
    end

    for rotate <- [&Mat44.make_rotate_x/1, &Mat44.make_rotate_y/1, &Mat44.make_rotate_z/1] do
      assert rotate.(0) == Mat44.identity()
    end
  end

  @tag :apply_left
  @tag :make_scale
  test "uniform full-matrix scale also scales the homogeneous coordinate" do
    for scalar <- [2, 2.0] do
      assert Mat44.apply_left({1.0, -2.0, 3.0, 1.0}, Mat44.make_scale(scalar)) == {2, -4, 6, 2}
    end
  end

  defp assert_close(actual, expected) do
    assert tuple_size(actual) == tuple_size(expected)

    for {a, b} <- Enum.zip(Tuple.to_list(actual), Tuple.to_list(expected)) do
      assert_in_delta a, b, 1.0e-12
    end
  end
end
