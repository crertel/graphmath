defmodule GraphmathTest.Vec2.PNormVec2 do
  use ExUnit.Case

  @tag :vec2
  @tag :p_norm
  test "p_norm of zero vector order 1 returns 0" do
    [
      {0, {0,0}, 1}
    ]
    |> Enum.map( fn {d,v,o} ->
      assert d == Graphmath.Vec2.p_norm(v,o)
    end)
  end

  @tag :vec2
  @tag :p_norm
  test "p_norm of unit vector order 1 returns 1" do
    [
      {1, {1,0}, 1},
      {1, {0,1}, 1},
    ]
    |> Enum.map( fn {d,v,o} ->
      assert d == Graphmath.Vec2.p_norm(v,o)
    end)
  end

  @tag :vec2
  @tag :p_norm
  test "p_norm of unit vector order 2 returns 1" do
    [
      {1, {1,0}, 2},
      {1, {0,1}, 2}
    ]
    |> Enum.map( fn {d,v,o} ->
      assert d == Graphmath.Vec2.p_norm(v,o)
    end)
  end

  @tag :vec2
  @tag :p_norm
  test "p_norm of axis diagonal vector order 1 returns 2" do
    [
      {2, {1,1}, 1},
    ]
    |> Enum.map( fn {d,v,o} ->
      assert d == Graphmath.Vec2.p_norm(v,o)
    end)
  end

  @tag :vec2
  @tag :p_norm
  test "p_norm of axis diagonal vector order 2 returns sqrt(2)" do
    [
      {:math.sqrt(2), {1,1}, 2},
    ]
    |> Enum.map( fn {d,v,o} ->
      assert d == Graphmath.Vec2.p_norm(v,o)
    end)
  end
end
