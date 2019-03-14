defmodule GraphmathTest.Quatern.PitchQuatern do
  use ExUnit.Case

  @tag :quatern
  @tag :get_pitch
  # values obtained through another calculator
  test "get_pitch({5,6,7,8}) returns 2.428842693496242" do
    assert 2.428842693496242 == Graphmath.Quatern.get_pitch({5, 6, 7, 8})
  end
end
