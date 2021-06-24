defmodule GraphmathTest.Vec3.ChebyshevDistanceVec3 do
  use ExUnit.Case

  @tag :vec3
  @tag :chebyshev_distance
  test "chebyshev_distance for zero vec3 returns 0" do
    [
      {0, {0,0,0},{0,0,0}},
      {0, {1,0,0},{1,0,0}},
      {0, {0,1,0},{0,1,0}},
      {0, {0,0,1},{0,0,1}}
    ]
    |> Enum.map( fn ({d, a,b}) ->
      assert d == Graphmath.Vec3.chebyshev_distance(a,b)
    end)
  end

  @tag :vec3
  @tag :chebyshev_distance
  test "chebyshev_distance for unit vec3 returns 1" do
    [
      {1, {0,0,0},{1,0,0}},
      {1, {0,0,0},{0,1,0}},
      {1, {0,0,0},{0,0,1}}
    ]
    |> Enum.map( fn ({d, a,b}) ->
      assert d == Graphmath.Vec3.chebyshev_distance(a,b)
    end)
  end

  @tag :vec3
  @tag :chebyshev_distance
  test "chebyshev_distance for vec3 of length 3 works" do
    [
      {3, {0,3,0},{1,0,0}},
      {3, {0,0,3},{0,1,0}},
      {3, {3,0,0},{0,0,1}}
    ]
    |> Enum.map( fn ({d, a,b}) ->
      assert d == Graphmath.Vec3.chebyshev_distance(a,b)
    end)
  end
end
