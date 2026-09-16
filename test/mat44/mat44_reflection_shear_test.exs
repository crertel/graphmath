defmodule GraphmathTest.Mat44.ReflectionShear do
  use ExUnit.Case, async: true
  alias Graphmath.{Mat44, Vec3}

  @moduletag :mat44

  @tag :make_reflect
  test "an offset plane reflects points and directions with the same linear part" do
    for {normal, offset} <- [
          {{1.0, 2.0, 2.0}, 3.0},
          {{1, 2, 2}, 3},
          {{1.0, 2, 2.0}, 3.0},
          {{1.0, 2.0, 2.0}, 3}
        ] do
      matrix = Mat44.make_reflect(normal, offset)

      assert_close(matrix, {
        7 / 9,
        -4 / 9,
        -4 / 9,
        0,
        -4 / 9,
        1 / 9,
        -8 / 9,
        0,
        -4 / 9,
        -8 / 9,
        1 / 9,
        0,
        2 / 3,
        4 / 3,
        4 / 3,
        1
      })

      assert Enum.all?(Tuple.to_list(matrix), &is_float/1)
      assert_close(Mat44.transform_point(matrix, {3, 4, 5}), {-1, -4, -3})
      assert_close(Mat44.transform_vector(matrix, {3, 4, 5}), {-5 / 3, -16 / 3, -13 / 3})
      assert_close(Mat44.transform_point(matrix, {3, 0, 0}), {3, 0, 0})
      assert_close(Mat44.transform_vector(matrix, normal), {-1, -2, -2})
      assert_close(Mat44.transform_vector(matrix, {2, -1, 0}), {2, -1, 0})
    end
  end

  @tag :make_reflect
  test "reflection preserves the fourth coordinate and weights translation by it" do
    matrix = Mat44.make_reflect({1.0, 2.0, 2.0}, 3.0)
    assert_close(Mat44.apply_left({3, 4, 5, 1}, matrix), {-1, -4, -3, 1})
    assert_close(Mat44.apply_left({3, 4, 5, 0}, matrix), {-5 / 3, -16 / 3, -13 / 3, 0})
    assert_close(Mat44.apply_left({3, 4, 5, 2.5}, matrix), {0, -2, -1, 2.5})
  end

  @tag :make_reflect
  test "coordinate-plane reflections change only the normal component" do
    for {normal, offset, expected} <- [
          {{1.0, 0.0, 0.0}, 2.0, {-1, 3, 6}},
          {{0.0, 1.0, 0.0}, -2.0, {5, -7, 6}},
          {{0.0, 0.0, 1.0}, 2.0, {5, 3, -2}}
        ] do
      matrix = Mat44.make_reflect(normal, offset)
      assert_close(Mat44.transform_point(matrix, {5, 3, 6}), expected)
    end
  end

  @tag :make_reflect
  test "normal and offset scale together without changing the plane" do
    expected = Mat44.make_reflect({1.0, 2.0, 2.0}, 3.0)

    for scale <- [2.0, -2.0, 1.0e-200, 1.0e200] do
      assert_close(Mat44.make_reflect({scale, 2 * scale, 2 * scale}, 3 * scale), expected)
    end
  end

  @tag :make_reflect
  test "reflection reverses signed distance and preserves distances between points" do
    normal = {1.0, 2.0, 2.0}
    matrix = Mat44.make_reflect(normal, 3.0)
    a = {3.0, 4.0, 5.0}
    b = {-2.0, 1.0, -3.0}
    reflected_a = Mat44.transform_point(matrix, a)
    reflected_b = Mat44.transform_point(matrix, b)
    assert_in_delta Vec3.dot(normal, reflected_a) - 3.0, -(Vec3.dot(normal, a) - 3.0), 1.0e-12
    assert_in_delta Vec3.dot(normal, reflected_b) - 3.0, -(Vec3.dot(normal, b) - 3.0), 1.0e-12

    assert_in_delta Vec3.length_squared(Vec3.subtract(reflected_a, reflected_b)),
                    Vec3.length_squared(Vec3.subtract(a, b)),
                    1.0e-12
  end

  @tag :make_reflect
  test "reflection reverses orientation and is its own inverse" do
    matrix = Mat44.make_reflect({1.0, 2.0, 2.0}, 3.0)
    assert_in_delta Mat44.determinant(matrix), -1.0, 1.0e-12
    assert_close(Mat44.multiply(matrix, matrix), Mat44.identity())
    assert_close(Mat44.inverse(matrix), matrix)
  end

  @tag :make_reflect
  test "a plane through the origin acts equally on points and directions" do
    matrix = Mat44.make_reflect({1.0, 2.0, 2.0}, 0.0)
    assert_close(Mat44.transform_point(matrix, {3, 4, 5}), {-5 / 3, -16 / 3, -13 / 3})
    assert_close(Mat44.transform_vector(matrix, {3, 4, 5}), {-5 / 3, -16 / 3, -13 / 3})
  end

  @tag :make_reflect
  test "a zero normal raises ArithmeticError" do
    for normal <- [{0.0, 0.0, 0.0}, {0, 0, 0}, {0, 0.0, 0}], offset <- [0.0, 1] do
      assert_raise ArithmeticError, fn -> Mat44.make_reflect(normal, offset) end
    end
  end

  for {constructor, expected} <- [
        make_shear_x: {-15, -3, 4},
        make_shear_y: {2, -5, 4},
        make_shear_z: {2, -3, 16}
      ] do
    @constructor constructor
    @expected expected
    @tag constructor
    test "#{constructor} uses both spatial coefficients and preserves the fourth coordinate" do
      for {a, b} <- [{3.0, -2.0}, {3, -2}, {3, -2.0}, {3.0, -2}] do
        matrix = apply(Mat44, @constructor, [a, b])
        assert Enum.all?(Tuple.to_list(matrix), &is_float/1)
        assert_close(Mat44.transform_point(matrix, {2, -3, 4}), @expected)
        assert_close(Mat44.transform_vector(matrix, {2, -3, 4}), @expected)
        {x, y, z} = @expected

        for w <- [0.0, 1.0, 2.5] do
          assert_close(Mat44.apply_left({2, -3, 4, w}, matrix), {x, y, z, w})
        end

        assert Mat44.determinant(matrix) === 1.0
        inverse = apply(Mat44, @constructor, [-a, -b])
        assert_close(Mat44.multiply(matrix, inverse), Mat44.identity())
        assert_close(Mat44.inverse(matrix), inverse)
      end

      for k <- [0, 0.0], do: assert(apply(Mat44, @constructor, [k, k]) === Mat44.identity())
    end
  end

  @tag :make_shear_x
  @tag :make_shear_y
  @tag :make_shear_z
  test "fractional coefficients retain their magnitude" do
    assert_close(Mat44.transform_point(Mat44.make_shear_x(0.5, -0.25), {2, -3, 4}), {-0.5, -3, 4})
    assert_close(Mat44.transform_point(Mat44.make_shear_y(0.5, -0.25), {2, -3, 4}), {2, -3, 4})
    assert_close(Mat44.transform_point(Mat44.make_shear_z(0.5, -0.25), {2, -3, 4}), {2, -3, 5.75})
  end

  @tag :make_shear_x
  @tag :make_shear_y
  test "shear composition follows row-vector order" do
    x = Mat44.make_shear_x(2.0, -1.0)
    y = Mat44.make_shear_y(-3.0, 2.0)
    assert_close(Mat44.transform_point(Mat44.multiply(x, y), {2, -3, 4}), {-8, 29, 4})
    assert_close(Mat44.transform_point(Mat44.multiply(y, x), {2, -3, 4}), {-4, -1, 4})
  end

  @tag :make_shear_x
  @tag :make_translate
  test "composing shear and translation distinguishes points from directions" do
    shear = Mat44.make_shear_x(3.0, -2.0)
    translation = Mat44.make_translate(10.0, 2.0, -1.0)
    composed = Mat44.multiply(shear, translation)
    assert_close(Mat44.transform_point(composed, {2, -3, 4}), {-5, -1, 3})
    assert_close(Mat44.transform_vector(composed, {2, -3, 4}), {-15, -3, 4})
    assert_close(Mat44.apply_left({2, -3, 4, 1}, composed), {-5, -1, 3, 1})
    assert_close(Mat44.apply_left({2, -3, 4, 0}, composed), {-15, -3, 4, 0})

    assert_close(
      Mat44.transform_point(Mat44.multiply(translation, shear), {2, -3, 4}),
      {3, -1, 3}
    )
  end

  defp assert_close(actual, expected) do
    assert tuple_size(actual) == tuple_size(expected)

    for {a, b} <- Enum.zip(Tuple.to_list(actual), Tuple.to_list(expected)) do
      assert_in_delta a, b, 1.0e-12
    end
  end
end
