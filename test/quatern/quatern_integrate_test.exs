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

  @tag :quatern
  @tag :integrate
  test "zero time or velocity preserves orientation and normalizes the result" do
    for q <- [{0.5, -0.5, 0.5, -0.5}, {0, 1, 0, 0}, {0, 1.0, 0.0, 0}],
        dt <- [0, 0.0] do
      assert_close(Graphmath.Quatern.integrate(q, {1.0, -2.0, 3.0}, dt), q)
      assert_close(Graphmath.Quatern.integrate(q, {0.0, 0.0, 0.0}, 3.0), q)
      assert_close(Graphmath.Quatern.integrate(q, {0, 0, 0}, 3), q)
    end

    assert_close(Graphmath.Quatern.integrate({2, 0, 0, 0}, {0, 0, 0}, 0), {1, 0, 0, 0})

    assert_close(
      Graphmath.Quatern.integrate({2.0, 0.0, 0.0, 0.0}, {0.0, 0.0, 0.0}, 0.0),
      {1, 0, 0, 0}
    )
  end

  @tag :quatern
  @tag :integrate
  test "the zero quaternion remains zero" do
    for q <- [{0, 0, 0, 0}, {0.0, 0.0, 0.0, 0.0}] do
      assert Graphmath.Quatern.integrate(q, {1.0, -2.0, 2.0}, 0.01) === {0.0, 0.0, 0.0, 0.0}
    end
  end

  @tag :quatern
  @tag :integrate
  test "arbitrary-axis increments agree with analytic rotations in both numeric clauses" do
    for {q, omega} <- [
          {{1, 0, 0, 0}, {1, -2, 2}},
          {{1.0, 0.0, 0.0, 0.0}, {1.0, -2.0, 2.0}},
          {{1, 0.0, 0, 0.0}, {1.0, -2, 2.0}}
        ],
        dt <- [1, 1.0, 0.1, 0.001, 1.0e-9, -0.1] do
      # |omega| = 3, so angle = 3*dt about (1,-2,2)/3.
      c = :math.cos(1.5 * dt)
      s = :math.sin(1.5 * dt) / 3
      result = Graphmath.Quatern.integrate(q, omega, dt)
      assert_close(result, {c, s, -2 * s, 2 * s})
      assert_in_delta Graphmath.Quatern.norm(result), 1.0, 1.0e-12
    end
  end

  @tag :quatern
  @tag :integrate
  test "increments on both sides of the small-angle cutoff remain accurate" do
    for dt <- [0.02, 0.03],
        {q, omega} <- [{{1, 0, 0, 0}, {1, -2, 2}}, {{1.0, 0.0, 0.0, 0.0}, {1.0, -2.0, 2.0}}] do
      c = :math.cos(1.5 * dt)
      s = :math.sin(1.5 * dt) / 3
      # The Taylor branch truncates terms of fourth order and higher.
      assert_close(Graphmath.Quatern.integrate(q, omega, dt), {c, s, -2 * s, 2 * s}, 1.0e-9)
    end
  end

  @tag :quatern
  @tag :integrate
  test "angular velocity is world-space for a nonidentity initial orientation" do
    h = :math.sqrt(0.5)

    for q <- [{h, h, 0.0, 0.0}, {h, h, 0, 0}],
        omega <- [{0.0, 0.0, :math.pi() / 2}, {0, 0, :math.pi() / 2}] do
      # X quarter turn followed by a world Z quarter turn sends X -> Y and Y -> Z.
      result = Graphmath.Quatern.integrate(q, omega, 1.0)
      assert_close(result, {0.5, 0.5, 0.5, 0.5})
      assert_close(Graphmath.Quatern.transform_vector(result, {1.0, 0.0, 0.0}), {0, 1, 0})
      assert_close(Graphmath.Quatern.transform_vector(result, {0.0, 1.0, 0.0}), {0, 0, 1})
    end
  end

  @tag :quatern
  @tag :integrate
  test "repeated tiny steps match a known finite rotation without norm drift" do
    for {q, omega} <- [{{1, 0, 0, 0}, {1, -2, 2}}, {{1.0, 0.0, 0.0, 0.0}, {1.0, -2.0, 2.0}}] do
      result =
        Enum.reduce(1..1000, q, fn _, acc ->
          Graphmath.Quatern.integrate(acc, omega, 0.001)
        end)

      s = :math.sin(1.5) / 3
      assert_close(result, {:math.cos(1.5), s, -2 * s, 2 * s}, 1.0e-10)
      assert_in_delta Graphmath.Quatern.norm(result), 1.0, 1.0e-12
    end
  end

  defp assert_close(actual, expected, tolerance \\ 1.0e-12) do
    assert tuple_size(actual) == tuple_size(expected)

    for {a, b} <- Enum.zip(Tuple.to_list(actual), Tuple.to_list(expected)) do
      assert_in_delta a, b, tolerance
    end
  end
end
