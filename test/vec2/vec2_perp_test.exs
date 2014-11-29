defmodule GraphmathTest.Veic2.Dot_Vec2 do
  use ExUnit.Case

  import Graphmath.Vec2

  test "perp_prod_vec2([2,0],[0,1]) returns 2" do
    assert 2 == Graphmath.Vec2.perp_prod_vec2([2,0],[0,1])
  end
  test "perp_prod_vec2([0,1],[2,0]) returns -2" do
    assert -2 == Graphmath.Vec2.perp_prod_vec2([0,1],[2,0])
  end
end
