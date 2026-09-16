defmodule GraphmathTest.Mat44.Billboard do
  use ExUnit.Case, async: true
  alias Graphmath.{Mat44, Vec3}

  @moduletag :mat44

  for kind <- [:integer, :float, :mixed] do
    @kind kind

    @tag :make_billboard
    test "an oblique spherical billboard faces the camera with #{@kind} inputs" do
      position = numeric({4, -5, 6}, @kind)
      camera = numeric({6, -7, 7}, @kind)
      up = numeric({6, -3, 0}, @kind)
      matrix = Mat44.make_billboard(position, camera, up)

      assert_close(
        matrix,
        {1 / 3, 2 / 3, 2 / 3, 0, 2 / 3, 1 / 3, -2 / 3, 0, -2 / 3, 2 / 3, -1 / 3, 0, 4, -5, 6, 1}
      )

      assert_close(Mat44.transform_point(matrix, {0, 0, 0}), position)
      assert_close(Mat44.transform_point(matrix, {3, -2, 4}), {1, -1, 8})
      assert_close(Mat44.transform_vector(matrix, {0, 0, -1}), {2 / 3, -2 / 3, 1 / 3})
      assert_close(Mat44.transform_vector(matrix, {0, 1, 0}), {2 / 3, 1 / 3, -2 / 3})
      assert Enum.all?(Tuple.to_list(matrix), &is_float/1)
      assert_rigid(matrix)
    end

    @tag :make_billboard_axis
    test "a cylindrical billboard keeps its axis with #{@kind} inputs" do
      position = numeric({2, -3, 4}, @kind)
      camera = numeric({5, 7, 0}, @kind)
      axis = numeric({0, 2, 0}, @kind)
      matrix = Mat44.make_billboard_axis(position, camera, axis)
      assert_close(matrix, {0.8, 0, 0.6, 0, 0, 1, 0, 0, -0.6, 0, 0.8, 0, 2, -3, 4, 1})
      assert_close(Mat44.transform_point(matrix, {0, 0, 0}), position)
      assert_close(Mat44.transform_point(matrix, {5, 2, -5}), {9, -1, 3})
      assert_close(Mat44.transform_vector(matrix, {0, 0, -1}), {0.6, 0, -0.8})
      assert_close(Mat44.transform_vector(matrix, {0, 1, 0}), {0, 1, 0})
      assert_close(Mat44.make_billboard_axis(position, {5, -20, 0}, axis), matrix)
      assert Enum.all?(Tuple.to_list(matrix), &is_float/1)
      assert_rigid(matrix)
    end
  end

  @tag :make_billboard
  @tag :make_billboard_axis
  test "every signed coordinate axis can supply the up direction or rotation axis" do
    origin = {0.0, 0.0, 0.0}

    for {axis, forward} <- [
          {{1, 0, 0}, {0, 0, -1}},
          {{-1, 0, 0}, {0, 0, -1}},
          {{0, 1, 0}, {0, 0, -1}},
          {{0, -1, 0}, {0, 0, -1}},
          {{0, 0, 1}, {1, 0, 0}},
          {{0, 0, -1}, {1, 0, 0}}
        ],
        constructor <- [&Mat44.make_billboard/3, &Mat44.make_billboard_axis/3] do
      matrix = constructor.(origin, forward, axis)
      assert_close(Mat44.transform_vector(matrix, {0, 0, -1}), forward)
      assert_close(Mat44.transform_vector(matrix, {0, 1, 0}), axis)
      assert_rigid(matrix)
    end
  end

  @tag :make_billboard_axis
  test "an oblique axis is preserved while facing the projected camera direction" do
    position = {4.0, -5.0, 6.0}
    camera = {10.0, -5.0, 3.0}
    axis = {2.0, 1.0, -2.0}
    matrix = Mat44.make_billboard_axis(position, camera, axis)
    assert_close(Mat44.transform_point(matrix, {3, -2, 4}), {1, -1, 8})
    assert_close(Mat44.transform_vector(matrix, {0, 0, -1}), {2 / 3, -2 / 3, 1 / 3})
    assert_close(Mat44.transform_vector(matrix, {0, 1, 0}), {2 / 3, 1 / 3, -2 / 3})

    assert_close(
      Mat44.make_billboard_axis(position, Vec3.add(camera, Vec3.scale(axis, 7.0)), axis),
      matrix
    )

    assert_rigid(matrix)
  end

  @tag :make_billboard
  @tag :make_billboard_axis
  test "spherical billboards tilt toward elevated cameras while cylindrical ones keep their axis" do
    position = {0.0, 0.0, 0.0}
    camera = {0.0, 3.0, -4.0}
    up = {0.0, 1.0, 0.0}
    sphere = Mat44.make_billboard(position, camera, up)
    cylinder = Mat44.make_billboard_axis(position, camera, up)
    assert_close(Mat44.transform_vector(sphere, {0, 0, -1}), {0, 0.6, -0.8})
    assert_close(Mat44.transform_vector(sphere, {0, 1, 0}), {0, 0.8, 0.6})
    assert_close(cylinder, Mat44.identity())
  end

  @tag :make_billboard
  @tag :look_at
  test "billboard and view composition places the face toward the camera" do
    position = {4.0, -5.0, 6.0}
    camera = {6.0, -7.0, 7.0}
    up = {6.0, -3.0, 0.0}
    model = Mat44.make_billboard(position, camera, up)
    view = Mat44.look_at(camera, position, up)
    composed = Mat44.multiply(model, view)
    assert_close(Mat44.transform_point(composed, {0, 0, 0}), {0, 0, -3})
    assert_close(Mat44.transform_vector(composed, {0, 0, -1}), {0, 0, 1})
    assert_close(Mat44.transform_vector(composed, {0, 1, 0}), {0, 1, 0})
    assert_close(Mat44.apply_left({0, 0, 0, 1}, composed), {0, 0, -3, 1})
    assert_close(Mat44.apply_left({0, 0, -1, 0}, composed), {0, 0, 1, 0})
  end

  @tag :make_billboard
  @tag :make_billboard_axis
  test "fractional positions and very large or small directions retain their values" do
    position = {0.5, -1.25, 2.75}
    camera = {0.5, -1.25, 1.75}

    for constructor <- [&Mat44.make_billboard/3, &Mat44.make_billboard_axis/3] do
      assert_close(
        constructor.(position, camera, {0.0, 1.0, 0.0}),
        Mat44.make_translate(0.5, -1.25, 2.75)
      )

      for scale <- [1.0e-200, 1.0e200] do
        matrix = constructor.({0.0, 0.0, 0.0}, {0.0, 0.0, -scale}, {0.0, scale, 0.0})
        assert_close(matrix, Mat44.identity())
      end
    end
  end

  @tag :make_billboard
  @tag :make_billboard_axis
  test "coincident positions, zero axes and parallel facing directions raise" do
    for kind <- [:integer, :float, :mixed],
        {camera, axis} <- [
          {{0, 0, 0}, {0, 1, 0}},
          {{0, 0, -1}, {0, 0, 0}},
          {{1, 2, 3}, {2, 4, 6}},
          {{1, 2, 3}, {-2, -4, -6}}
        ],
        constructor <- [&Mat44.make_billboard/3, &Mat44.make_billboard_axis/3] do
      assert_raise ArithmeticError, fn ->
        constructor.(numeric({0, 0, 0}, kind), numeric(camera, kind), numeric(axis, kind))
      end
    end
  end

  @tag :make_billboard
  @tag :make_billboard_axis
  test "nearly parallel facing directions respect the angular threshold" do
    for constructor <- [&Mat44.make_billboard/3, &Mat44.make_billboard_axis/3],
        epsilon <- [1.0e-14, 1.0e-12] do
      assert_raise ArithmeticError, fn ->
        constructor.({0.0, 0.0, 0.0}, {0.0, 1.0, -epsilon}, {0.0, 1.0, 0.0})
      end
    end

    matrix = Mat44.make_billboard_axis({0.0, 0.0, 0.0}, {0.0, 1.0, -2.0e-12}, {0.0, 1.0, 0.0})
    assert_close(matrix, Mat44.identity())
  end

  defp numeric(tuple, kind) do
    tuple
    |> Tuple.to_list()
    |> Enum.with_index()
    |> Enum.map(fn {value, i} ->
      if kind == :float or (kind == :mixed and rem(i, 2) == 0), do: value * 1.0, else: value
    end)
    |> List.to_tuple()
  end

  defp assert_rigid(matrix) do
    rows = matrix |> Tuple.to_list() |> Enum.chunk_every(4) |> Enum.take(3)

    for {row, i} <- Enum.with_index(rows), {other, j} <- Enum.with_index(rows) do
      dot = Enum.zip(row, other) |> Enum.reduce(0.0, fn {a, b}, sum -> sum + a * b end)
      assert_in_delta dot, if(i == j, do: 1.0, else: 0.0), 1.0e-12
    end

    assert_in_delta Mat44.determinant(matrix), 1.0, 1.0e-12
  end

  defp assert_close(actual, expected) do
    assert tuple_size(actual) == tuple_size(expected)

    for {a, b} <- Enum.zip(Tuple.to_list(actual), Tuple.to_list(expected)) do
      assert_in_delta a, b, 1.0e-12
    end
  end
end
