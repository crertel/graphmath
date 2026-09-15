defmodule GraphmathTest.Mat33.InverseMat33 do
  use ExUnit.Case, async: true
  alias Graphmath.Mat33

  test "identity is its own inverse" do
    assert Mat33.inverse(Mat33.identity()) === Mat33.identity()
  end

  for kind <- [:integer, :float, :mixed] do
    @kind kind
    test "known inverse and unrounded residuals with #{kind} inputs" do
      a = numeric({-2, 3, 1, 0, 1, 2, 1, -1, 1}, @kind)
      assert_close(Mat33.inverse(a), {-3, 4, -5, -2, 3, -4, 1, -1, 2})

      for matrix <- [a, numeric({1, 2, 3, 0, -3, 1, -1, 9, 8}, @kind)] do
        inverse = Mat33.inverse(matrix)
        # These fixed, nonsingular examples have residuals well below 1e-10
        # in double precision; rounding before multiplication would hide errors.
        assert_close(Mat33.multiply(matrix, inverse), Mat33.identity())
        assert_close(Mat33.multiply(inverse, matrix), Mat33.identity())
        assert_close(Mat33.inverse(inverse), matrix)
      end
    end

    test "zero and nonzero singular matrices raise with #{kind} inputs" do
      for matrix <- [
            numeric({0, 0, 0, 0, 0, 0, 0, 0, 0}, @kind),
            numeric({1, -2, 3, 1, -2, 3, 7, -8, 10}, @kind)
          ] do
        assert_raise ArithmeticError, fn -> Mat33.inverse(matrix) end
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
