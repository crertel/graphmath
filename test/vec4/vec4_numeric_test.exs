defmodule GraphmathTest.Vec4.Numeric do
  use ExUnit.Case, async: true
  alias Graphmath.Vec4

  @moduletag :vec4

  for {kind, a, b, k} <- [
        {:integer, {1, -2, 2, -4}, {3, 4, -5, 6}, 2},
        {:float, {1.0, -2.0, 2.0, -4.0}, {3.0, 4.0, -5.0, 6.0}, 2.0},
        {:mixed, {1, -2.0, 2, -4.0}, {3.0, 4, -5.0, 6}, 2.0}
      ] do
    @a a
    @b b
    @k k

    @tag :add
    @tag :subtract
    @tag :multiply
    @tag :scale
    @tag :dot
    @tag :negate
    @tag :weighted_sum
    test "arithmetic includes all four components with #{kind} inputs" do
      assert Vec4.add(@a, @b) === {4.0, 2.0, -3.0, 2.0}
      assert Vec4.subtract(@a, @b) === {-2.0, -6.0, 7.0, -10.0}
      assert Vec4.multiply(@a, @b) === {3.0, -8.0, -10.0, -24.0}
      assert Vec4.scale(@a, @k) === {2.0, -4.0, 4.0, -8.0}
      assert Vec4.dot(@a, @b) === -39.0
      assert Vec4.negate(@a) === {-1.0, 2.0, -2.0, 4.0}
      assert Vec4.weighted_sum(@k, @a, -0.5, @b) === {0.5, -6.0, 6.5, -11.0}
    end

    @tag :length
    @tag :length_squared
    @tag :length_manhattan
    @tag :normalize
    @tag :p_norm
    test "four-dimensional lengths and normalization with #{kind} inputs" do
      assert Vec4.length(@a) === 5.0
      assert Vec4.length_squared(@a) === 25.0
      assert Vec4.length_manhattan(@a) === 9.0
      assert_close(Vec4.normalize(@a), {0.2, -0.4, 0.4, -0.8})
      assert_in_delta Vec4.p_norm(@a, @k), 5.0, 1.0e-12
      assert Vec4.p_norm(@a, 1.0) === 9.0
      assert_in_delta Vec4.p_norm(@a, 3.0), :math.pow(81, 1 / 3), 1.0e-12
    end

    @tag :lerp
    test "interpolation endpoints and fractional weights with #{kind} inputs" do
      assert Vec4.lerp(@a, @b, 0) == @a
      assert Vec4.lerp(@a, @b, 1) == @b
      assert Vec4.lerp(@a, @b, 0.25) === {1.5, -0.5, 0.25, -1.5}
    end

    @tag :project
    test "projection includes the fourth coordinate with #{kind} inputs" do
      assert_close(Vec4.project(@a, @b), {-117 / 86, -156 / 86, 195 / 86, -234 / 86})
      assert_close(Vec4.project(@a, @a), @a)
      assert_close(Vec4.project({0, 0, 0, 0}, @a), {0, 0, 0, 0})
    end

    @tag :minkowski_distance
    @tag :chebyshev_distance
    test "distances include all coordinates with #{kind} inputs" do
      assert_in_delta Vec4.minkowski_distance(@a, @b, @k), :math.sqrt(189), 1.0e-12
      assert Vec4.minkowski_distance(@a, @b, 1.0) === 25.0
      assert_in_delta Vec4.minkowski_distance(@b, @a, 3.0), :math.pow(1567, 1 / 3), 1.0e-12
      assert Vec4.chebyshev_distance(@a, @b) === 10.0
      assert Vec4.chebyshev_distance(@b, @a) === 10.0
    end
  end

  @tag :equal
  test "equality checks each component and includes its tolerance boundary" do
    for zero <- [{0, 0, 0, 0}, {0.0, 0.0, 0.0, 0.0}, {0, 0.0, 0, 0.0}],
        i <- 0..3,
        sign <- [-1, 1] do
      b = put_elem(zero, i, sign * 0.5)
      assert Vec4.equal(zero, zero)
      assert Vec4.equal(zero, zero, 0)
      refute Vec4.equal(zero, b)
      assert Vec4.equal(zero, b, 0.5)
      refute Vec4.equal(zero, b, 0.5 - 1.0e-12)
    end
  end

  @tag :near
  test "near uses a strict distance boundary including the fourth coordinate" do
    for {a, b} <- [
          {{0, 0, 0, 0}, {1, -2, 2, -4}},
          {{0.0, 0.0, 0.0, 0.0}, {1.0, -2.0, 2.0, -4.0}},
          {{0, 0.0, 0, 0.0}, {1, -2.0, 2, -4.0}}
        ] do
      refute Vec4.near(a, b, 5.0)
      assert Vec4.near(a, b, 5.0 + 1.0e-12)
      refute Vec4.near(a, b, 4.0)
      refute Vec4.near(a, a, 0)
      refute Vec4.near(a, a, -1.0)
      assert Vec4.near(a, a, 1.0e-12)
    end
  end

  @tag :normalize
  @tag :project
  @tag :p_norm
  @tag :minkowski_distance
  test "undefined zero operations propagate ArithmeticError" do
    for zero <- [{0, 0, 0, 0}, {0.0, 0.0, 0.0, 0.0}, {0, 0.0, 0, 0.0}] do
      assert_raise ArithmeticError, fn -> Vec4.normalize(zero) end
      assert_raise ArithmeticError, fn -> Vec4.project({1.0, 2.0, 3.0, 4.0}, zero) end
      assert_raise ArithmeticError, fn -> Vec4.p_norm(zero, 0.0) end
      assert_raise ArithmeticError, fn -> Vec4.minkowski_distance(zero, zero, 0) end
    end
  end

  @tag :add
  @tag :scale
  @tag :dot
  @tag :p_norm
  test "fractional components and norm orders retain their values" do
    a = {0.5, -1.25, 2.5, -3.75}
    assert Vec4.scale(a, 0.5) === {0.25, -0.625, 1.25, -1.875}
    assert Vec4.dot(a, {1.5, 2.0, -0.5, 0.25}) === -3.9375
    assert Vec4.add(a, {0.25, 0.5, -0.75, 1.0}) === {0.75, -0.75, 1.75, -2.75}
    assert_in_delta Vec4.p_norm({4.0, -9.0, 16.0, -25.0}, 1.5), :math.pow(224, 2 / 3), 1.0e-12
  end

  defp assert_close(actual, expected) do
    for {a, b} <- Enum.zip(Tuple.to_list(actual), Tuple.to_list(expected)) do
      assert_in_delta a, b, 1.0e-12
    end
  end
end
