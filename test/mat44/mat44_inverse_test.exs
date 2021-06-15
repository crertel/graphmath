defmodule GraphmathTest.Mat44.InverseMat44 do
  use ExUnit.Case

  @tag :mat44
  @tag :inverse
  test "inverse(I) == I" do
    assert Graphmath.Mat44.identity() == Graphmath.Mat44.inverse(Graphmath.Mat44.identity())
  end

  @tag :mat44
  @tag :inverse
  test "A * inverse(A) == I" do
    a = {1, 2, 3, 6, 0, -3, 1, 4, -1, 9, 8, 1, -3, 7, 0, 2}
    inverse_a = Graphmath.Mat44.round(Graphmath.Mat44.inverse(a), 2)

    assert Graphmath.Mat44.round(Graphmath.Mat44.multiply(a, inverse_a), 1) ==
             Graphmath.Mat44.identity()
  end

  @tag :mat44
  @tag :inverse
  test "inverse(A) == B" do
    a = {-2, 3, 1, -1, 0, 1, 2, 3, 1, -1, 1, 2, 4, -3, 5, 1}

    m = Graphmath.Mat44.round(Graphmath.Mat44.inverse(a), 2)

    assert m ==
             {-5 / 2, 3, -6, 1 / 2, -17 / 10, 12 / 5, -23 / 5, 3 / 10, 1, -1, 2, 0, -1 / 10,
              1 / 5, 1 / 5, -1 / 10}
  end

  @tag :mat44
  @tag :inverse
  test "inverse(inverse(A)) == A" do
    a = {1, 2, 3, 6, 0, -3, 1, 4, -1, 9, 8, 1, -3, 7, 0, 2}
    inverse_a = Graphmath.Mat44.inverse(a)
    inverse_inverse_a = Graphmath.Mat44.round(Graphmath.Mat44.inverse(inverse_a), 1)

    assert inverse_inverse_a == a
  end
end
