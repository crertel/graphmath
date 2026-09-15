defmodule GraphmathTest.Mat44.NumericContract do
  use ExUnit.Case, async: true
  alias Graphmath.Mat44

  for kind <- [:integer, :float, :mixed] do
    @kind kind
    test "dense arithmetic and selections with #{kind} inputs" do
      a = numeric({1, -2, 3, 4, 5, -6, 7, -8, 9, 10, -11, 12, -13, 14, 15, -16}, @kind)
      b = numeric({-2, 3, 1, 5, -4, 2, 6, 7, -3, 8, 9, -10, 11, -12, 13, 14}, @kind)
      v = numeric({2, -3, 4, -5}, @kind)
      assert Mat44.add(a, b) == {-1, 1, 4, 9, 1, -4, 13, -1, 6, 18, -2, 2, -2, 2, 28, -2}

      assert Mat44.subtract(a, b) ==
               {3, -5, 2, -1, 9, -8, 1, -15, 12, 2, -20, 22, -24, 26, 2, -30}

      assert Mat44.scale(a, -0.5) ==
               {-0.5, 1.0, -1.5, -2.0, -2.5, 3.0, -3.5, 4.0, -4.5, -5.0, 5.5, -6.0, 6.5, -7.0,
                -7.5, 8.0}

      assert Mat44.multiply(a, b) ==
               {41, -25, 68, 17, -95, 155, -72, -199, 107, -185, 126, 393, -251, 301, -2, -341}

      assert Mat44.multiply_transpose(a, b) ==
               {15, 38, -32, 130, -61, -46, 80, 106, 61, 2, -166, 4, 3, 58, 446, -340}

      assert Mat44.apply(a, v) == {0, 96, -116, 72}
      assert Mat44.apply_transpose(a, v) == {88, -16, -134, 160}
      assert Mat44.apply_left(v, a) == {88, -16, -134, 160}
      assert Mat44.apply_left_transpose(v, a) == {0, 96, -116, 72}
      assert Mat44.row0(a) == {1, -2, 3, 4}
      assert Mat44.column0(a) == {1, 5, 9, -13}
      assert Mat44.row1(a) == {5, -6, 7, -8}
      assert Mat44.column1(a) == {-2, -6, 10, 14}
      assert Mat44.row2(a) == {9, 10, -11, 12}
      assert Mat44.column2(a) == {3, 7, -11, 15}
      assert Mat44.row3(a) == {-13, 14, 15, -16}
      assert Mat44.column3(a) == {4, -8, 12, -16}
      assert Mat44.diag(a) == {1, -6, -11, -16}

      for {expected, index} <-
            Enum.with_index(
              Tuple.to_list({1, -2, 3, 4, 5, -6, 7, -8, 9, 10, -11, 12, -13, 14, 15, -16})
            ) do
        assert Mat44.at(a, div(index, 4), rem(index, 4)) == expected
      end

      assert Mat44.round(a, 0) ===
               numeric({1, -2, 3, 4, 5, -6, 7, -8, 9, 10, -11, 12, -13, 14, 15, -16}, :float)
    end
  end

  test "round preserves fractional signs and decimal precision" do
    a =
      {0.125, -1.125, 2.125, -3.125, 4.125, -5.125, 6.125, -7.125, 8.125, -9.125, 10.125, -11.125,
       12.125, -13.125, 14.125, -15.125}

    assert Mat44.round(a, 2) ===
             {0.13, -1.13, 2.13, -3.13, 4.13, -5.13, 6.13, -7.13, 8.13, -9.13, 10.13, -11.13,
              12.13, -13.13, 14.13, -15.13}

    # A mixed tuple reaches the general clause while retaining fractional entries.
    assert Mat44.round(put_elem(a, 0, 0), 2) ===
             {0.0, -1.13, 2.13, -3.13, 4.13, -5.13, 6.13, -7.13, 8.13, -9.13, 10.13, -11.13,
              12.13, -13.13, 14.13, -15.13}
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
