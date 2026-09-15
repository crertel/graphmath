defmodule GraphmathTest.Vec3.NumericContract do
  use ExUnit.Case, async: true
  alias Graphmath.Vec3

  for {kind, a, b, scalar} <- [
        {:integer, {3, -4, 12}, {-2, 5, -6}, 2},
        {:float, {3.0, -4.0, 12.0}, {-2.0, 5.0, -6.0}, 2.0},
        {:mixed, {3, -4.0, 12}, {-2.0, 5, -6.0}, 2.0}
      ] do
    @a a
    @b b
    @scalar scalar

    test "arithmetic, geometry and constructors with #{kind} inputs" do
      {x, y, z} = @a
      assert Vec3.create(x, y, z) === {3.0, -4.0, 12.0}
      assert Vec3.create([x, y, z, :ignored]) === {3.0, -4.0, 12.0}
      assert Vec3.add(@a, @b) == {1, 1, 6}
      assert Vec3.subtract(@a, @b) == {5, -9, 18}
      assert Vec3.multiply(@a, @b) == {-6, -20, -72}
      assert Vec3.scale(@a, @scalar) == {6, -8, 24}
      assert Vec3.dot(@a, @b) == -98
      assert Vec3.cross(@a, @b) == {-36, -6, 7}
      assert Vec3.scalar_triple(@a, @b, {1.0, 2.0, 3.0}) == -27
      assert Vec3.negate(@a) == {-3, 4, -12}
      assert Vec3.weighted_sum(@scalar, @a, -0.5, @b) == {7, -10.5, 27}
      assert Vec3.length(@a) == 13.0
      assert Vec3.length_squared(@a) == 169.0
      assert_tuple_close(Vec3.normalize(@a), {3 / 13, -4 / 13, 12 / 13})
      assert_tuple_close(Vec3.rotate(@a, {0.0, 0.0, 1.0}, :math.pi() / 2), {4, 3, 12})
      assert_tuple_close(Vec3.lerp(@a, @b, 0.25), {1.75, -1.75, 7.5})
      assert Vec3.lerp(@a, @b, 0) == @a
      assert Vec3.lerp(@a, @b, 1) == @b
    end

    test "signed norms and distance relationships with #{kind} inputs" do
      assert Vec3.length_manhattan(@a) == 19.0
      assert Vec3.p_norm(@a, 1) == Vec3.length_manhattan(@a)
      assert_in_delta Vec3.p_norm(@a, @scalar), 13.0, 1.0e-12
      assert_in_delta Vec3.minkowski_distance(@a, @b, @scalar), :math.sqrt(430), 1.0e-12
      assert Vec3.chebyshev_distance(@a, @b) == 18
      assert Vec3.chebyshev_distance(@b, @a) == 18

      for order <- [1, 1.0, 1.5, 2, 2.0, 3.0] do
        distance = Vec3.minkowski_distance(@a, @b, order)
        assert_in_delta distance, Vec3.minkowski_distance(@b, @a, order), 1.0e-12

        assert_in_delta distance,
                        Vec3.minkowski_distance(
                          Vec3.add(@a, {0.5, -2.5, 1.5}),
                          Vec3.add(@b, {0.5, -2.5, 1.5}),
                          order
                        ),
                        1.0e-12
      end

      assert_in_delta Vec3.minkowski_distance(@a, @b, 2.0),
                      Vec3.length(Vec3.subtract(@a, @b)),
                      1.0e-12
    end
  end

  test "fractional coordinates, scalars and norm orders retain their magnitude" do
    assert Vec3.scale({1.5, -2.5, 3.5}, 0.5) === {0.75, -1.25, 1.75}
    # (4^(3/2) + 9^(3/2) + 16^(3/2))^(2/3) = 99^(2/3).
    for v <- [{4, -9, 16}, {4.0, -9.0, 16.0}, {4, -9.0, 16}] do
      assert_in_delta Vec3.p_norm(v, 1.5), 21.400477469184917, 1.0e-12
    end

    assert_in_delta Vec3.minkowski_distance({0.5, -0.5, -2.5}, {4.5, -9.5, 13.5}, 1.5),
                    21.400477469184917,
                    1.0e-12
  end

  test "equality includes its epsilon boundary and checks each coordinate" do
    for a <- [{0, 0, 0}, {0.0, 0.0, 0.0}, {0, 0.0, 0}], i <- 0..2, sign <- [-1, 1] do
      b = put_elem(a, i, sign * 0.5)
      assert Vec3.equal(a, a)
      assert Vec3.equal(a, a, 0)
      refute Vec3.equal(a, b)
      assert Vec3.equal(a, b, 0.5)
      refute Vec3.equal(a, b, 0.5 - 1.0e-12)
      refute Vec3.equal(a, put_elem(b, i, sign * 0.500001), 0.5)
    end
  end

  test "near uses an exclusive Euclidean distance boundary" do
    for {a, b} <- [
          {{0, 0, 0}, {3, 4, 12}},
          {{0.0, 0.0, 0.0}, {3.0, 4.0, 12.0}},
          {{0, 0.0, 0}, {3.0, 4, 12}}
        ] do
      refute Vec3.near(a, b, 13.0)
      refute Vec3.near(a, b, 12.999999)
      assert Vec3.near(a, b, 13.000001)
      refute Vec3.near(a, a, 0.0)
      assert Vec3.near(a, a, 1.0e-12)
    end
  end

  test "rotation about a diagonal axis cycles coordinates and preserves the axial component" do
    k = 1 / :math.sqrt(3)

    for v <- [{3, -4, 12}, {3.0, -4.0, 12.0}, {3, -4.0, 12}] do
      assert_tuple_close(Vec3.rotate(v, {k, k, k}, 2 * :math.pi() / 3), {12, 3, -4})
    end
  end

  test "zero normalization raises" do
    for zero <- [{0, 0, 0}, {0.0, 0.0, 0.0}, {0, 0.0, 0}] do
      assert_raise ArithmeticError, fn -> Vec3.normalize(zero) end
    end
  end

  defp assert_tuple_close(actual, expected) do
    for {a, b} <- Enum.zip(Tuple.to_list(actual), Tuple.to_list(expected)) do
      assert_in_delta a, b, 1.0e-12
    end
  end
end
