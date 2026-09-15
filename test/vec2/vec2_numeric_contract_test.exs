defmodule GraphmathTest.Vec2.NumericContract do
  use ExUnit.Case, async: true
  alias Graphmath.Vec2

  @moduletag :vec2

  for {kind, a, b, scalar} <- [
        {:integer, {3, -4}, {-2, 5}, 2},
        {:float, {3.0, -4.0}, {-2.0, 5.0}, 2.0},
        {:mixed, {3, -4.0}, {-2.0, 5}, 2.0}
      ] do
    @a a
    @b b
    @scalar scalar

    @tag :add
    @tag :create
    @tag :dot
    @tag :length
    @tag :length_squared
    @tag :lerp
    @tag :multiply
    @tag :negate
    @tag :normalize
    @tag :perp
    @tag :perp_prod
    @tag :project
    @tag :rotate
    @tag :scale
    @tag :subtract
    @tag :weighted_sum
    test "arithmetic, geometry and constructors with #{kind} inputs" do
      {x, y} = @a
      assert Vec2.create(x, y) === {3.0, -4.0}
      assert Vec2.create([x, y, :ignored]) === {3.0, -4.0}
      assert Vec2.add(@a, @b) == {1, 1}
      assert Vec2.subtract(@a, @b) == {5, -9}
      assert Vec2.multiply(@a, @b) == {-6, -20}
      assert Vec2.scale(@a, @scalar) == {6, -8}
      assert Vec2.dot(@a, @b) == -26
      assert Vec2.perp_prod(@a, @b) == 7
      assert Vec2.perp(@a) == {4, 3}
      assert Vec2.negate(@a) == {-3, 4}
      assert Vec2.weighted_sum(@scalar, @a, -0.5, @b) == {7, -10.5}
      assert Vec2.length(@a) == 5.0
      assert Vec2.length_squared(@a) == 25.0
      assert_tuple_close(Vec2.normalize(@a), {0.6, -0.8})
      assert_tuple_close(Vec2.rotate(@a, :math.pi() / 2), {4, 3})
      assert_tuple_close(Vec2.lerp(@a, @b, 0.25), {1.75, -1.75})
      assert Vec2.lerp(@a, @b, 0) == @a
      assert Vec2.lerp(@a, @b, 1) == @b
      assert_tuple_close(Vec2.project(@a, @b), {52 / 29, -130 / 29})
    end

    @tag :add
    @tag :chebyshev_distance
    @tag :length
    @tag :length_manhattan
    @tag :minkowski_distance
    @tag :p_norm
    @tag :subtract
    test "signed norms and distance relationships with #{kind} inputs" do
      assert Vec2.length_manhattan(@a) == 7.0
      assert Vec2.p_norm(@a, 1) == Vec2.length_manhattan(@a)
      assert_in_delta Vec2.p_norm(@a, @scalar), 5.0, 1.0e-12
      assert_in_delta Vec2.minkowski_distance(@a, @b, @scalar), :math.sqrt(106), 1.0e-12
      assert Vec2.chebyshev_distance(@a, @b) == 9
      assert Vec2.chebyshev_distance(@b, @a) == 9

      for order <- [1, 1.0, 1.5, 2, 2.0, 3.0] do
        distance = Vec2.minkowski_distance(@a, @b, order)
        assert_in_delta distance, Vec2.minkowski_distance(@b, @a, order), 1.0e-12

        assert_in_delta distance,
                        Vec2.minkowski_distance(
                          Vec2.add(@a, {0.5, -2.5}),
                          Vec2.add(@b, {0.5, -2.5}),
                          order
                        ),
                        1.0e-12
      end

      assert_in_delta Vec2.minkowski_distance(@a, @b, 2.0),
                      Vec2.length(Vec2.subtract(@a, @b)),
                      1.0e-12
    end
  end

  @tag :minkowski_distance
  @tag :p_norm
  @tag :scale
  test "fractional coordinates, scalars and norm orders retain their magnitude" do
    assert Vec2.scale({1.5, -2.5}, 0.5) === {0.75, -1.25}
    # (4^(3/2) + 9^(3/2))^(2/3) = 35^(2/3).
    for v <- [{4, -9}, {4.0, -9.0}, {4, -9.0}] do
      assert_in_delta Vec2.p_norm(v, 1.5), 10.699874805650794, 1.0e-12
    end

    assert_in_delta Vec2.minkowski_distance({0.5, -0.5}, {4.5, -9.5}, 1.5),
                    10.699874805650794,
                    1.0e-12
  end

  @tag :equal
  test "equality includes its epsilon boundary and checks each coordinate" do
    for a <- [{0, 0}, {0.0, 0.0}, {0, 0.0}], i <- 0..1, sign <- [-1, 1] do
      b = put_elem(a, i, sign * 0.5)
      assert Vec2.equal(a, a)
      assert Vec2.equal(a, a, 0)
      refute Vec2.equal(a, b)
      assert Vec2.equal(a, b, 0.5)
      refute Vec2.equal(a, b, 0.5 - 1.0e-12)
      refute Vec2.equal(a, put_elem(b, i, sign * 0.500001), 0.5)
    end
  end

  @tag :near
  test "near uses an exclusive Euclidean distance boundary" do
    for {a, b} <- [{{0, 0}, {3, 4}}, {{0.0, 0.0}, {3.0, 4.0}}, {{0, 0.0}, {3.0, 4}}] do
      refute Vec2.near(a, b, 5.0)
      refute Vec2.near(a, b, 4.999999)
      assert Vec2.near(a, b, 5.000001)
      refute Vec2.near(a, a, 0.0)
      assert Vec2.near(a, a, 1.0e-12)
    end
  end

  @tag :normalize
  @tag :project
  test "zero normalization and zero projection target raise" do
    for zero <- [{0, 0}, {0.0, 0.0}, {0, 0.0}] do
      assert_raise ArithmeticError, fn -> Vec2.normalize(zero) end
      assert_raise ArithmeticError, fn -> Vec2.project({1.0, -2.0}, zero) end
      assert Vec2.project(zero, {1.0, -2.0}) == {0.0, 0.0}
    end
  end

  defp assert_tuple_close(actual, expected) do
    for {a, b} <- Enum.zip(Tuple.to_list(actual), Tuple.to_list(expected)) do
      assert_in_delta a, b, 1.0e-12
    end
  end
end
