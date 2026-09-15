defmodule GraphmathTest.Mat22.Arithmetic do
  use ExUnit.Case, async: true
  alias Graphmath.Mat22

  @moduletag :mat22

  for {kind, a, b} <- [
        {:integer, {1, -2, 3, 4}, {-5, 6, 7, -8}},
        {:float, {1.0, -2.0, 3.0, 4.0}, {-5.0, 6.0, 7.0, -8.0}},
        {:mixed, {1, -2.0, 3, 4.0}, {-5.0, 6, 7.0, -8}}
      ] do
    @a a
    @b b

    @tag :add
    @tag :subtract
    test "element-wise arithmetic with #{kind} entries" do
      assert Mat22.add(@a, @b) == {-4, 4, 10, -4}
      assert Mat22.subtract(@a, @b) == {6, -8, -4, 12}
      assert Mat22.add(@a, Mat22.zero()) == @a
      assert Mat22.subtract(@a, @a) == Mat22.zero()
    end

    @tag :scale
    test "integer and fractional scalar multiplication with #{kind} entries" do
      assert Mat22.scale(@a, -2) == {-2, 4, -6, -8}
      assert Mat22.scale(@a, -0.5) === {-0.5, 1.0, -1.5, -2.0}
      assert Mat22.scale(@a, 0) == Mat22.zero()
    end

    @tag :multiply
    test "noncommutative matrix multiplication with #{kind} entries" do
      assert Mat22.multiply(@a, @b) == {-19, 22, 13, -14}
      assert Mat22.multiply(@b, @a) == {13, 34, -17, -46}
      assert Mat22.multiply(@a, Mat22.identity()) == @a
      assert Mat22.multiply(Mat22.identity(), @a) == @a
      assert Mat22.multiply(@a, Mat22.zero()) == Mat22.zero()
      assert Mat22.multiply(Mat22.zero(), @a) == Mat22.zero()
    end

    @tag :multiply
    @tag :multiply_transpose
    test "multiplication by a transposed matrix with #{kind} entries" do
      assert Mat22.multiply_transpose(@a, @b) == {-17, 23, 9, -11}
      assert Mat22.multiply_transpose(@a, @a) == {5, -5, -5, 25}
    end
  end

  @tag :add
  @tag :subtract
  @tag :multiply
  @tag :scale
  test "fractional entries retain their values through arithmetic" do
    a = {0.5, -1.5, 2.25, 3.5}
    b = {-4.0, 5.25, 6.0, -7.5}
    assert Mat22.add(a, b) === {-3.5, 3.75, 8.25, -4.0}
    assert Mat22.subtract(a, b) === {4.5, -6.75, -3.75, 11.0}
    assert Mat22.multiply(a, b) === {-11.0, 13.875, 12.0, -14.4375}
    assert Mat22.scale(a, -0.5) === {-0.25, 0.75, -1.125, -1.75}
  end
end
