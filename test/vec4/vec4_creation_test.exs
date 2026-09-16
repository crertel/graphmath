defmodule GraphmathTest.Vec4.Creation do
  use ExUnit.Case, async: true
  alias Graphmath.Vec4

  @moduletag :vec4
  @moduletag :create

  test "zero has four float components" do
    assert Vec4.create() === {0.0, 0.0, 0.0, 0.0}
  end

  test "component and list constructors convert numeric inputs to floats" do
    for {x, y, z, w} <- [{1, -2, 3, -4}, {1.0, -2.0, 3.0, -4.0}, {1, -2.0, 3, -4.0}] do
      assert Vec4.create(x, y, z, w) === {1.0, -2.0, 3.0, -4.0}
      assert Vec4.create([x, y, z, w]) === {1.0, -2.0, 3.0, -4.0}
      assert Vec4.create([x, y, z, w, :ignored]) === {1.0, -2.0, 3.0, -4.0}
    end

    assert Vec4.create([0.25, -0.5, 1.5, 2.75]) === {0.25, -0.5, 1.5, 2.75}
  end

  test "short lists raise" do
    for list <- [[], [1], [1, 2], [1, 2, 3]] do
      assert_raise FunctionClauseError, fn -> Vec4.create(list) end
    end
  end
end
