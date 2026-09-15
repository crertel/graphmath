defmodule GraphmathTest.Mat22.Creation do
  use ExUnit.Case, async: true
  alias Graphmath.Mat22

  @moduletag :mat22

  @tag :identity
  @tag :zero
  test "identity and zero have four floating-point entries" do
    assert Mat22.identity() === {1.0, 0.0, 0.0, 1.0}
    assert Mat22.zero() === {0.0, 0.0, 0.0, 0.0}
  end

  @tag :make_scale
  test "uniform scale constructors support integer and fractional factors" do
    for k <- [2, 2.0] do
      assert Mat22.make_scale(k) == {2, 0, 0, 2}
    end

    assert Mat22.make_scale(-0.5) === {-0.5, 0.0, 0.0, -0.5}
    assert Mat22.make_scale(0) == Mat22.zero()
  end

  @tag :make_scale
  test "nonuniform scale constructors preserve axis order" do
    for {sx, sy} <- [{2, -3}, {2.0, -3.0}, {2, -3.0}] do
      assert Mat22.make_scale(sx, sy) == {2, 0, 0, -3}
    end

    assert Mat22.make_scale(0.5, -1.5) === {0.5, 0.0, 0.0, -1.5}
  end

  @tag :round
  test "rounding returns floats for all numeric inputs" do
    for a <- [{1, -2, 3, 4}, {1.0, -2.0, 3.0, 4.0}, {1, -2.0, 3, 4.0}] do
      assert Mat22.round(a, 0) === {1.0, -2.0, 3.0, 4.0}
    end
  end

  @tag :round
  test "rounding handles signed fractions and both precision endpoints" do
    a = {0.125, -1.125, 2.125, -3.125}
    assert Mat22.round(a, 0) == {0.0, -1.0, 2.0, -3.0}
    assert Mat22.round(a, 2) === {0.13, -1.13, 2.13, -3.13}
    assert Mat22.round(a, 15) === a
    assert Mat22.round({0, -1.125, 2, -3.125}, 2) === {0.0, -1.13, 2.0, -3.13}
  end
end
