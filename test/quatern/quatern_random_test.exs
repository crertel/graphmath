defmodule Graphmath.Quatern.RandomQuatern do
  use ExUnit.Case, async: true
  alias Graphmath.Quatern

  @moduletag :quatern
  @moduletag :random

  test "random orientations have unit norm and broad symmetric coverage" do
    :rand.seed(:exsss, {17, 29, 43})
    samples = for _ <- 1..4000, do: Quatern.random()
    assert MapSet.size(MapSet.new(samples)) > 3900
    for q <- samples, do: assert_in_delta(Quatern.norm(q), 1.0, 1.0e-12)
    # Uniform points on S^3 have zero component means and second moment 1/4.
    for i <- 0..3 do
      values = Enum.map(samples, &elem(&1, i))
      assert Enum.min(values) < -0.8
      assert Enum.max(values) > 0.8
      assert_in_delta mean(values), 0.0, 0.04
      assert_in_delta mean(Enum.map(values, &(&1 * &1))), 0.25, 0.04
    end

    # A uniformly rotated basis direction is uniform on S^2.
    rotated = Enum.map(samples, &Quatern.transform_vector(&1, {1.0, 0.0, 0.0}))

    for i <- 0..2 do
      values = Enum.map(rotated, &elem(&1, i))
      assert_in_delta mean(values), 0.0, 0.04
      assert_in_delta mean(Enum.map(values, &(&1 * &1))), 1 / 3, 0.04
    end
  end

  defp mean(values), do: Enum.sum(values) / length(values)
end
