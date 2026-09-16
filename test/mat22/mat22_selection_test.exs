defmodule GraphmathTest.Mat22.Selection do
  use ExUnit.Case, async: true
  alias Graphmath.Mat22

  @moduletag :mat22

  for {kind, a} <- [
        {:integer, {1, -2, 3, 4}},
        {:float, {1.0, -2.0, 3.0, 4.0}},
        {:mixed, {1, -2.0, 3, 4.0}}
      ] do
    @a a

    @tag :row
    @tag :column
    @tag :diag
    test "row-major selections with #{kind} entries" do
      assert Mat22.row0(@a) == {1, -2}
      assert Mat22.row1(@a) == {3, 4}
      assert Mat22.column0(@a) == {1, 3}
      assert Mat22.column1(@a) == {-2, 4}
      assert Mat22.diag(@a) == {1, 4}
    end

    @tag :at
    test "all zero-based indices with #{kind} entries" do
      assert Mat22.at(@a, 0, 0) == 1
      assert Mat22.at(@a, 0, 1) == -2
      assert Mat22.at(@a, 1, 0) == 3
      assert Mat22.at(@a, 1, 1) == 4
    end
  end

  @tag :at
  test "invalid indices cannot alias another row or column" do
    for {row, column} <- [
          {-1, 0},
          {2, 0},
          {0, -1},
          {0, 2},
          {0.5, 0},
          {0, 0.5},
          {1.0, 0},
          {0, 1.0}
        ] do
      assert_raise FunctionClauseError, fn -> Mat22.at({1, 2, 3, 4}, row, column) end
    end
  end

  @tag :row
  @tag :column
  @tag :diag
  @tag :at
  test "selections preserve fractional entries and numeric types" do
    a = {1, -2.5, 3.25, 4}
    assert Mat22.row0(a) === {1, -2.5}
    assert Mat22.row1(a) === {3.25, 4}
    assert Mat22.column0(a) === {1, 3.25}
    assert Mat22.column1(a) === {-2.5, 4}
    assert Mat22.diag(a) === {1, 4}
    assert Mat22.at(a, 0, 1) === -2.5
  end
end
