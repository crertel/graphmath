defmodule GraphmathTest.Mat33.Orthonormalize do
  use ExUnit.Case, async: true
  alias Graphmath.Mat33

  @moduletag :mat33
  @moduletag :orthonormalize

  doctest Graphmath.Mat33, only: [orthonormalize: 1]

  for {kind, a} <- [
        {:integer, {1, 2, 2, 5, 4, -2, -3, 15, 6}},
        {:float, {1.0, 2.0, 2.0, 5.0, 4.0, -2.0, -3.0, 15.0, 6.0}},
        {:mixed, {1.0, 2, 2.0, 5, 4.0, -2, -3.0, 15, 6.0}}
      ] do
    @a a

    test "a scaled and sheared 3D basis recovers known directions with #{kind} entries" do
      q = Mat33.orthonormalize(@a)
      assert_close(q, {1 / 3, 2 / 3, 2 / 3, 2 / 3, 1 / 3, -2 / 3, -2 / 3, 2 / 3, -1 / 3})
      assert Enum.all?(Tuple.to_list(q), &is_float/1)
      assert_orthonormal(q)
      assert_in_delta Mat33.determinant(q), 1.0, 1.0e-12
      assert_close(Mat33.orthonormalize(q), q)
    end
  end

  test "identity, rotations and reflections are preserved" do
    for matrix <- [
          Mat33.identity(),
          Mat33.make_rotate(0.7),
          Mat33.make_rotate(-1.3),
          {1.0, 0.0, 0.0, 0.0, -1.0, 0.0, 0.0, 0.0, 1.0},
          {0.0, 1.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.0, 0.0}
        ] do
      q = Mat33.orthonormalize(matrix)
      assert_close(q, matrix)
      assert_orthonormal(q)
    end
  end

  test "rows are processed in order and a lower triangular basis becomes identity" do
    assert_close(Mat33.orthonormalize({2, 0, 0, 3, 4, 0, 5, 6, 7}), Mat33.identity())

    assert_close(
      Mat33.orthonormalize({3, 4, 0, 2, 0, 0, 5, 6, 7}),
      {0.6, 0.8, 0.0, 0.8, -0.6, 0.0, 0.0, 0.0, 1.0}
    )
  end

  test "a left-handed dense basis keeps its handedness" do
    q = Mat33.orthonormalize({1.0, 2.0, 2.0, 5.0, 4.0, -2.0, 3.0, -15.0, -6.0})
    assert_close(q, {1 / 3, 2 / 3, 2 / 3, 2 / 3, 1 / 3, -2 / 3, 2 / 3, -2 / 3, 1 / 3})
    assert_orthonormal(q)
    assert_in_delta Mat33.determinant(q), -1.0, 1.0e-12
  end

  test "normalization tolerates very large and small row magnitudes" do
    a = {1.0, 2.0, 2.0, 5.0, 4.0, -2.0, -3.0, 15.0, 6.0}
    expected = {1 / 3, 2 / 3, 2 / 3, 2 / 3, 1 / 3, -2 / 3, -2 / 3, 2 / 3, -1 / 3}

    for factor <- [1.0e-200, 1.0e200] do
      q = Mat33.orthonormalize(Mat33.scale(a, factor))
      assert_close(q, expected)
      assert_orthonormal(q)
    end

    q =
      Mat33.orthonormalize(
        {1.0e-200, 2.0e-200, 2.0e-200, 5.0, 4.0, -2.0, -3.0e200, 15.0e200, 6.0e200}
      )

    assert_close(q, expected)
    assert_orthonormal(q)
  end

  test "close but independent rows still produce perpendicular unit vectors" do
    q = Mat33.orthonormalize({1.0, 1.0, 1.0, 1.0, 1.0 + 1.0e-8, 1.0, 1.0, 1.0, 1.0 + 1.0e-8})
    assert_orthonormal(q)
    assert_close(Mat33.row0(q), {1 / :math.sqrt(3), 1 / :math.sqrt(3), 1 / :math.sqrt(3)})
    assert_in_delta Mat33.determinant(q), 1.0, 1.0e-12
  end

  test "zero rows in any position raise for integer, float and mixed inputs" do
    for a <- [
          Mat33.zero(),
          {0, 0, 0, 0, 1, 0, 0, 0, 1},
          {1, 0, 0, 0, 0, 0, 0, 0, 1},
          {1, 0, 0, 0, 1, 0, 0, 0, 0},
          {1.0, 0, 0.0, 0, 1.0, 0, 0.0, 0, 0.0}
        ] do
      assert_raise ArithmeticError, fn -> Mat33.orthonormalize(a) end
    end
  end

  test "parallel rows and a third row in the first two rows' plane raise" do
    for a <- [
          {1, 2, 3, 2, 4, 6, 1, 0, 0},
          {1.0, 2.0, 3.0, -2.0, -4.0, -6.0, 1.0, 0.0, 0.0},
          {1, 2, 2, 5, 4, -2, 6, 6, 0},
          {1.0, 2, 2.0, 5, 4.0, -2, 6.0, 6, 0.0}
        ] do
      assert_raise ArithmeticError, fn -> Mat33.orthonormalize(a) end
    end
  end

  test "nearly dependent rows are rejected relative to their original length" do
    for a <- [
          {1.0, 0.0, 0.0, 1.0, 1.0e-14, 0.0, 0.0, 0.0, 1.0},
          {1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 1.0, 1.0, 1.0e-14}
        ],
        factor <- [1.0e-200, 1.0, 1.0e200] do
      assert_raise ArithmeticError, fn -> Mat33.orthonormalize(Mat33.scale(a, factor)) end
    end
  end

  test "the degeneracy threshold includes its boundary" do
    assert_raise ArithmeticError, fn ->
      Mat33.orthonormalize({1.0, 0.0, 0.0, 1.0, 1.0e-12, 0.0, 0.0, 0.0, 1.0})
    end

    assert_close(
      Mat33.orthonormalize({1.0, 0.0, 0.0, 1.0, 2.0e-12, 0.0, 0.0, 0.0, 1.0}),
      Mat33.identity()
    )
  end

  defp assert_orthonormal(matrix) do
    rows = matrix |> Tuple.to_list() |> Enum.chunk_every(3)

    for {row, i} <- Enum.with_index(rows), {other, j} <- Enum.with_index(rows) do
      dot = Enum.zip(row, other) |> Enum.reduce(0.0, fn {a, b}, sum -> sum + a * b end)
      assert_in_delta dot, if(i == j, do: 1.0, else: 0.0), 1.0e-12
    end
  end

  defp assert_close(actual, expected) do
    assert tuple_size(actual) == tuple_size(expected)

    for {a, b} <- Enum.zip(Tuple.to_list(actual), Tuple.to_list(expected)) do
      assert_in_delta a, b, 1.0e-12
    end
  end
end
