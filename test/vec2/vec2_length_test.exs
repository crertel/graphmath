defmodule GraphmathTest.Vec2.LengthVec2 do
  use ExUnit.Case

  @tag :vec2
  @tag :length
  test "length({3,4}) returns 5" do
    assert 5 == Graphmath.Vec2.length({3, 4})
  end

  @tag :vec2
  @tag :length
  test "length_squared({3,4}) returns 25" do
    assert 25 == Graphmath.Vec2.length_squared({3, 4})
  end

  @tag :vec2
  @tag :length
  test "length_manhattan({3,4}) returns 7" do
    assert 7 == Graphmath.Vec2.length_manhattan({3, 4})
  end

  for {vector, expected} <- [
        {{0, 0}, 0.0},
        {{-3, 4}, 7.0},
        {{3, -4}, 7.0},
        {{-3, -4}, 7.0},
        {{0.0, 0.0}, 0.0},
        {{3.5, 4.25}, 7.75},
        {{-3.5, 4.25}, 7.75},
        {{3.5, -4.25}, 7.75},
        {{-3.5, -4.25}, 7.75},
        {{-3, 4.25}, 7.25},
        {{3.5, -4}, 7.5}
      ] do
    @tag :vec2
    @tag :length
    test "length_manhattan(#{inspect(vector)}) returns #{expected}" do
      vector = unquote(Macro.escape(vector))
      length = Graphmath.Vec2.length_manhattan(vector)

      assert length === unquote(expected)
      assert_in_delta length, Graphmath.Vec2.p_norm(vector, 1), 1.0e-12
    end
  end
end
