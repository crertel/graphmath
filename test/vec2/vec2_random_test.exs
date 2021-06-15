defmodule GraphmathTest.Vec2.RandomVec2 do
  use ExUnit.Case

  @very_smol 1.0e-10

  @tag :vec2
  @tag :random
  test "random_circle/0 works" do
    v = Graphmath.Vec2.random_circle()
    assert abs(1.0 - Graphmath.Vec2.length_squared(v)) < @very_smol
  end

  @tag :vec2
  @tag :random
  test "random_disc/0 works" do
    v = Graphmath.Vec2.random_disc()
    assert Graphmath.Vec2.length_squared(v) <= 1.0
  end

  @tag :vec2
  @tag :random
  test "random_square/0 works" do
    {x, y} = Graphmath.Vec2.random_disc()
    assert abs(x) <= 1.0
    assert abs(y) <= 1.0
  end
end
