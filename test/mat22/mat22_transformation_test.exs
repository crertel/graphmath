defmodule GraphmathTest.Mat22.Transformation do
  use ExUnit.Case, async: true
  alias Graphmath.{Mat22, Mat33, Vec2}

  @moduletag :mat22

  for {kind, a, v} <- [
        {:integer, {1, -2, 3, 4}, {2, -3}},
        {:float, {1.0, -2.0, 3.0, 4.0}, {2.0, -3.0}},
        {:mixed, {1, -2.0, 3, 4.0}, {2.0, -3}}
      ] do
    @a a
    @v v

    @tag :apply
    @tag :apply_left_transpose
    test "column-vector products with #{kind} entries" do
      assert Mat22.apply(@a, @v) == {8, -6}
      assert Mat22.apply_left_transpose(@v, @a) == {8, -6}
    end

    @tag :apply
    @tag :apply_transpose
    @tag :apply_left
    @tag :transform_vector
    test "row-vector products with #{kind} entries" do
      assert Mat22.apply_transpose(@a, @v) == {-7, -16}
      assert Mat22.apply_left(@v, @a) == {-7, -16}
      assert Mat22.transform_vector(@a, @v) == {-7, -16}
    end
  end

  @tag :apply
  @tag :transform_vector
  test "fractional matrix and vector entries retain their magnitude" do
    matrix = {0.5, -1.5, 2.25, 3.5}
    assert Mat22.apply(matrix, {1.5, -0.5}) === {1.5, 1.625}
    assert Mat22.transform_vector(matrix, {1.5, -0.5}) === {-0.375, -4.0}
  end

  @tag :make_rotate
  @tag :transform_vector
  test "zero, quarter, half and negative turns follow the right-handed convention" do
    for {theta, expected} <- [
          {0, {3, -4}},
          {0.0, {3, -4}},
          {:math.pi() / 2, {4, 3}},
          {:math.pi(), {-3, 4}},
          {-:math.pi() / 2, {-4, -3}}
        ],
        v <- [{3, -4}, {3.0, -4.0}, {3, -4.0}] do
      rotation = Mat22.make_rotate(theta)
      assert_close(Mat22.transform_vector(rotation, v), expected)
      assert_close(Mat22.apply_left(v, rotation), expected)
      assert_close(Mat22.transform_vector(rotation, v), Vec2.rotate(v, theta))

      assert_close(
        Mat22.transform_vector(rotation, v),
        Mat33.transform_vector(Mat33.make_rotate(theta), v)
      )
    end
  end

  @tag :make_scale
  @tag :make_rotate
  @tag :multiply
  @tag :apply
  @tag :transform_vector
  test "row-vector composition applies the first matrix first" do
    scale = Mat22.make_scale(2.0, -3.0)
    rotation = Mat22.make_rotate(:math.pi() / 2)
    matrix = Mat22.multiply(scale, rotation)

    assert Mat22.transform_vector(scale, {4, -2}) == {8, 6}
    assert_close(Mat22.transform_vector(matrix, {4, -2}), {-6, 8})
    assert_close(Mat22.apply(matrix, {4, -2}), {-4, 12})
    assert_close(Mat22.transform_vector(Mat22.multiply(rotation, scale), {4, -2}), {4, -12})
  end

  @tag :transform_vector
  @tag :inverse
  test "a shear has a known result and an inverse round trip" do
    shear = {1.0, 0.0, 2.0, 1.0}
    assert Mat22.transform_vector(shear, {3.0, -4.0}) === {-5.0, -4.0}
    assert_close(Mat22.transform_vector(Mat22.inverse(shear), {-5.0, -4.0}), {3, -4})
  end

  defp assert_close(actual, expected) do
    assert tuple_size(actual) == tuple_size(expected)

    for {a, b} <- Enum.zip(Tuple.to_list(actual), Tuple.to_list(expected)) do
      assert_in_delta a, b, 1.0e-12
    end
  end
end
