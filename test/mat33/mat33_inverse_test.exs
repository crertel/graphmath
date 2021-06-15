defmodule GraphmathTest.Mat33.InverseMat33 do
  use ExUnit.Case

  @tag :Mat33
  @tag :inverse
  test "inverse(I) == I" do
    assert Graphmath.Mat33.identity() == Graphmath.Mat33.inverse(Graphmath.Mat33.identity())
  end

  @tag :Mat33
  @tag :inverse
  test "A * inverse(A) == I" do
    a = {1, 2, 3, 0, -3, 1, -1, 9, 8}
    inverse_a = Graphmath.Mat33.round(Graphmath.Mat33.inverse(a), 2)

    assert Graphmath.Mat33.round(Graphmath.Mat33.multiply(a, inverse_a), 1) ==
             Graphmath.Mat33.identity()
  end

  @tag :Mat33
  @tag :inverse
  test "inverse(A) == B" do
    a = {-2, 3, 1, 0, 1, 2, 1, -1, 1}

    m = Graphmath.Mat33.round(Graphmath.Mat33.inverse(a), 2)

    assert m == {-3, 4, -5, -2, 3, -4, 1, -1, 2}
  end

  @tag :Mat33
  @tag :inverse
  test "inverse(inverse(A)) == A" do
    a = {1, 2, 3, 0, -3, 1, -1, 9, 8}
    inverse_a = Graphmath.Mat33.inverse(a)
    inverse_inverse_a = Graphmath.Mat33.round(Graphmath.Mat33.inverse(inverse_a), 1)

    assert inverse_inverse_a == a
  end
end
