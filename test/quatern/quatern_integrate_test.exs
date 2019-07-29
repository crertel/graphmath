defmodule GraphmathTest.Quatern.Integrate do
  use ExUnit.Case

  @tag :quatern
  @tag :integrate
  test "integrate() for 1 sec at 180/sec about x returns right answer" do
    start = {1.0, 0.0, 0.0, 0.0}
    x_axis_180 = {:math.pi(), 0.0, 0.0}
    dt = 1.0
    sqrt_half = :math.sqrt(0.5)

    assert Graphmath.Quatern.equal(
             {0.0, 1.0, 0.0, 0.0},
             Graphmath.Quatern.integrate(start, x_axis_180, dt)
           )

    assert Graphmath.Quatern.equal(
             {sqrt_half, sqrt_half, 0.0, 0.0},
             Graphmath.Quatern.integrate(start, x_axis_180, dt / 2)
           )
  end

  @tag :quatern
  @tag :integrate
  test "integrate() for 1 sec at 180/sec about y returns right answer" do
    start = {1.0, 0.0, 0.0, 0.0}
    y_axis_180 = {0.0, :math.pi(), 0.0}
    dt = 1.0
    sqrt_half = :math.sqrt(0.5)

    assert Graphmath.Quatern.equal(
             {0.0, 0.0, 1.0, 0.0},
             Graphmath.Quatern.integrate(start, y_axis_180, dt)
           )

    assert Graphmath.Quatern.equal(
             {sqrt_half, 0.0, sqrt_half, 0.0},
             Graphmath.Quatern.integrate(start, y_axis_180, dt / 2)
           )
  end

  @tag :quatern
  @tag :integrate
  test "integrate() for 1 sec at 180/sec about z returns right answer" do
    start = {1.0, 0.0, 0.0, 0.0}
    z_axis_180 = {0.0, 0.0, :math.pi()}
    dt = 1.0
    sqrt_half = :math.sqrt(0.5)

    assert Graphmath.Quatern.equal(
             {0.0, 0.0, 0.0, 1.0},
             Graphmath.Quatern.integrate(start, z_axis_180, dt)
           )

    assert Graphmath.Quatern.equal(
             {sqrt_half, 0.0, 0.0, sqrt_half},
             Graphmath.Quatern.integrate(start, z_axis_180, dt / 2)
           )
  end
end
