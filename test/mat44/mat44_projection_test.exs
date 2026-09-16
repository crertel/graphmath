defmodule GraphmathTest.Mat44.Projection do
  use ExUnit.Case, async: true
  alias Graphmath.{Mat44, Vec4}

  @moduletag :mat44
  doctest Graphmath.Mat44, only: [perspective: 4, ortho: 6]

  for kind <- [:integer, :float, :mixed] do
    @kind kind

    @tag :perspective
    test "perspective has known entries with #{@kind} parameters" do
      matrix = apply(Mat44, :perspective, numeric([1, 2, 1, 5], @kind))

      assert_close(
        matrix,
        {0.915243860856226, 0, 0, 0, 0, 1.830487721712452, 0, 0, 0, 0, -1.5, -1, 0, 0, -2.5, 0}
      )

      assert Enum.all?(Tuple.to_list(matrix), &is_float/1)
      assert_close(ndc(matrix, {0, 0, -1}), {0, 0, -1})
      assert_close(ndc(matrix, {0, 0, -5}), {0, 0, 1})
    end

    @tag :ortho
    test "an asymmetric orthographic volume has known entries with #{@kind} parameters" do
      matrix = apply(Mat44, :ortho, numeric([-2, 6, -4, 2, 1, 9], @kind))
      assert_close(matrix, {0.25, 0, 0, 0, 0, 1 / 3, 0, 0, 0, 0, -0.25, 0, -0.5, 1 / 3, -1.25, 1})
      assert Enum.all?(Tuple.to_list(matrix), &is_float/1)
      assert_close(Mat44.transform_point(matrix, {-2, -4, -1}), {-1, -1, -1})
      assert_close(Mat44.transform_point(matrix, {6, 2, -9}), {1, 1, 1})
      assert_close(Mat44.transform_point(matrix, {2, -1, -5}), {0, 0, 0})
    end
  end

  @tag :perspective
  test "all near and far frustum corners map to the expected clip boundaries" do
    matrix = Mat44.perspective(:math.pi() / 2, 2.0, 2.0, 10.0)

    for {distance, expected_z} <- [{2.0, -1}, {10.0, 1}], x <- [-1, 1], y <- [-1, 1] do
      assert_close(ndc(matrix, {x * 2 * distance, y * distance, -distance}), {x, y, expected_z})
    end
  end

  @tag :ortho
  test "all eight orthographic corners map to the expected boundaries" do
    matrix = Mat44.ortho(-2.0, 6.0, -4.0, 2.0, 1.0, 9.0)

    for {x, nx} <- [{-2, -1}, {6, 1}],
        {y, ny} <- [{-4, -1}, {2, 1}],
        {z, nz} <- [{-1, -1}, {-9, 1}] do
      assert_close(Mat44.apply_left({x, y, z, 1}, matrix), {nx, ny, nz, 1})
    end
  end

  @tag :perspective
  @tag :ortho
  test "fractional aspect ratios and clipping distances retain their values" do
    perspective = Mat44.perspective(:math.pi() / 2, 0.5, 0.5, 4.5)
    assert_close(ndc(perspective, {0.25, 0.5, -0.5}), {1, 1, -1})
    assert_close(ndc(perspective, {-2.25, -4.5, -4.5}), {-1, -1, 1})
    ortho = Mat44.ortho(-1.5, 2.5, -0.25, 1.75, 0.5, 4.5)
    assert_close(Mat44.transform_point(ortho, {0.5, 0.75, -2.5}), {0, 0, 0})
  end

  @tag :perspective
  test "perspective foreshortening and nonlinear depth use division by w" do
    matrix = Mat44.perspective(:math.pi() / 2, 2.0, 1.0, 9.0)
    assert_close(ndc(matrix, {2, 1, -2}), {0.5, 0.5, 0.125})
    assert_close(ndc(matrix, {2, 1, -4}), {0.25, 0.25, 0.6875})
    assert_close(Mat44.apply_left({2, 1, -4, 1}, matrix), {1, 1, 2.75, 4})
  end

  @tag :perspective
  test "perspective produces w from negative camera-space z without clipping" do
    matrix = Mat44.perspective(:math.pi() / 2, 1.0, 1.0, 3.0)
    assert_close(Mat44.apply_left({0, 0, -2, 1}, matrix), {0, 0, 1, 2})
    assert_close(Mat44.apply_left({0, 0, 2, 1}, matrix), {0, 0, -7, -2})
    assert_close(Mat44.apply_left({0, 0, 0, 1}, matrix), {0, 0, -3, 0})
  end

  @tag :perspective
  test "depth coefficients avoid overflow or underflow from multiplying near and far" do
    for scale <- [1.0e-200, 1.0e200] do
      matrix = Mat44.perspective(:math.pi() / 2, 1.0, scale, 3 * scale)
      assert_close(ndc(matrix, {scale, scale, -2 * scale}), {0.5, 0.5, 0.5})
      assert_close(ndc(matrix, {0, 0, -scale}), {0, 0, -1})
      assert_close(ndc(matrix, {0, 0, -3 * scale}), {0, 0, 1})
    end
  end

  @tag :ortho
  test "reversing a pair of bounds flips that projected axis" do
    for {bounds, expected} <- [
          {[6, -2, -4, 2, 1, 9], {1, -1, -1}},
          {[-2, 6, 2, -4, 1, 9], {-1, 1, -1}},
          {[-2, 6, -4, 2, 9, 1], {-1, -1, 1}},
          {[6, -2, 2, -4, 9, 1], {1, 1, 1}}
        ] do
      matrix = apply(Mat44, :ortho, bounds)
      assert_close(Mat44.transform_point(matrix, {-2, -4, -1}), expected)
    end
  end

  @tag :ortho
  test "orthographic near and far bounds may be zero or negative" do
    for {near, far} <- [{0.0, 10.0}, {-2.0, 2.0}, {-5.0, -1.0}] do
      matrix = Mat44.ortho(-1.0, 1.0, -1.0, 1.0, near, far)
      assert_close(Mat44.transform_point(matrix, {0, 0, -near}), {0, 0, -1})
      assert_close(Mat44.transform_point(matrix, {0, 0, -far}), {0, 0, 1})
    end
  end

  @tag :perspective
  test "invalid perspective volumes raise ArithmeticError through numeric clauses" do
    for kind <- [:integer, :float, :mixed],
        args <- [
          [0, 1, 1, 10],
          [-1, 1, 1, 10],
          [4, 1, 1, 10],
          [1, 0, 1, 10],
          [1, -1, 1, 10],
          [1, 1, 0, 10],
          [1, 1, -1, 10],
          [1, 1, 2, 2],
          [1, 1, 2, 1],
          [1, 1, 1, 0]
        ] do
      assert_raise ArithmeticError, fn -> apply(Mat44, :perspective, numeric(args, kind)) end
    end

    assert_raise ArithmeticError, fn -> Mat44.perspective(:math.pi(), 1.0, 1.0, 10.0) end
  end

  @tag :ortho
  test "zero extent on any orthographic axis raises through numeric clauses" do
    for kind <- [:integer, :float, :mixed],
        args <- [[1, 1, -2, 2, 1, 9], [-2, 2, 1, 1, 1, 9], [-2, 2, -2, 2, 1, 1]] do
      assert_raise ArithmeticError, fn -> apply(Mat44, :ortho, numeric(args, kind)) end
    end
  end

  @tag :perspective
  @tag :ortho
  @tag :multiply
  test "row-vector composition applies the view before projection" do
    # A camera at {0, 0, 5}, looking down -Z, has this view translation.
    view = Mat44.make_translate(0.0, 0.0, -5.0)
    perspective = Mat44.perspective(:math.pi() / 2, 2.0, 1.0, 9.0)
    ortho = Mat44.ortho(-2.0, 6.0, -4.0, 2.0, 1.0, 9.0)
    assert_close(ndc(Mat44.multiply(view, perspective), {2, 1, 1}), {0.25, 0.25, 0.6875})
    assert_close(Mat44.transform_point(Mat44.multiply(view, ortho), {2, 1, 1}), {0, 2 / 3, -0.25})
  end

  @tag :perspective
  @tag :ortho
  @tag :inverse
  test "inverse projection recovers the full homogeneous point" do
    for matrix <- [
          Mat44.perspective(1.0, 2.0, 1.0, 5.0),
          Mat44.ortho(-2.0, 6.0, -4.0, 2.0, 1.0, 9.0)
        ] do
      point = {0.5, -0.75, -3.0, 1.0}
      clip = Mat44.apply_left(point, matrix)
      assert_close(Mat44.apply_left(clip, Mat44.inverse(matrix)), point)
    end
  end

  defp ndc(matrix, point) do
    {x, y, z, w} = Mat44.apply_left(Vec4.from_point3(point), matrix)
    {x / w, y / w, z / w}
  end

  defp numeric(values, kind) do
    values
    |> Enum.with_index()
    |> Enum.map(fn {value, i} ->
      if kind == :float or (kind == :mixed and rem(i, 2) == 0), do: value * 1.0, else: value
    end)
  end

  defp assert_close(actual, expected) do
    assert tuple_size(actual) == tuple_size(expected)

    for {a, b} <- Enum.zip(Tuple.to_list(actual), Tuple.to_list(expected)) do
      assert_in_delta a, b, 1.0e-12
    end
  end
end
