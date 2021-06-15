defmodule GraphmathTest.Mat33.MakeTranslate do
  use ExUnit.Case

  @tag :mat33
  @tag :make_translate
  test "make_translate( 0, 0, 0 ) returns a matrix of (0,0) translation" do
    assert {1, 0, 0, 0, 1, 0, 0, 0, 1} == Graphmath.Mat33.make_translate(0, 0)
  end

  @tag :mat33
  @tag :make_translate
  test "make_translate( 1, 2 ) returns a matrix of (1,2) translation" do
    assert {1, 0, 0, 0, 1, 0, 1, 2, 1} == Graphmath.Mat33.make_translate(1, 2)
  end
end
