defmodule GraphmathTest.Mat22.ReflectionShear do
  use ExUnit.Case, async: true
  alias Graphmath.{Mat22, Vec2}

  @moduletag :mat22

  @tag :make_reflect
  test "axis and diagonal mirrors accept float, integer and mixed normals" do
    for normal <- [{1.0, 0.0}, {1, 0}, {1.0, 0}] do
      matrix = Mat22.make_reflect(normal)
      assert_close(matrix, {-1.0, 0.0, 0.0, 1.0})
      assert Enum.all?(Tuple.to_list(matrix), &is_float/1)
      assert Mat22.transform_vector(matrix, {3.0, -4.0}) === {-3.0, -4.0}
    end

    assert_close(Mat22.make_reflect({0.0, 1.0}), {1.0, 0.0, 0.0, -1.0})
    assert Mat22.make_reflect({1.0, -1.0}) === {0.0, 1.0, 1.0, 0.0}
    assert Mat22.transform_vector(Mat22.make_reflect({1, -1}), {3, -4}) == {-4, 3}
  end

  @tag :make_reflect
  test "an oblique mirror preserves its tangent and reverses its normal" do
    for normal <- [{3.0, 4.0}, {3, 4}, {3, 4.0}] do
      matrix = Mat22.make_reflect(normal)
      assert_close(matrix, {7 / 25, -24 / 25, -24 / 25, -7 / 25})
      assert_close(Mat22.transform_vector(matrix, {4, -3}), {4, -3})
      assert_close(Mat22.transform_vector(matrix, normal), {-3, -4})
      assert_close(Mat22.transform_vector(matrix, {7, -2}), {97 / 25, -154 / 25})
    end
  end

  @tag :make_reflect
  test "normal magnitude and sign do not change the mirror" do
    expected = Mat22.make_reflect({3.0, 4.0})

    for scale <- [2.0, -2.0, 1.0e-200, 1.0e200] do
      assert_close(Mat22.make_reflect({3.0 * scale, 4.0 * scale}), expected)
    end
  end

  @tag :make_reflect
  test "reflection preserves length, reverses orientation and is its own inverse" do
    matrix = Mat22.make_reflect({3.0, 4.0})
    reflected = Mat22.transform_vector(matrix, {7.0, -2.0})
    assert_in_delta Vec2.length_squared(reflected), 53.0, 1.0e-12
    assert_in_delta Mat22.determinant(matrix), -1.0, 1.0e-12
    assert_close(Mat22.multiply(matrix, matrix), Mat22.identity())
    assert_close(Mat22.inverse(matrix), matrix)
  end

  @tag :make_reflect
  test "a zero normal raises ArithmeticError" do
    for normal <- [{0.0, 0.0}, {0, 0}, {0, 0.0}] do
      assert_raise ArithmeticError, fn -> Mat22.make_reflect(normal) end
    end
  end

  @tag :make_shear_x
  test "X shear changes X in proportion to Y" do
    for k <- [2.0, 2] do
      matrix = Mat22.make_shear_x(k)
      assert matrix === {1.0, 0.0, 2.0, 1.0}
      assert Mat22.transform_vector(matrix, {3.0, -4.0}) === {-5.0, -4.0}
      assert Mat22.apply_left({3, -4}, matrix) == {-5, -4}
    end

    assert Mat22.transform_vector(Mat22.make_shear_x(0.5), {3, -4}) === {1.0, -4.0}
  end

  @tag :make_shear_y
  test "Y shear changes Y in proportion to X" do
    for k <- [2.0, 2] do
      matrix = Mat22.make_shear_y(k)
      assert matrix === {1.0, 2.0, 0.0, 1.0}
      assert Mat22.transform_vector(matrix, {3.0, -4.0}) === {3.0, 2.0}
      assert Mat22.apply_left({3, -4}, matrix) == {3, 2}
    end

    assert Mat22.transform_vector(Mat22.make_shear_y(0.5), {3, -4}) === {3.0, -2.5}
  end

  @tag :make_shear_x
  @tag :make_shear_y
  test "shears preserve area and negate their coefficient to invert" do
    for constructor <- [&Mat22.make_shear_x/1, &Mat22.make_shear_y/1] do
      assert constructor.(0.0) === Mat22.identity()
      assert constructor.(0) === Mat22.identity()
      matrix = constructor.(2.5)
      assert Mat22.determinant(matrix) === 1.0
      assert_close(Mat22.multiply(matrix, constructor.(-2.5)), Mat22.identity())
      assert_close(Mat22.inverse(matrix), constructor.(-2.5))
    end
  end

  @tag :make_shear_x
  @tag :make_shear_y
  @tag :multiply
  test "composing shears applies the first matrix first" do
    x = Mat22.make_shear_x(2.0)
    y = Mat22.make_shear_y(-3.0)
    assert Mat22.transform_vector(Mat22.multiply(x, y), {3, -4}) == {-5, 11}
    assert Mat22.transform_vector(Mat22.multiply(y, x), {3, -4}) == {-23, -13}
  end

  defp assert_close(actual, expected) do
    assert tuple_size(actual) == tuple_size(expected)

    for {a, b} <- Enum.zip(Tuple.to_list(actual), Tuple.to_list(expected)) do
      assert_in_delta a, b, 1.0e-12
    end
  end
end
