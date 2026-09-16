defmodule GraphmathTest.Mat33.LinearAlgebra do
  use ExUnit.Case, async: true
  alias Graphmath.Mat33

  @moduletag :mat33

  for kind <- [:integer, :float, :mixed] do
    @kind kind

    @tag :trace
    @tag :determinant
    test "dense scalar operations with #{kind} entries" do
      a = numeric({1, -2, 3, 4, 5, -6, 7, -8, 10}, @kind)
      assert Mat33.trace(a) == 16
      assert Mat33.determinant(a) == -35

      swapped = numeric({4, 5, -6, 1, -2, 3, 7, -8, 10}, @kind)
      transposed = numeric({1, 4, 7, -2, 5, -8, 3, -6, 10}, @kind)
      assert Mat33.determinant(swapped) == 35
      assert Mat33.determinant(transposed) == -35
    end

    @tag :submatrix
    test "all nine submatrices preserve row-major order with #{kind} entries" do
      a = numeric({1, -2, 3, 4, 5, -6, 7, -8, 10}, @kind)

      for {i, j, expected} <- [
            {0, 0, {5, -6, -8, 10}},
            {0, 1, {4, -6, 7, 10}},
            {0, 2, {4, 5, 7, -8}},
            {1, 0, {-2, 3, -8, 10}},
            {1, 1, {1, 3, 7, 10}},
            {1, 2, {1, -2, 7, -8}},
            {2, 0, {-2, 3, 5, -6}},
            {2, 1, {1, 3, 4, -6}},
            {2, 2, {1, -2, 4, 5}}
          ] do
        assert Mat33.submatrix(a, i, j) == expected
      end
    end

    @tag :cofactor
    test "all nine cofactors have the expected values and signs with #{kind} entries" do
      a = numeric({1, -2, 3, 4, 5, -6, 7, -8, 10}, @kind)

      for {i, j, expected} <- [
            {0, 0, 2},
            {0, 1, -82},
            {0, 2, -67},
            {1, 0, -4},
            {1, 1, -11},
            {1, 2, -6},
            {2, 0, -3},
            {2, 1, 18},
            {2, 2, 13}
          ] do
        assert Mat33.cofactor(a, i, j) == expected
      end
    end
  end

  @tag :trace
  @tag :determinant
  @tag :cofactor
  test "identity, zero, triangular and singular matrices have known scalar values" do
    assert Mat33.trace(Mat33.identity()) === 3.0
    assert Mat33.trace(Mat33.zero()) === 0.0
    assert Mat33.determinant(Mat33.identity()) === 1.0
    assert Mat33.determinant(Mat33.zero()) === 0.0
    assert Mat33.determinant({2, 3, 4, 0, -5, 6, 0, 0, 7}) == -70
    assert Mat33.determinant({1, 2, 3, 2, 4, 6, 7, 8, 9}) == 0

    for i <- 0..2, j <- 0..2 do
      assert Mat33.cofactor(Mat33.identity(), i, j) == if(i == j, do: 1.0, else: 0.0)
      assert Mat33.cofactor(Mat33.zero(), i, j) == 0.0
    end
  end

  @tag :trace
  @tag :determinant
  @tag :submatrix
  @tag :cofactor
  test "fractional entries retain their values and return float scalars" do
    a = {0.5, -1.0, 1.5, 2.0, 2.5, -3.0, 3.5, -4.0, 5.0}
    assert Mat33.trace(a) === 8.0
    assert Mat33.determinant(a) === -4.375
    assert Mat33.submatrix(a, 1, 1) === {0.5, 1.5, 3.5, 5.0}
    assert Mat33.cofactor(a, 0, 0) === 0.5
    assert Mat33.cofactor(a, 0, 1) === -20.5
    assert Mat33.cofactor(a, 2, 2) === 3.25

    assert Mat33.submatrix({1, -2.5, 3.25, 4, 5, -6, 7, -8, 10}, 2, 0) ===
             {-2.5, 3.25, 5, -6}
  end

  @tag :submatrix
  @tag :cofactor
  test "invalid indices raise instead of selecting another row or column" do
    for a <- [Mat33.identity(), {1, 0, 0, 0, 1, 0, 0, 0, 1}],
        invalid <- [-1, 3, 0.0, 1.0, 0.5, :row, nil] do
      assert_raise FunctionClauseError, fn -> Mat33.submatrix(a, invalid, 0) end
      assert_raise FunctionClauseError, fn -> Mat33.submatrix(a, 0, invalid) end
      assert_raise FunctionClauseError, fn -> Mat33.cofactor(a, invalid, 0) end
      assert_raise FunctionClauseError, fn -> Mat33.cofactor(a, 0, invalid) end
    end
  end

  @tag :determinant
  @tag :cofactor
  @tag :multiply_transpose
  test "cofactors form the adjugate in the correct orientation" do
    a = {1, -2, 3, 4, 5, -6, 7, -8, 10}
    cofactors = for i <- 0..2, j <- 0..2, do: Mat33.cofactor(a, i, j)

    assert Mat33.multiply_transpose(a, List.to_tuple(cofactors)) ==
             {-35, 0, 0, 0, -35, 0, 0, 0, -35}
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
