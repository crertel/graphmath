defmodule GraphmathTest.Quatern.SlerpQuatern do
  use ExUnit.Case

  @tag :quatern
  @tag :slerp
  test "slerp({1,2,3,4},{5,6,7,8}, 0) returns {1,2,3,4}" do
    q = Graphmath.Quatern.normalize({1, 2, 3, 4})
    assert q == Graphmath.Quatern.slerp({1, 2, 3, 4}, {5, 6, 7, 8}, 0)
  end

  @tag :quatern
  @tag :slerp
  test "slerp({1,2,3,4},{5,6,7,8}, 1) returns {5,6,7,8}" do
    q = Graphmath.Quatern.normalize({5, 6, 7, 8})
    assert q == Graphmath.Quatern.slerp({1, 2, 3, 4}, {5, 6, 7, 8}, 1)
  end

  @tag :quatern
  @tag :slerp
  test "slerp({1,2,3,4},{5,6,7,8}, 0.25) returns {0.272166,0.408248,0.544331,0.680414}" do
    {w, x, y, z} = Graphmath.Quatern.slerp({1, 2, 3, 4}, {5, 6, 7, 8}, 0.25)

    assert {0.272166, 0.408248, 0.544331, 0.680414} ==
             {Float.round(w, 6), Float.round(x, 6), Float.round(y, 6), Float.round(z, 6)}
  end

  @tag :quatern
  @tag :slerp
  test "slerp({5,6,7,8},{1,2,3,4}, 0.75) returns {0.272166,0.408248,0.544331,0.680414}" do
    {w, x, y, z} = Graphmath.Quatern.slerp({5, 6, 7, 8}, {1, 2, 3, 4}, 0.75)

    assert {0.272166, 0.408248, 0.544331, 0.680414} ==
             {Float.round(w, 6), Float.round(x, 6), Float.round(y, 6), Float.round(z, 6)}
  end

  @tag :quatern
  @tag :slerp
  test "slerp({0,0.1,0.1,0.1}, {1,0.1,0.1,0.1}, 0) returns {0,0.1,0.1,0.1}" do
    q = Graphmath.Quatern.normalize({0, 0.1, 0.1, 0.1})
    assert q == Graphmath.Quatern.slerp({0.0, 0.1, 0.1, 0.1}, {1.0, 0.1, 0.1, 0.1}, 0)
  end

  for {lhs, rhs} <- [
        {{1, 0, 0, 0}, {-1, 0, 0, 0}},
        {{1.0, 0.0, 0.0, 0.0}, {-1.0, 0.0, 0.0, 0.0}},
        {{0.5, 0.5, 0.5, 0.5}, {-0.5, -0.5, -0.5, -0.5}}
      ] do
    @tag :quatern
    @tag :slerp
    test "slerp preserves the orientation between #{inspect(lhs)} and its negation" do
      for t <- [0.0, 0.25, 0.5, 0.75, 1.0] do
        actual =
          Graphmath.Quatern.slerp(
            unquote(Macro.escape(lhs)),
            unquote(Macro.escape(rhs)),
            t
          )

        assert_quaternion_close(actual, unquote(Macro.escape(lhs)))
      end
    end
  end

  @tag :quatern
  @tag :slerp
  test "slerp follows the short arc for negative-dot inputs in both numeric clauses" do
    for lhs <- [{1, 0, 0, 0}, {1.0, 0.0, 0.0, 0.0}],
        angle <- [1.0e-4, :math.pi() / 2.0],
        t <- [0.0, 0.25, 0.5, 0.75, 1.0] do
      rhs = {-:math.cos(angle / 2.0), 0.0, 0.0, -:math.sin(angle / 2.0)}
      expected = {:math.cos(t * angle / 2.0), 0.0, 0.0, :math.sin(t * angle / 2.0)}

      assert_quaternion_close(Graphmath.Quatern.slerp(lhs, rhs, t), expected)

      # Reversing the endpoints can reverse the quaternion sign, but not its orientation.
      reversed = Graphmath.Quatern.slerp(rhs, lhs, 1.0 - t)
      assert_quaternion_close(Graphmath.Quatern.scale(reversed, -1.0), expected)
    end
  end

  @tag :quatern
  @tag :slerp
  test "slerp between unit rotations gives the expected interior angle" do
    lhs = {1.0, 0.0, 0.0, 0.0}
    rhs = {:math.sqrt(0.5), 0.0, 0.0, :math.sqrt(0.5)}
    expected = {:math.cos(:math.pi() / 8.0), 0.0, 0.0, :math.sin(:math.pi() / 8.0)}

    assert_quaternion_close(Graphmath.Quatern.slerp(lhs, rhs, 0.5), expected)
    assert_quaternion_close(Graphmath.Quatern.slerp(rhs, rhs, 0.5), rhs)
  end

  defp assert_quaternion_close(actual, expected) do
    assert tuple_size(actual) == 4

    for {a, b} <- Enum.zip(Tuple.to_list(actual), Tuple.to_list(expected)) do
      assert_in_delta a, b, 1.0e-10
    end

    squared_norm = actual |> Tuple.to_list() |> Enum.map(&(&1 * &1)) |> Enum.sum()
    assert_in_delta squared_norm, 1.0, 1.0e-10
  end
end
