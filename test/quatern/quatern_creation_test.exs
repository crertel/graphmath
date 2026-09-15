defmodule GraphmathTest.Quatern.CreateQuatern do
  use ExUnit.Case, async: true
  alias Graphmath.Quatern

  @moduletag :quatern

  @tag :create
  @tag :from_list
  @tag :identity
  @tag :zero
  test "component and list constructors return floats in scalar-first order" do
    for [w, x, y, z] <- [[3, -4, 5, -6], [3.0, -4.0, 5.0, -6.0], [3, -4.0, 5, -6.0]] do
      assert Quatern.create(w, x, y, z) === {3.0, -4.0, 5.0, -6.0}
      assert Quatern.from_list([w, x, y, z, :ignored]) === {3.0, -4.0, 5.0, -6.0}
    end

    assert Quatern.create(0.5, -1.5, 2.5, -3.5) === {0.5, -1.5, 2.5, -3.5}
    assert Quatern.identity() === {1.0, 0.0, 0.0, 0.0}
    assert Quatern.zero() === {0.0, 0.0, 0.0, 0.0}
  end

  @tag :create
  @tag :from_axis_angle
  test "axis-angle construction has the expected sign and absolute component error" do
    for axis <- [
          {1, 0, 0},
          {0, 1, 0},
          {0, 0, 1},
          {1.0, 0.0, 0.0},
          {0.0, 1.0, 0.0},
          {0.0, 0.0, 1.0},
          {0, 0.0, 1.0}
        ],
        {angle, w, s} <- [
          {0, 1.0, 0.0},
          {0.0, 1.0, 0.0},
          {:math.pi(), 0.0, 1.0},
          {-:math.pi(), 0.0, -1.0},
          {:math.pi() / 2, :math.sqrt(0.5), :math.sqrt(0.5)}
        ] do
      {x, y, z} = axis
      expected = {w, s * x, s * y, s * z}
      actual = Quatern.from_axis_angle(angle, axis)

      for {a, b} <- Enum.zip(Tuple.to_list(actual), Tuple.to_list(expected)) do
        assert_in_delta a, b, 1.0e-12
      end
    end
  end
end
