defmodule GraphmathTest.Vec3.LengthVec3 do
  use ExUnit.Case

  @tag :vec3
  @tag :length
  test "length({3,0,4}) returns 5" do
    assert 5 == Graphmath.Vec3.length({3, 0, 4})
  end

  @tag :vec3
  @tag :length
  test "length_squared({3,2,4}) returns 29" do
    assert 29 == Graphmath.Vec3.length_squared({3, 2, 4})
  end

  @tag :vec3
  @tag :length
  test "length_manhattan({3,4,5}) returns 12" do
    assert 12 == Graphmath.Vec3.length_manhattan({3, 4, 5})
  end

  for {vector, expected} <- [
        {{0, 0, 0}, 0.0},
        {{-3, 4, 5}, 12.0},
        {{3, -4, 5}, 12.0},
        {{3, 4, -5}, 12.0},
        {{-3, -4, -5}, 12.0},
        {{0.0, 0.0, 0.0}, 0.0},
        {{3.5, 4.25, 5.75}, 13.5},
        {{-3.5, 4.25, 5.75}, 13.5},
        {{3.5, -4.25, 5.75}, 13.5},
        {{3.5, 4.25, -5.75}, 13.5},
        {{-3.5, -4.25, -5.75}, 13.5},
        {{-3, 4.25, -5}, 12.25},
        {{3.5, -4, 5.75}, 13.25}
      ] do
    @tag :vec3
    @tag :length
    test "length_manhattan(#{inspect(vector)}) returns #{expected}" do
      vector = unquote(Macro.escape(vector))
      length = Graphmath.Vec3.length_manhattan(vector)

      assert length === unquote(expected)
      assert_in_delta length, Graphmath.Vec3.p_norm(vector, 1), 1.0e-12
    end
  end
end
