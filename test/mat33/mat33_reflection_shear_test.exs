defmodule GraphmathTest.Mat33.ReflectionShear do
  use ExUnit.Case, async: true
  alias Graphmath.{Mat33, Vec3}

  @moduletag :mat33

  @tag :make_reflect_2d
  test "an offset 2D mirror translates points but not directions" do
    for {normal, offset} <- [
          {{1.0, -1.0}, 2.0},
          {{1, -1}, 2},
          {{1.0, -1}, 2.0},
          {{1.0, -1.0}, 2}
        ] do
      matrix = Mat33.make_reflect_2d(normal, offset)
      assert_close(matrix, {0, 1, 0, 1, 0, 0, 2, -2, 1})
      assert Enum.all?(Tuple.to_list(matrix), &is_float/1)
      assert_close(Mat33.transform_point(matrix, {3, 4}), {6, 1})
      assert_close(Mat33.transform_vector(matrix, {3, 4}), {4, 3})
      assert_close(Mat33.transform_point(matrix, {4, 2}), {4, 2})
      assert_close(Mat33.apply_left({3, 4, 1}, matrix), {6, 1, 1})
      assert_close(Mat33.apply_left({3, 4, 0}, matrix), {4, 3, 0})
    end
  end

  @tag :make_reflect_2d
  test "2D reflection handles coordinate lines and a line through the origin" do
    x = Mat33.make_reflect_2d({1.0, 0.0}, 2.0)
    y = Mat33.make_reflect_2d({0.0, 1.0}, -2.0)
    origin = Mat33.make_reflect_2d({1.0, -1.0}, 0.0)
    assert_close(Mat33.transform_point(x, {5, 3}), {-1, 3})
    assert_close(Mat33.transform_point(y, {5, 3}), {5, -7})
    assert_close(Mat33.transform_point(origin, {5, 3}), {3, 5})
    assert_close(Mat33.transform_vector(origin, {5, 3}), {3, 5})
  end

  @tag :make_reflect_2d
  test "the 2D offset is the line equation constant for a non-unit normal" do
    matrix = Mat33.make_reflect_2d({3.0, 4.0}, 10.0)
    assert_close(matrix, {7 / 25, -24 / 25, 0, -24 / 25, -7 / 25, 0, 12 / 5, 16 / 5, 1})
    assert_close(Mat33.transform_point(matrix, {2, 1}), {2, 1})
    assert_close(Mat33.transform_point(matrix, {5, 0}), {19 / 5, -8 / 5})
    assert_close(Mat33.transform_vector(matrix, {3, 4}), {-3, -4})
    assert_close(Mat33.multiply(matrix, matrix), Mat33.identity())
    assert_in_delta Mat33.determinant(matrix), -1.0, 1.0e-12

    for scale <- [2.0, -2.0, 1.0e-200, 1.0e200] do
      assert_close(Mat33.make_reflect_2d({3 * scale, 4 * scale}, 10 * scale), matrix)
    end
  end

  @tag :make_reflect_3d
  test "3D reflection uses all three spatial coordinates" do
    for normal <- [{1.0, 2.0, 2.0}, {1, 2, 2}, {1.0, 2, 2.0}] do
      matrix = Mat33.make_reflect_3d(normal)
      assert_close(matrix, {7 / 9, -4 / 9, -4 / 9, -4 / 9, 1 / 9, -8 / 9, -4 / 9, -8 / 9, 1 / 9})
      assert Enum.all?(Tuple.to_list(matrix), &is_float/1)
      assert_close(Mat33.apply_left({3, 4, 5}, matrix), {-5 / 3, -16 / 3, -13 / 3})
      assert_close(Mat33.apply_left(normal, matrix), {-1, -2, -2})
      assert_close(Mat33.apply_left({2, -1, 0}, matrix), {2, -1, 0})
    end
  end

  @tag :make_reflect_3d
  test "coordinate-plane mirrors change only the normal component" do
    for {normal, expected} <- [
          {{1.0, 0.0, 0.0}, {-3, 4, 5}},
          {{0.0, 1.0, 0.0}, {3, -4, 5}},
          {{0.0, 0.0, 1.0}, {3, 4, -5}}
        ] do
      assert_close(Mat33.apply_left({3, 4, 5}, Mat33.make_reflect_3d(normal)), expected)
    end
  end

  @tag :make_reflect_3d
  test "3D reflection preserves length, reverses orientation and is its own inverse" do
    matrix = Mat33.make_reflect_3d({1.0, 2.0, 2.0})
    assert_in_delta Vec3.length_squared(Mat33.apply_left({3, 4, 5}, matrix)), 50.0, 1.0e-12
    assert_in_delta Mat33.determinant(matrix), -1.0, 1.0e-12
    assert_close(Mat33.multiply(matrix, matrix), Mat33.identity())
    assert_close(Mat33.inverse(matrix), matrix)

    for scale <- [2.0, -2.0, 1.0e-200, 1.0e200] do
      assert_close(Mat33.make_reflect_3d({scale, 2 * scale, 2 * scale}), matrix)
    end
  end

  @tag :make_reflect_2d
  @tag :make_reflect_3d
  test "both reflection constructors reject zero normals" do
    for normal <- [{0.0, 0.0}, {0, 0}, {0, 0.0}] do
      assert_raise ArithmeticError, fn -> Mat33.make_reflect_2d(normal, 1.0) end
    end

    for normal <- [{0.0, 0.0, 0.0}, {0, 0, 0}, {0, 0.0, 0}] do
      assert_raise ArithmeticError, fn -> Mat33.make_reflect_3d(normal) end
    end
  end

  for {constructor, expected} <- [make_shear_x_2d: {-5, -4}, make_shear_y_2d: {3, 2}] do
    @constructor constructor
    @expected expected
    @tag constructor
    test "#{constructor} shears two spatial coordinates and preserves the homogeneous coordinate" do
      for k <- [2.0, 2] do
        matrix = apply(Mat33, @constructor, [k])
        assert Enum.all?(Tuple.to_list(matrix), &is_float/1)
        assert_close(Mat33.transform_point(matrix, {3, -4}), @expected)
        assert_close(Mat33.transform_vector(matrix, {3, -4}), @expected)
        {x, y} = @expected

        for w <- [0.0, 1.0, 2.5] do
          assert_close(Mat33.apply_left({3, -4, w}, matrix), {x, y, w})
        end

        assert Mat33.determinant(matrix) === 1.0
        assert_close(Mat33.multiply(matrix, apply(Mat33, @constructor, [-k])), Mat33.identity())
      end

      for k <- [0, 0.0], do: assert(apply(Mat33, @constructor, [k]) === Mat33.identity())
    end
  end

  @tag :make_shear_x_2d
  @tag :make_shear_y_2d
  test "2D fractional shears compose with translation in row-vector order" do
    x = Mat33.make_shear_x_2d(0.5)
    y = Mat33.make_shear_y_2d(-0.5)
    assert_close(Mat33.transform_point(x, {3, -4}), {1, -4})
    assert_close(Mat33.transform_point(y, {3, -4}), {3, -5.5})
    translation = Mat33.make_translate(10.0, -2.0)
    assert_close(Mat33.transform_point(Mat33.multiply(x, translation), {3, -4}), {11, -6})
    assert_close(Mat33.transform_point(Mat33.multiply(translation, x), {3, -4}), {10, -6})
    assert_close(Mat33.transform_vector(Mat33.multiply(x, translation), {3, -4}), {1, -4})
  end

  for {constructor, expected} <- [
        make_shear_x_3d: {-15, -3, 4},
        make_shear_y_3d: {2, -5, 4},
        make_shear_z_3d: {2, -3, 16}
      ] do
    @constructor constructor
    @expected expected
    @tag constructor
    test "#{constructor} uses both coefficients and has a known inverse" do
      for {a, b} <- [{3.0, -2.0}, {3, -2}, {3, -2.0}, {3.0, -2}] do
        matrix = apply(Mat33, @constructor, [a, b])
        assert Enum.all?(Tuple.to_list(matrix), &is_float/1)
        assert_close(Mat33.apply_left({2, -3, 4}, matrix), @expected)
        assert Mat33.determinant(matrix) === 1.0
        inverse = apply(Mat33, @constructor, [-a, -b])
        assert_close(Mat33.multiply(matrix, inverse), Mat33.identity())
        assert_close(Mat33.inverse(matrix), inverse)
      end

      for k <- [0, 0.0], do: assert(apply(Mat33, @constructor, [k, k]) === Mat33.identity())
    end
  end

  @tag :make_shear_x_3d
  @tag :make_shear_y_3d
  @tag :make_shear_z_3d
  test "3D fractional coefficients retain their magnitude" do
    assert_close(Mat33.apply_left({2, -3, 4}, Mat33.make_shear_x_3d(0.5, -0.25)), {-0.5, -3, 4})
    assert_close(Mat33.apply_left({2, -3, 4}, Mat33.make_shear_y_3d(0.5, -0.25)), {2, -3, 4})
    assert_close(Mat33.apply_left({2, -3, 4}, Mat33.make_shear_z_3d(0.5, -0.25)), {2, -3, 5.75})
  end

  @tag :make_shear_x_2d
  @tag :make_shear_x_3d
  test "2D and 3D shears explicitly distinguish homogeneous and spatial third coordinates" do
    affine = Mat33.make_shear_x_2d(2.0)
    linear = Mat33.make_shear_x_3d(2.0, 3.0)
    assert_close(Mat33.apply_left({1, 2, 4}, affine), {5, 2, 4})
    assert_close(Mat33.apply_left({1, 2, 4}, linear), {17, 2, 4})
  end

  defp assert_close(actual, expected) do
    assert tuple_size(actual) == tuple_size(expected)

    for {a, b} <- Enum.zip(Tuple.to_list(actual), Tuple.to_list(expected)) do
      assert_in_delta a, b, 1.0e-12
    end
  end
end
