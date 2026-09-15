defmodule GraphmathTest.Vec3.RandomVec3 do
  use ExUnit.Case, async: true
  alias Graphmath.Vec3

  @moduletag :vec3

  setup do
    :rand.seed(:exsss, {17, 29, 43})
    :ok
  end

  @tag :length_squared
  @tag :random
  @tag :random_sphere
  test "random_sphere samples the unit sphere in all directions" do
    samples = for _ <- 1..2000, do: Vec3.random_sphere()
    for v <- samples, do: assert_in_delta(Vec3.length_squared(v), 1.0, 1.0e-12)
    assert_spread(samples, 1 / 3)
  end

  @tag :length_squared
  @tag :random
  @tag :random_ball
  test "random_ball samples the interior uniformly by volume" do
    samples = for _ <- 1..2000, do: Vec3.random_ball()
    radii_squared = Enum.map(samples, &Vec3.length_squared/1)
    assert Enum.all?(radii_squared, &(&1 >= 0.0 and &1 <= 1.0))
    # Uniform volume has E[r^2] = 3/5 and P(r < 1/2) = 1/8.
    assert_in_delta mean(radii_squared), 0.6, 0.04
    assert_in_delta Enum.count(radii_squared, &(&1 < 0.25)) / 2000, 0.125, 0.04
    assert_spread(samples, 0.2)
  end

  @tag :random
  @tag :random_box
  test "random_box samples all coordinates throughout [0, 1]" do
    samples = for _ <- 1..2000, do: Vec3.random_box()
    assert MapSet.size(MapSet.new(samples)) > 1900

    for i <- 0..2 do
      values = Enum.map(samples, &elem(&1, i))
      assert Enum.all?(values, &(is_float(&1) and &1 >= 0.0 and &1 <= 1.0))
      assert Enum.min(values) < 0.1
      assert Enum.max(values) > 0.9
      assert_in_delta mean(values), 0.5, 0.04
      assert_in_delta mean(Enum.map(values, &(&1 * &1))), 1 / 3, 0.04
    end
  end

  defp assert_spread(samples, second_moment) do
    assert MapSet.size(MapSet.new(samples)) > 1900

    for i <- 0..2 do
      values = Enum.map(samples, &elem(&1, i))
      assert Enum.min(values) < -0.8
      assert Enum.max(values) > 0.8
      assert_in_delta mean(values), 0.0, 0.04
      assert_in_delta mean(Enum.map(values, &(&1 * &1))), second_moment, 0.04
    end

    assert_in_delta mean(Enum.map(samples, fn {x, y, _z} -> x * y end)), 0.0, 0.04
  end

  defp mean(values), do: Enum.sum(values) / length(values)
end
