defmodule GraphmathTest.Quatern.FromMatrixQuatern do
  use ExUnit.Case

  alias Graphmath.Quatern

  @sqrt_half :math.sqrt(0.5)
  @sqrt_three_quarters :math.sqrt(0.75)

  for {name, matrix, expected} <- [
        {"identity", {1, 0, 0, 0, 1, 0, 0, 0, 1}, {1.0, 0.0, 0.0, 0.0}},
        {"X half-turn", {1, 0, 0, 0, -1, 0, 0, 0, -1}, {0.0, 1.0, 0.0, 0.0}},
        {"Y half-turn", {-1, 0, 0, 0, 1, 0, 0, 0, -1}, {0.0, 0.0, 1.0, 0.0}},
        {"Z half-turn", {-1, 0, 0, 0, -1, 0, 0, 0, 1}, {0.0, 0.0, 0.0, 1.0}},
        {"XY half-turn", {0, 1, 0, 1, 0, 0, 0, 0, -1}, {0.0, @sqrt_half, @sqrt_half, 0.0}},
        {"X quarter-turn", {1, 0, 0, 0, 0, 1, 0, -1, 0}, {@sqrt_half, @sqrt_half, 0.0, 0.0}},
        {"Y quarter-turn", {0, 0, -1, 0, 1, 0, 1, 0, 0}, {@sqrt_half, 0.0, @sqrt_half, 0.0}},
        {"Z quarter-turn", {0, 1, 0, -1, 0, 0, 0, 0, 1}, {@sqrt_half, 0.0, 0.0, @sqrt_half}},
        {"X third-turn", {1, 0, 0, 0, -0.5, @sqrt_three_quarters, 0, -@sqrt_three_quarters, -0.5},
         {0.5, @sqrt_three_quarters, 0.0, 0.0}},
        {"Y third-turn", {-0.5, 0, -@sqrt_three_quarters, 0, 1, 0, @sqrt_three_quarters, 0, -0.5},
         {0.5, 0.0, @sqrt_three_quarters, 0.0}},
        {"Z third-turn", {-0.5, @sqrt_three_quarters, 0, -@sqrt_three_quarters, -0.5, 0, 0, 0, 1},
         {0.5, 0.0, 0.0, @sqrt_three_quarters}},
        {"negative Y third-turn",
         {-0.5, 0, @sqrt_three_quarters, 0, 1, 0, -@sqrt_three_quarters, 0, -0.5},
         {0.5, 0.0, -@sqrt_three_quarters, 0.0}}
      ],
      numeric_type <- [:general, :float] do
    @tag :quatern
    @tag :from_matrix
    test "from_rotation_matrix handles #{name} through the #{numeric_type} clause" do
      matrix = unquote(Macro.escape(matrix))

      matrix =
        if unquote(numeric_type) == :float do
          matrix |> Tuple.to_list() |> Enum.map(&(&1 * 1.0)) |> List.to_tuple()
        else
          matrix
        end

      assert_same_orientation(
        Quatern.from_rotation_matrix(matrix),
        unquote(Macro.escape(expected))
      )
    end
  end

  @tag :quatern
  @tag :from_matrix
  test "matrix round trips preserve orientation across the trace boundary and diagonal choices" do
    axes = [{1.0, 2.0, 3.0}, {2.0, 3.0, 1.0}, {3.0, 1.0, 2.0}]
    boundary = 2.0 * :math.pi() / 3.0

    for axis <- axes, angle <- [boundary - 1.0e-6, boundary, boundary + 1.0e-6, :math.pi()] do
      q = Quatern.from_axis_angle(angle, Graphmath.Vec3.normalize(axis))
      actual = q |> Quatern.to_rotation_matrix_33() |> Quatern.from_rotation_matrix()
      assert_same_orientation(actual, q)
    end
  end

  defp assert_same_orientation(actual, expected) do
    assert tuple_size(actual) == 4
    components = Enum.zip(Tuple.to_list(actual), Tuple.to_list(expected))

    assert Enum.all?(components, fn {a, b} -> abs(a - b) < 1.0e-10 end) or
             Enum.all?(components, fn {a, b} -> abs(a + b) < 1.0e-10 end),
           "expected #{inspect(actual)} to represent #{inspect(expected)}"
  end
end
