defmodule GraphmathTest.Vec4.Homogeneous do
  use ExUnit.Case, async: true
  alias Graphmath.{Mat44, Vec4}

  @moduletag :vec4
  @moduletag :from_point3
  @moduletag :from_direction3

  doctest Graphmath.Vec4, only: [from_point3: 1, from_direction3: 1]

  test "points and directions have distinct homogeneous coordinates" do
    for xyz <- [{2, -3, 4}, {2.0, -3.0, 4.0}, {2, -3.0, 4}] do
      assert Vec4.from_point3(xyz) === {2.0, -3.0, 4.0, 1.0}
      assert Vec4.from_direction3(xyz) === {2.0, -3.0, 4.0, 0.0}
    end

    assert Vec4.from_point3({0.25, -1.5, 2.75}) === {0.25, -1.5, 2.75, 1.0}
    assert Vec4.from_direction3({0.25, -1.5, 2.75}) === {0.25, -1.5, 2.75, 0.0}
    assert Vec4.from_point3({0, 0, 0}) === {0.0, 0.0, 0.0, 1.0}
  end

  @tag :apply_left
  @tag :make_translate
  test "row-vector affine translation moves points and leaves directions unchanged" do
    translation = Mat44.make_translate(5.0, -7.0, 11.0)
    point = Vec4.from_point3({2, -3, 4})
    direction = Vec4.from_direction3({2, -3, 4})
    assert Mat44.apply_left(point, translation) === {7.0, -10.0, 15.0, 1.0}
    assert Mat44.apply_left(direction, translation) === {2.0, -3.0, 4.0, 0.0}
  end

  @tag :add
  @tag :subtract
  @tag :lerp
  test "point and direction arithmetic retains the homogeneous interpretation" do
    a = Vec4.from_point3({1, 2, 3})
    b = Vec4.from_point3({5, 8, 11})
    displacement = Vec4.subtract(b, a)
    assert displacement === {4.0, 6.0, 8.0, 0.0}
    assert Vec4.add(a, displacement) === b
    assert Vec4.lerp(a, b, 0.25) === {2.0, 3.5, 5.0, 1.0}
  end

  @tag :normalize
  test "normalization operates in four dimensions" do
    {x, y, z, w} = Vec4.normalize({0.0, 0.0, 3.0, 4.0})
    assert {x, y} === {0.0, 0.0}
    assert_in_delta z, 0.6, 1.0e-12
    assert_in_delta w, 0.8, 1.0e-12
  end
end
