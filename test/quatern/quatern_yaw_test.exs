defmodule GraphmathTest.Quatern.YawQuatern do
  use ExUnit.Case

  @tag :quatern
  @tag :get_yaw
  # values obtained through another calculator
  test "get_yaw({5,6,7,8}) returns 2.3651494746933115" do
    assert 2.3651494746933115 == Graphmath.Quatern.get_yaw({5, 6, 7, 8})
  end
end
