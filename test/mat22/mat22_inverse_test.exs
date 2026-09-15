defmodule GraphmathTest.Mat22.Inverse do
  use ExUnit.Case, async: true
  alias Graphmath.Mat22

  @moduletag :mat22

  for {kind, a, singular} <- [
        {:integer, {1, -2, 3, 4}, {1, -2, 2, -4}},
        {:float, {1.0, -2.0, 3.0, 4.0}, {1.0, -2.0, 2.0, -4.0}},
        {:mixed, {1, -2.0, 3, 4.0}, {1, -2.0, 2, -4.0}}
      ] do
    @a a
    @singular singular

    @tag :trace
    @tag :determinant
    test "trace and determinant with #{kind} entries" do
      assert Mat22.trace(@a) == 5
      assert Mat22.determinant(@a) == 10
      assert Mat22.determinant(@singular) == 0
    end

    @tag :inverse
    @tag :multiply
    test "known inverse and unrounded residuals with #{kind} entries" do
      inverse = Mat22.inverse(@a)
      assert_close(inverse, {0.4, 0.2, -0.3, 0.1})
      assert Enum.all?(Tuple.to_list(inverse), &is_float/1)
      assert_close(Mat22.multiply(@a, inverse), {1, 0, 0, 1})
      assert_close(Mat22.multiply(inverse, @a), {1, 0, 0, 1})
      assert_close(Mat22.inverse(inverse), @a)
    end

    @tag :inverse
    test "nonzero singular matrices raise with #{kind} entries" do
      assert_raise ArithmeticError, fn -> Mat22.inverse(@singular) end
    end
  end

  @tag :inverse
  test "zero matrices raise with each numeric representation" do
    for matrix <- [{0, 0, 0, 0}, {0.0, 0.0, 0.0, 0.0}, {0, 0.0, 0, 0.0}] do
      assert_raise ArithmeticError, fn -> Mat22.inverse(matrix) end
    end
  end

  @tag :trace
  @tag :determinant
  @tag :inverse
  test "identity, zero, reflection and rotation have known invariants" do
    assert Mat22.trace(Mat22.identity()) == 2
    assert Mat22.trace(Mat22.zero()) == 0
    assert Mat22.determinant(Mat22.identity()) == 1
    assert Mat22.determinant(Mat22.zero()) == 0
    assert Mat22.determinant({0, 1, 1, 0}) == -1
    assert_close(Mat22.inverse(Mat22.identity()), {1, 0, 0, 1})
    assert_in_delta Mat22.determinant(Mat22.make_rotate(0.7)), 1.0, 1.0e-12
  end

  @tag :trace
  @tag :determinant
  @tag :inverse
  test "fractional entries give the expected scalar values and inverse" do
    a = {0.5, -1.5, 2.25, 3.5}
    assert Mat22.trace(a) === 4.0
    assert Mat22.determinant(a) === 5.125
    inverse = Mat22.inverse(a)
    assert_close(inverse, {28 / 41, 12 / 41, -18 / 41, 4 / 41})
    assert_close(Mat22.multiply(a, inverse), {1, 0, 0, 1})
    assert_close(Mat22.multiply(inverse, a), {1, 0, 0, 1})
  end

  @tag :inverse
  @tag :determinant
  test "a negative determinant retains its sign in the inverse" do
    a = {1, 2, 3, 5}
    assert Mat22.determinant(a) == -1
    assert_close(Mat22.inverse(a), {-5, 2, 3, -1})
  end

  @tag :inverse
  @tag :determinant
  test "a small nonzero determinant is invertible" do
    a = {1.0, 0.0, 0.0, 1.0e-12}
    assert Mat22.determinant(a) == 1.0e-12
    inverse = Mat22.inverse(a)
    assert_close(inverse, {1.0, 0.0, 0.0, 1.0e12})
    assert_close(Mat22.multiply(a, inverse), {1, 0, 0, 1})
  end

  defp assert_close(actual, expected) do
    assert tuple_size(actual) == tuple_size(expected)

    for {a, b} <- Enum.zip(Tuple.to_list(actual), Tuple.to_list(expected)) do
      assert_in_delta a, b, 1.0e-12
    end
  end
end
