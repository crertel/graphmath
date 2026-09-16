defmodule GraphmathTest.Mat44.LinearAlgebra do
  use ExUnit.Case, async: true
  alias Graphmath.Mat44

  @moduletag :mat44

  for kind <- [:integer, :float, :mixed] do
    @kind kind

    @tag :trace
    @tag :determinant
    test "dense scalar operations with #{kind} entries" do
      a = numeric({1, -2, 3, 4, 5, 6, -7, 8, -9, 10, 11, -12, 13, -14, 15, 17}, @kind)
      assert Mat44.trace(a) == 35
      assert Mat44.determinant(a) == -9072

      row_swapped = numeric({5, 6, -7, 8, 1, -2, 3, 4, -9, 10, 11, -12, 13, -14, 15, 17}, @kind)

      column_swapped =
        numeric({-2, 1, 3, 4, 6, 5, -7, 8, 10, -9, 11, -12, -14, 13, 15, 17}, @kind)

      transposed = numeric({1, 5, -9, 13, -2, 6, 10, -14, 3, -7, 11, 15, 4, 8, -12, 17}, @kind)
      assert Mat44.determinant(row_swapped) == 9072
      assert Mat44.determinant(column_swapped) == 9072
      assert Mat44.determinant(transposed) == -9072
      assert Mat44.trace(transposed) == 35
    end

    @tag :submatrix
    test "all sixteen submatrices preserve row-major order with #{kind} entries" do
      a = numeric({1, -2, 3, 4, 5, 6, -7, 8, -9, 10, 11, -12, 13, -14, 15, 17}, @kind)

      for {i, j, expected} <- [
            {0, 0, {6, -7, 8, 10, 11, -12, -14, 15, 17}},
            {0, 1, {5, -7, 8, -9, 11, -12, 13, 15, 17}},
            {0, 2, {5, 6, 8, -9, 10, -12, 13, -14, 17}},
            {0, 3, {5, 6, -7, -9, 10, 11, 13, -14, 15}},
            {1, 0, {-2, 3, 4, 10, 11, -12, -14, 15, 17}},
            {1, 1, {1, 3, 4, -9, 11, -12, 13, 15, 17}},
            {1, 2, {1, -2, 4, -9, 10, -12, 13, -14, 17}},
            {1, 3, {1, -2, 3, -9, 10, 11, 13, -14, 15}},
            {2, 0, {-2, 3, 4, 6, -7, 8, -14, 15, 17}},
            {2, 1, {1, 3, 4, 5, -7, 8, 13, 15, 17}},
            {2, 2, {1, -2, 4, 5, 6, 8, 13, -14, 17}},
            {2, 3, {1, -2, 3, 5, 6, -7, 13, -14, 15}},
            {3, 0, {-2, 3, 4, 6, -7, 8, 10, 11, -12}},
            {3, 1, {1, 3, 4, 5, -7, 8, -9, 11, -12}},
            {3, 2, {1, -2, 4, 5, 6, 8, -9, 10, -12}},
            {3, 3, {1, -2, 3, 5, 6, -7, -9, 10, 11}}
          ] do
        assert Mat44.submatrix(a, i, j) == expected
      end
    end

    @tag :cofactor
    test "all sixteen cofactors have the expected values and signs with #{kind} entries" do
      a = numeric({1, -2, 3, 4, 5, 6, -7, 8, -9, 10, 11, -12, 13, -14, 15, 17}, @kind)

      for {i, j, expected} <- [
            {0, 0, 4648},
            {0, 1, 368},
            {0, 2, -40},
            {0, 3, -3216},
            {1, 0, -476},
            {1, 1, -754},
            {1, 2, 8},
            {1, 3, -264},
            {2, 0, -196},
            {2, 1, -482},
            {2, 2, -416},
            {2, 3, 120},
            {3, 0, -1008},
            {3, 1, -72},
            {3, 2, -288},
            {3, 3, 432}
          ] do
        assert Mat44.cofactor(a, i, j) == expected
      end
    end

    @tag :determinant
    @tag :cofactor
    test "singular matrices have zero determinant and can have nonzero cofactors with #{kind} entries" do
      repeated_row = numeric({1, -2, 3, 4, 1, -2, 3, 4, -9, 10, 11, -12, 13, -14, 15, 17}, @kind)
      rank_three = numeric({2, 0, 0, 0, 0, 3, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0}, @kind)
      assert Mat44.determinant(repeated_row) == 0
      assert Mat44.determinant(rank_three) == 0
      assert Mat44.cofactor(rank_three, 3, 3) == 30
      assert Mat44.cofactor(rank_three, 0, 0) == 0
    end
  end

  @tag :trace
  @tag :determinant
  @tag :cofactor
  test "identity, zero, triangular and permutation matrices have known scalar values" do
    assert Mat44.trace(Mat44.identity()) === 4.0
    assert Mat44.trace(Mat44.zero()) === 0.0
    assert Mat44.determinant(Mat44.identity()) === 1.0
    assert Mat44.determinant(Mat44.zero()) === 0.0
    assert Mat44.determinant({2, 3, 4, 5, 0, -3, 6, 7, 0, 0, 5, 8, 0, 0, 0, 7}) == -210
    assert Mat44.determinant({0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1}) == -1

    for i <- 0..3, j <- 0..3 do
      assert Mat44.cofactor(Mat44.identity(), i, j) == if(i == j, do: 1.0, else: 0.0)
      assert Mat44.cofactor(Mat44.zero(), i, j) == 0.0
    end
  end

  @tag :trace
  @tag :determinant
  @tag :submatrix
  @tag :cofactor
  test "fractional entries retain their values and return float scalars" do
    a = {0.5, -1.0, 1.5, 2.0, 2.5, 3.0, -3.5, 4.0, -4.5, 5.0, 5.5, -6.0, 6.5, -7.0, 7.5, 8.5}
    assert Mat44.trace(a) === 17.5
    assert Mat44.determinant(a) === -567.0
    assert Mat44.submatrix(a, 1, 2) === {0.5, -1.0, 2.0, -4.5, 5.0, -6.0, 6.5, -7.0, 8.5}
    assert Mat44.cofactor(a, 0, 0) === 581.0
    assert Mat44.cofactor(a, 0, 1) === 46.0
    assert Mat44.cofactor(a, 1, 1) === -94.25
    assert Mat44.cofactor(a, 3, 3) === 54.0

    mixed = {1, -2.5, 3.25, 4, 5, 6, -7, 8, -9, 10, 11, -12, 13, -14, 15, 17}
    assert Mat44.submatrix(mixed, 3, 0) === {-2.5, 3.25, 4, 6, -7, 8, 10, 11, -12}
    assert Mat44.cofactor(mixed, 3, 0) === -1048.0
  end

  @tag :submatrix
  @tag :cofactor
  test "invalid indices raise instead of selecting another row or column" do
    for a <- [Mat44.identity(), {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1}],
        invalid <- [-1, 4, 0.0, 1.0, 3.0, 0.5, :row, nil] do
      assert_raise FunctionClauseError, fn -> Mat44.submatrix(a, invalid, 0) end
      assert_raise FunctionClauseError, fn -> Mat44.submatrix(a, 0, invalid) end
      assert_raise FunctionClauseError, fn -> Mat44.cofactor(a, invalid, 0) end
      assert_raise FunctionClauseError, fn -> Mat44.cofactor(a, 0, invalid) end
    end
  end

  @tag :trace
  @tag :determinant
  @tag :make_translate
  @tag :make_scale
  @tag :make_rotate_x
  @tag :make_rotate_y
  @tag :make_rotate_z
  test "affine transforms have the expected determinant and trace" do
    assert Mat44.trace(Mat44.make_translate(2.0, -3.0, 4.0)) === 4.0
    assert Mat44.determinant(Mat44.make_translate(2.0, -3.0, 4.0)) === 1.0
    assert Mat44.determinant(Mat44.make_scale(-2.0, 3.0, 4.0, 1.0)) === -24.0
    assert Mat44.determinant(Mat44.make_scale(1.0, 1.0, 1.0, 1.0e-12)) === 1.0e-12

    for rotation <- [
          Mat44.make_rotate_x(0.7),
          Mat44.make_rotate_y(-1.2),
          Mat44.make_rotate_z(2.3)
        ] do
      assert_in_delta Mat44.determinant(rotation), 1.0, 1.0e-12
    end
  end

  @tag :determinant
  @tag :cofactor
  @tag :multiply_transpose
  test "cofactors form the adjugate in the correct orientation" do
    a = {1, -2, 3, 4, 5, 6, -7, 8, -9, 10, 11, -12, 13, -14, 15, 17}
    cofactors = for i <- 0..3, j <- 0..3, do: Mat44.cofactor(a, i, j)

    assert Mat44.multiply_transpose(a, List.to_tuple(cofactors)) ==
             {-9072, 0, 0, 0, 0, -9072, 0, 0, 0, 0, -9072, 0, 0, 0, 0, -9072}
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
end
