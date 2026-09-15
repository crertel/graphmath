defmodule GraphmathTest.Quatern.NumericContract do
  use ExUnit.Case, async: true
  alias Graphmath.Quatern

  @moduletag :quatern

  for {kind, a, b} <- [
        {:integer, {2, -3, 4, -5}, {-6, 7, -8, 9}},
        {:float, {2.0, -3.0, 4.0, -5.0}, {-6.0, 7.0, -8.0, 9.0}},
        {:mixed, {2, -3.0, 4, -5.0}, {-6.0, 7, -8.0, 9}}
      ] do
    @a a
    @b b
    @tag :add
    @tag :conjugate
    @tag :dot
    @tag :inverse
    @tag :multiply
    @tag :norm
    @tag :normalize
    @tag :normalize_strict
    @tag :scale
    @tag :sub
    @tag :subtract
    test "arithmetic, normalization and inverse with #{kind} inputs" do
      assert Quatern.add(@a, @b) == {-4, 4, -4, 4}
      assert Quatern.subtract(@a, @b) == {8, -10, 12, -14}
      assert Quatern.multiply(@a, @b) == {86, 28, -48, 44}
      assert Quatern.multiply(@b, @a) == {86, 36, -32, 52}
      assert Quatern.scale(@a, 0.5) == {1, -1.5, 2, -2.5}
      assert Quatern.scale(@a, -2) == {-4, 6, -8, 10}
      assert Quatern.dot(@a, @b) == -110
      assert Quatern.conjugate(@a) == {2, 3, -4, 5}
      magnitude = :math.sqrt(54)
      assert_in_delta Quatern.norm(@a), magnitude, 1.0e-12
      expected = {2 / magnitude, -3 / magnitude, 4 / magnitude, -5 / magnitude}
      assert_close(Quatern.normalize(@a), expected)
      assert_close(Quatern.normalize_strict(@a), expected)
      inverse = Quatern.inverse(@a)
      assert_close(inverse, {1 / 27, 1 / 18, -2 / 27, 5 / 54})
      assert_close(Quatern.multiply(@a, inverse), {1, 0, 0, 0})
      assert_close(Quatern.multiply(inverse, @a), {1, 0, 0, 0})
    end
  end

  @tag :inverse
  @tag :norm
  @tag :normalize
  @tag :normalize_strict
  test "zero behavior of normalization and inverse through both clauses" do
    for q <- [{0, 0, 0, 0}, {0.0, 0.0, 0.0, 0.0}, {0, 0.0, 0, 0.0}] do
      assert Quatern.norm(q) == 0.0
      assert Quatern.normalize(q) === {0.0, 0.0, 0.0, 0.0}
      assert Quatern.inverse(q) === {0.0, 0.0, 0.0, 0.0}
      assert_raise ArithmeticError, fn -> Quatern.normalize_strict(q) end
    end
  end

  @tag :equal_elements
  test "element equality checks each component and includes the epsilon boundary" do
    for q <- [{0, 0, 0, 0}, {0.0, 0.0, 0.0, 0.0}, {0, 0.0, 0, 0.0}], i <- 0..3, sign <- [-1, 1] do
      r = put_elem(q, i, sign * 0.5)
      assert Quatern.equal_elements(q, q)
      assert Quatern.equal_elements(q, q, 0)
      refute Quatern.equal_elements(q, r)
      assert Quatern.equal_elements(q, r, 0.5)
      refute Quatern.equal_elements(q, r, 0.5 - 1.0e-12)
      refute Quatern.equal_elements(q, put_elem(r, i, sign * 0.500001), 0.5)
    end
  end

  @tag :equal
  test "orientation equality distinguishes rotations and treats opposite signs equally" do
    for q <- [{1, 0, 0, 0}, {1.0, 0.0, 0.0, 0.0}, {1, 0.0, 0, 0.0}] do
      assert Quatern.equal(q, q)
      assert Quatern.equal(q, {-1.0, 0.0, 0.0, 0.0})

      for half_turn <- [{0.0, 1.0, 0.0, 0.0}, {0.0, 0.0, 1.0, 0.0}, {0.0, 0.0, 0.0, 1.0}] do
        refute Quatern.equal(q, half_turn)
        refute Quatern.equal(q, half_turn, 0.01)
      end

      # These unit quaternions have |dot| = 0.5 exactly; epsilon is in dot space.
      for r <- [{0.5, 0.5, 0.5, 0.5}, {-0.5, -0.5, -0.5, -0.5}] do
        assert Quatern.equal(q, r, 0.5)
        refute Quatern.equal(q, r, 0.5 - 1.0e-12)
        refute Quatern.equal(q, r, 0)
      end
    end
  end

  @tag :get_pitch
  @tag :get_roll
  @tag :get_yaw
  test "local pitch, yaw and roll extract pure X, Y and Z rotations" do
    for angle <- [-:math.pi() / 3, :math.pi() / 3] do
      c = :math.cos(angle / 2)
      s = :math.sin(angle / 2)

      for {x, y, z} <- [
            {{c, s, 0.0, 0.0}, {c, 0.0, s, 0.0}, {c, 0.0, 0.0, s}},
            {{c, s, 0, 0}, {c, 0, s, 0}, {c, 0, 0, s}}
          ] do
        assert_in_delta Quatern.get_pitch(x), angle, 1.0e-12
        assert_in_delta Quatern.get_yaw(y), angle, 1.0e-12
        assert_in_delta Quatern.get_roll(z), angle, 1.0e-12
        assert_in_delta Quatern.get_roll(x), 0.0, 1.0e-12
        assert_in_delta Quatern.get_yaw(x), 0.0, 1.0e-12
        assert_in_delta Quatern.get_pitch(y), 0.0, 1.0e-12
        assert_in_delta Quatern.get_roll(y), 0.0, 1.0e-12
        assert_in_delta Quatern.get_pitch(z), 0.0, 1.0e-12
        assert_in_delta Quatern.get_yaw(z), 0.0, 1.0e-12
      end
    end
  end

  @tag :transform_vector
  test "a diagonal-axis rotation cycles a nonunit vector's coordinates" do
    for v <- [{2, -3, 4}, {2.0, -3.0, 4.0}, {2, -3.0, 4}] do
      assert_close(Quatern.transform_vector({0.5, 0.5, 0.5, 0.5}, v), {4, 2, -3})
    end
  end

  defp assert_close(actual, expected) do
    assert tuple_size(actual) == tuple_size(expected)

    for {a, b} <- Enum.zip(Tuple.to_list(actual), Tuple.to_list(expected)) do
      assert_in_delta a, b, 1.0e-12
    end
  end
end
