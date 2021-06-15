defmodule GraphmathTest.Mat44.MakeTranslation do
  use ExUnit.Case

  @tag :mat44
  @tag :make_translate
  test "make_translate( 0, 0, 0 ) returns a matrix of (0,0) translation" do
    assert {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1} ==
             Graphmath.Mat44.make_translate(0, 0, 0)
  end

  @tag :mat44
  @tag :make_translate
  test "make_translate( 1, 2, 3 ) returns a matrix of (1,2,3) translation" do
    assert {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1, 2, 3, 1} ==
             Graphmath.Mat44.make_translate(1, 2, 3)
  end
end
