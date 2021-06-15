defmodule GraphmathTest.Vec2.PerpProdVec2 do
  use ExUnit.Case

  @tag :vec2
  @tag :perp_prod
  test "perp_prod({2,0},{0,1}) returns 2" do
    assert 2 == Graphmath.Vec2.perp_prod({2, 0}, {0, 1})
  end

  @tag :vec2
  @tag :perp_prod
  test "perp_prod({0,1},{2,0}) returns -2" do
    assert -2 == Graphmath.Vec2.perp_prod({0, 1}, {2, 0})
  end
end
