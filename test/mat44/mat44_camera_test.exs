defmodule GraphmathTest.Mat44.Camera do
  use ExUnit.Case, async: true
  alias Graphmath.{Mat44, Vec3}

  @moduletag :mat44
  doctest Graphmath.Mat44, only: [orient: 3, look_at: 3]

  for kind <- [:integer, :float, :mixed] do
    @kind kind

    @tag :orient
    test "default forward and a tilted up hint produce translation with #{@kind} inputs" do
      pose =
        Mat44.orient(
          numeric({2, -3, 5}, @kind),
          numeric({0, 0, -2}, @kind),
          numeric({0, 3, 1}, @kind)
        )

      assert_close(pose, Mat44.make_translate(2.0, -3.0, 5.0))
      assert_close(Mat44.transform_point(pose, {0, 0, 0}), {2, -3, 5})
      assert_close(Mat44.transform_point(pose, {1, 2, -3}), {3, -1, 2})
      assert_close(Mat44.transform_vector(pose, {1, 2, -3}), {1, 2, -3})
      assert Enum.all?(Tuple.to_list(pose), &is_float/1)
    end

    @tag :orient
    test "an oblique pose has a known basis and transformed point with #{@kind} inputs" do
      pose =
        Mat44.orient(
          numeric({4, -5, 6}, @kind),
          numeric({2, -2, 1}, @kind),
          numeric({6, -3, 0}, @kind)
        )

      assert_close(
        pose,
        {1 / 3, 2 / 3, 2 / 3, 0, 2 / 3, 1 / 3, -2 / 3, 0, -2 / 3, 2 / 3, -1 / 3, 0, 4, -5, 6, 1}
      )

      assert_close(Mat44.transform_point(pose, {3, -2, 4}), {1, -1, 8})
      assert_close(Mat44.transform_vector(pose, {0, 0, -1}), {2 / 3, -2 / 3, 1 / 3})
      assert_close(Mat44.transform_vector(pose, {0, 1, 0}), {2 / 3, 1 / 3, -2 / 3})
      assert_rigid(pose)
    end

    @tag :look_at
    @tag :orient
    test "an oblique view has known entries and inverts the pose with #{@kind} inputs" do
      eye = numeric({4, -5, 6}, @kind)
      center = numeric({6, -7, 7}, @kind)
      up = numeric({6, -3, 0}, @kind)
      view = Mat44.look_at(eye, center, up)

      assert_close(
        view,
        {1 / 3, 2 / 3, -2 / 3, 0, 2 / 3, 1 / 3, 2 / 3, 0, 2 / 3, -2 / 3, -1 / 3, 0, -2, 3, 8, 1}
      )

      assert Enum.all?(Tuple.to_list(view), &is_float/1)
      assert_close(Mat44.transform_point(view, eye), {0, 0, 0})
      assert_close(Mat44.transform_point(view, center), {0, 0, -3})
      assert_close(Mat44.transform_point(view, {1, -1, 8}), {3, -2, 4})
      pose = Mat44.orient(eye, Vec3.subtract(center, eye), up)
      assert_close(Mat44.multiply(pose, view), Mat44.identity())
      assert_close(Mat44.multiply(view, pose), Mat44.identity())
      assert_close(Mat44.inverse(pose), view)
      assert_rigid(view)
    end
  end

  @tag :orient
  @tag :look_at
  test "views along every signed coordinate axis map forward, right and up correctly" do
    eye = {2.0, -3.0, 5.0}

    for {forward, up, right} <- [
          {{0, 0, -1}, {0, 1, 0}, {1, 0, 0}},
          {{0, 0, 1}, {0, 1, 0}, {-1, 0, 0}},
          {{1, 0, 0}, {0, 1, 0}, {0, 0, 1}},
          {{-1, 0, 0}, {0, 1, 0}, {0, 0, -1}},
          {{0, 1, 0}, {0, 0, 1}, {1, 0, 0}},
          {{0, -1, 0}, {0, 0, 1}, {-1, 0, 0}}
        ] do
      center = Vec3.add(eye, forward)
      view = Mat44.look_at(eye, center, up)
      pose = Mat44.orient(eye, forward, up)
      assert_close(Mat44.transform_point(view, center), {0, 0, -1})
      assert_close(Mat44.transform_point(view, Vec3.add(eye, right)), {1, 0, 0})
      assert_close(Mat44.transform_point(view, Vec3.add(eye, up)), {0, 1, 0})
      assert_close(Mat44.transform_vector(pose, {0, 0, -1}), forward)
      assert_close(Mat44.transform_vector(pose, {1, 0, 0}), right)
      assert_close(Mat44.transform_vector(pose, {0, 1, 0}), up)
    end
  end

  @tag :orient
  @tag :look_at
  test "fractional positions retain their magnitude" do
    eye = {0.5, -1.25, 2.75}
    pose = Mat44.orient(eye, {0.0, 0.0, -0.5}, {0.0, 2.0, -0.5})
    view = Mat44.look_at(eye, {0.5, -1.25, 1.75}, {0.0, 2.0, -0.5})
    assert_close(Mat44.transform_point(pose, {0, 0, 0}), eye)
    assert_close(Mat44.transform_point(view, {1.0, 2.0, 3.0}), {0.5, 3.25, 0.25})
    assert_close(Mat44.apply_left({1.0, 2.0, 3.0, 1.0}, view), {0.5, 3.25, 0.25, 1})
    assert_close(Mat44.apply_left({1.0, 2.0, 3.0, 0.0}, view), {1, 2, 3, 0})
  end

  @tag :orient
  @tag :look_at
  test "normalization accepts very large and small direction magnitudes" do
    origin = {0.0, 0.0, 0.0}

    expected =
      {1 / 3, 2 / 3, 2 / 3, 0, 2 / 3, 1 / 3, -2 / 3, 0, -2 / 3, 2 / 3, -1 / 3, 0, 0, 0, 0, 1}

    for fs <- [1.0e-200, 1.0, 1.0e200], us <- [1.0e-200, 1.0, 1.0e200] do
      forward = {2 * fs, -2 * fs, fs}
      up = {6 * us, -3 * us, 0.0}
      pose = Mat44.orient(origin, forward, up)
      view = Mat44.look_at(origin, forward, up)
      assert_close(pose, expected)
      assert_close(view, Mat44.inverse(expected))
    end
  end

  @tag :orient
  @tag :look_at
  test "zero, parallel and antiparallel direction inputs raise ArithmeticError" do
    for kind <- [:integer, :float, :mixed],
        {forward, up} <- [
          {{0, 0, 0}, {0, 1, 0}},
          {{0, 0, -1}, {0, 0, 0}},
          {{1, 2, 3}, {2, 4, 6}},
          {{1, 2, 3}, {-2, -4, -6}}
        ] do
      origin = numeric({0, 0, 0}, kind)
      forward = numeric(forward, kind)
      up = numeric(up, kind)
      assert_raise ArithmeticError, fn -> Mat44.orient(origin, forward, up) end
      assert_raise ArithmeticError, fn -> Mat44.look_at(origin, forward, up) end
    end

    assert_raise ArithmeticError, fn -> Mat44.look_at({2, 3, 4}, {2, 3, 4}, {0, 1, 0}) end
  end

  @tag :orient
  @tag :look_at
  test "the angular degeneracy threshold includes its boundary" do
    for epsilon <- [1.0e-14, 1.0e-12] do
      assert_raise ArithmeticError, fn ->
        Mat44.orient({0.0, 0.0, 0.0}, {0.0, 0.0, -1.0}, {0.0, epsilon, -1.0})
      end

      assert_raise ArithmeticError, fn ->
        Mat44.look_at({0.0, 0.0, 0.0}, {0.0, 0.0, -1.0}, {0.0, epsilon, -1.0})
      end
    end

    pose = Mat44.orient({0.0, 0.0, 0.0}, {0.0, 0.0, -1.0}, {0.0, 2.0e-12, -1.0})
    assert_close(pose, Mat44.identity())
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
