defmodule GraphmathTest.Mat33.Affine do
  use ExUnit.Case, async: true
  alias Graphmath.Mat33

  @moduletag :mat33

  @tag :inverse
  @tag :transform_point
  @tag :transform_vector
  test "scale and shear transform points and directions through numeric clauses" do
    for {matrix, v} <- [
          {{2, 1, 0, -1, 3, 0, 5, -7, 1}, {4, -2}},
          {{2.0, 1.0, 0.0, -1.0, 3.0, 0.0, 5.0, -7.0, 1.0}, {4.0, -2.0}},
          {{2, 1.0, 0, -1.0, 3, 0.0, 5, -7.0, 1}, {4.0, -2}}
        ] do
      assert Mat33.transform_point(matrix, v) == {15, -9}
      assert Mat33.transform_vector(matrix, v) == {10, -2}
      inverse = Mat33.inverse(matrix)
      assert_close(Mat33.transform_point(inverse, Mat33.transform_point(matrix, v)), v)
      assert_close(Mat33.transform_vector(inverse, Mat33.transform_vector(matrix, v)), v)
    end
  end

  @tag :apply_left
  @tag :apply_transpose
  @tag :inverse
  @tag :make_rotate
  @tag :make_scale
  @tag :make_translate
  @tag :multiply
  @tag :transform_point
  @tag :transform_vector
  test "nonuniform scale, quarter turn and translation compose left to right" do
    scale = Mat33.make_scale(2.0, -3.0, 1.0)
    rotate = Mat33.make_rotate(:math.pi() / 2)
    translate = Mat33.make_translate(5.0, -7.0)
    composed = scale |> Mat33.multiply(rotate) |> Mat33.multiply(translate)

    assert_close(Mat33.transform_point(scale, {4.0, -2.0}), {8, 6})
    assert_close(Mat33.transform_vector(rotate, {8.0, 6.0}), {-6, 8})
    assert_close(Mat33.transform_point(composed, {4.0, -2.0}), {-1, 1})
    assert_close(Mat33.transform_vector(composed, {4.0, -2.0}), {-6, 8})
    assert_close(Mat33.apply_left({4.0, -2.0, 1.0}, composed), {-1, 1, 1})
    assert_close(Mat33.apply_transpose(composed, {4.0, -2.0, 0.0}), {-6, 8, 0})
    inverse = Mat33.inverse(composed)
    assert_close(Mat33.transform_point(inverse, {-1.0, 1.0}), {4, -2})
    assert_close(Mat33.transform_vector(inverse, {-6.0, 8.0}), {4, -2})
  end

  @tag :apply_left
  @tag :identity
  @tag :make_rotate
  @tag :make_scale
  test "uniform full-matrix scale also scales the homogeneous coordinate" do
    for scalar <- [2, 2.0] do
      assert Mat33.apply_left({1.0, -2.0, 1.0}, Mat33.make_scale(scalar)) == {2, -4, 2}
    end

    assert Mat33.make_rotate(0) == Mat33.identity()
  end

  defp assert_close(actual, expected) do
    assert tuple_size(actual) == tuple_size(expected)

    for {a, b} <- Enum.zip(Tuple.to_list(actual), Tuple.to_list(expected)) do
      assert_in_delta a, b, 1.0e-12
    end
  end
end
