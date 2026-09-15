defmodule GraphmathTest.Mat44.InverseMat44 do
  use ExUnit.Case, async: true
  alias Graphmath.Mat44

  test "identity is its own inverse" do
    assert_close(Mat44.inverse(Mat44.identity()), Mat44.identity())
  end

  for kind <- [:integer, :float, :mixed] do
    @kind kind
    test "known inverse and unrounded residuals with #{kind} inputs" do
      a = numeric({-2, 3, 1, -1, 0, 1, 2, 3, 1, -1, 1, 2, 4, -3, 5, 1}, @kind)

      assert_close(
        Mat44.inverse(a),
        {-5 / 2, 3, -6, 1 / 2, -17 / 10, 12 / 5, -23 / 5, 3 / 10, 1, -1, 2, 0, -1 / 10, 1 / 5,
         1 / 5, -1 / 10}
      )

      for matrix <- [a, numeric({1, 2, 3, 6, 0, -3, 1, 4, -1, 9, 8, 1, -3, 7, 0, 2}, @kind)] do
        inverse = Mat44.inverse(matrix)
        # These fixed, nonsingular examples have residuals well below 1e-10
        # in double precision; rounding before multiplication would hide errors.
        assert_close(Mat44.multiply(matrix, inverse), Mat44.identity())
        assert_close(Mat44.multiply(inverse, matrix), Mat44.identity())
        assert_close(Mat44.inverse(inverse), matrix)
      end
    end

    test "zero and nonzero singular matrices raise with #{kind} inputs" do
      for matrix <- [
            numeric({0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, @kind),
            numeric({1, -2, 3, 4, 1, -2, 3, 4, 9, 10, -11, 12, -13, 14, 15, -16}, @kind)
          ] do
        assert_raise RuntimeError, ~r/determinant equal to zero/, fn -> Mat44.inverse(matrix) end
      end
    end
  end

  defp assert_close(actual, expected) do
    assert tuple_size(actual) == tuple_size(expected)

    for {a, b} <- Enum.zip(Tuple.to_list(actual), Tuple.to_list(expected)) do
      assert_in_delta a, b, 1.0e-10
    end
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
