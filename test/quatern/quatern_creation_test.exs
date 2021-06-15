defmodule GraphmathTest.Quatern.CreateQuatern do
  use ExUnit.Case

  @tag :quatern
  @tag :create
  test "create returns {w,x,y,z} given (w,x,y,z)" do
    assert {3, 4, 5, 6} == Graphmath.Quatern.create(3, 4, 5, 6)
  end

  @tag :quatern
  @tag :create
  test "create returns {w,x,y,z} given quatern" do
    assert {1, 2, 3, 4} == Graphmath.Quatern.from_list([1, 2, 3, 4])
  end

  @tag :quatern
  @tag :create
  test "create return {w,x,y,z} given (w, vec3)" do
    sqrthalf = :math.sqrt(0.5)

    assert(
      case Graphmath.Quatern.from_axis_angle(:math.pi(), {0, 0, 1}) do
        {w, x, y, z} when w < 0.0005 and x < 0.0005 and y < 0.0005 and z > 0.9995 -> true
        _ -> false
      end
    )

    assert(
      case Graphmath.Quatern.from_axis_angle(:math.pi(), {0, 1, 0}) do
        {w, x, y, z} when w < 0.0005 and x < 0.0005 and y > 0.9995 and z < 0.0005 -> true
        _ -> false
      end
    )

    assert(
      case Graphmath.Quatern.from_axis_angle(:math.pi(), {0, 0, 1}) do
        {w, x, y, z} when w < 0.0005 and x < 0.0005 and y < 0.0005 and z > 0.9995 -> true
        _ -> false
      end
    )

    assert(
      case Graphmath.Quatern.from_axis_angle(:math.pi(), {1, 0, 0}) do
        {w, x, y, z} when w < 0.0005 and x > 0.9995 and y < 0.0005 and z < 0.0005 -> true
        _ -> false
      end
    )

    assert(
      case Graphmath.Quatern.from_axis_angle(:math.pi() / 2, {1, 0, 0}) do
        {w, x, y, z}
        when abs(w - sqrthalf) < 0.0005 and abs(x - sqrthalf) < 0.0005 and y < 0.0005 and
               z < 0.0005 ->
          true

        _ ->
          false
      end
    )
  end
end
