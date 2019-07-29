defmodule Graphmath.Quatern.RandomQuatern do
  use ExUnit.Case

  @tag :quatern
  @tag :random
  test "random/0 works" do
    {w, x, y, z} = Graphmath.Quatern.random()
    assert abs(1 - :math.sqrt(w * w + x * x + y * y + z * z)) < 0.00005
  end
end
