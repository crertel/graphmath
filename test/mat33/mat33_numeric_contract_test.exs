defmodule GraphmathTest.Mat33.NumericContract do
  use ExUnit.Case, async: true
  alias Graphmath.Mat33

  @moduletag :mat33

  for kind <- [:integer, :float, :mixed] do
    @kind kind
    @tag :add
    @tag :apply
    @tag :apply_left
    @tag :apply_left_transpose
    @tag :apply_transpose
    @tag :at
    @tag :column0
    @tag :column1
    @tag :column2
    @tag :diag
    @tag :multiply
    @tag :multiply_transpose
    @tag :round
    @tag :row0
    @tag :row1
    @tag :row2
    @tag :scale
    @tag :subtract
    test "dense arithmetic and selections with #{kind} inputs" do
      a = numeric({1, -2, 3, 4, 5, -6, 7, -8, 10}, @kind)
      b = numeric({-2, 3, 1, 5, -4, 2, 6, 7, -3}, @kind)
      v = numeric({2, -3, 4}, @kind)
      assert Mat33.add(a, b) == {-1, 1, 4, 9, 1, -4, 13, -1, 7}
      assert Mat33.subtract(a, b) == {3, -5, 2, -1, 9, -8, 1, -15, 13}
      assert Mat33.scale(a, -0.5) == {-0.5, 1.0, -1.5, -2.0, -2.5, 3.0, -3.5, 4.0, -5.0}
      assert Mat33.multiply(a, b) == {6, 32, -12, -19, -50, 32, 6, 123, -39}
      assert Mat33.multiply_transpose(a, b) == {-5, 19, -17, 1, -12, 77, -28, 87, -44}
      assert Mat33.apply(a, v) == {20, -31, 78}
      assert Mat33.apply_transpose(a, v) == {18, -51, 64}
      assert Mat33.apply_left(v, a) == {18, -51, 64}
      assert Mat33.apply_left_transpose(v, a) == {20, -31, 78}
      assert Mat33.row0(a) == {1, -2, 3}
      assert Mat33.column0(a) == {1, 4, 7}
      assert Mat33.row1(a) == {4, 5, -6}
      assert Mat33.column1(a) == {-2, 5, -8}
      assert Mat33.row2(a) == {7, -8, 10}
      assert Mat33.column2(a) == {3, -6, 10}
      assert Mat33.diag(a) == {1, 5, 10}

      for {expected, index} <- Enum.with_index(Tuple.to_list({1, -2, 3, 4, 5, -6, 7, -8, 10})) do
        assert Mat33.at(a, div(index, 3), rem(index, 3)) == expected
      end

      assert Mat33.round(a, 0) === numeric({1, -2, 3, 4, 5, -6, 7, -8, 10}, :float)
    end
  end

  @tag :round
  test "round preserves fractional signs and decimal precision" do
    a = {0.125, -1.125, 2.125, -3.125, 4.125, -5.125, 6.125, -7.125, 8.125}
    assert Mat33.round(a, 2) === {0.13, -1.13, 2.13, -3.13, 4.13, -5.13, 6.13, -7.13, 8.13}
    # A mixed tuple reaches the general clause while retaining fractional entries.
    assert Mat33.round(put_elem(a, 0, 0), 2) ===
             {0.0, -1.13, 2.13, -3.13, 4.13, -5.13, 6.13, -7.13, 8.13}
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
