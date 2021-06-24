defmodule GraphmathTest.Vec3.ChebyshevDistanceVec2 do
  use ExUnit.Case

  @tag :vec2
  @tag :chebyshev_distance
  test "chebyshev_distance for zero vec2 returns 0" do
    [
      {0, {0,0},{0,0}},
      {0, {1,0},{1,0}},
      {0, {0,1},{0,1}},
    ]
    |> Enum.map( fn ({d, a,b}) ->
      assert d == Graphmath.Vec2.chebyshev_distance(a,b)
    end)
  end

  @tag :vec2
  @tag :chebyshev_distance
  test "chebyshev_distance for unit vec2 returns 1" do
    [
      {1, {0,0},{1,0}},
      {1, {0,0},{0,1}},
    ]
    |> Enum.map( fn ({d, a,b}) ->
      assert d == Graphmath.Vec2.chebyshev_distance(a,b)
    end)
  end

  @tag :vec2
  @tag :chebyshev_distance
  test "chebyshev_distance for vec2 of length 3 works" do
    [
      {3, {0,3},{1,0}},
      {3, {3,0},{0,1}},
    ]
    |> Enum.map( fn ({d, a,b}) ->
      assert d == Graphmath.Vec2.chebyshev_distance(a,b)
    end)
  end
end
