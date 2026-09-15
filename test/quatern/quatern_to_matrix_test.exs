defmodule GraphmathTest.Quatern.ToMatrixQuatern do
  use ExUnit.Case

  alias Graphmath.{Mat33, Mat44, Quatern, Vec2, Vec3}

  @sqrt_half :math.sqrt(0.5)

  for {axis, quaternion, matrix, vector, rotated} <- [
        {:x, {@sqrt_half, @sqrt_half, 0, 0}, {1, 0, 0, 0, 0, 1, 0, -1, 0}, {0, 1, 0}, {0, 0, 1}},
        {:y, {@sqrt_half, 0, @sqrt_half, 0}, {0, 0, -1, 0, 1, 0, 1, 0, 0}, {1, 0, 0}, {0, 0, -1}},
        {:z, {@sqrt_half, 0, 0, @sqrt_half}, {0, 1, 0, -1, 0, 0, 0, 0, 1}, {1, 0, 0}, {0, 1, 0}}
      ],
      numeric_type <- [:mixed, :float] do
    @tag :quatern
    @tag :to_matrix
    test "#{axis} rotation matrices agree with quaternion rotation for #{numeric_type} inputs" do
      q = unquote(Macro.escape(quaternion))
      v = unquote(Macro.escape(vector))
      expected = unquote(Macro.escape(rotated))

      {q, v} =
        if unquote(numeric_type) == :float do
          {to_float_tuple(q), to_float_tuple(v)}
        else
          {q, v}
        end

      m33 = Quatern.to_rotation_matrix_33(q)
      m44 = Quatern.to_rotation_matrix_44(q)
      {a, b, c, d, e, f, g, h, i} = unquote(Macro.escape(matrix))

      assert_tuple_close(m33, {a, b, c, d, e, f, g, h, i})
      assert_tuple_close(m44, {a, b, c, 0, d, e, f, 0, g, h, i, 0, 0, 0, 0, 1})
      assert_tuple_close(Quatern.transform_vector(q, v), expected)
      assert_tuple_close(Mat33.apply_left(v, m33), expected)
      assert_tuple_close(Mat33.apply_transpose(m33, v), expected)
      assert_tuple_close(Mat44.transform_vector(m44, v), expected)
      assert_tuple_close(Mat44.transform_point(m44, v), expected)
    end
  end

  @tag :quatern
  @tag :to_matrix
  test "rotation constructors agree with vectors and quaternion matrices" do
    for {axis, constructor} <- [
          {{1.0, 0.0, 0.0}, :make_rotate_x},
          {{0.0, 1.0, 0.0}, :make_rotate_y},
          {{0.0, 0.0, 1.0}, :make_rotate_z}
        ],
        angle <- [1, 1.0, -:math.pi() / 2.0] do
      v = {2.0, -3.0, 4.0}
      q = Quatern.from_axis_angle(angle, axis)
      matrix = apply(Mat44, constructor, [angle])
      assert_tuple_close(matrix, Quatern.to_rotation_matrix_44(q))
      assert_tuple_close(Mat44.transform_vector(matrix, v), Vec3.rotate(v, axis, angle))
    end
  end

  @tag :quatern
  @tag :to_matrix
  test "Z quaternion matrices agree with 2D rotation" do
    angle = 0.7
    matrix = Quatern.to_rotation_matrix_33(Quatern.from_axis_angle(angle, {0.0, 0.0, 1.0}))
    assert_tuple_close(matrix, Mat33.make_rotate(angle))

    assert_tuple_close(
      Mat33.transform_vector(matrix, {2.0, -3.0}),
      Vec2.rotate({2.0, -3.0}, angle)
    )
  end

  defp to_float_tuple(tuple) do
    tuple |> Tuple.to_list() |> Enum.map(&(&1 * 1.0)) |> List.to_tuple()
  end

  defp assert_tuple_close(actual, expected) do
    assert tuple_size(actual) == tuple_size(expected)

    for {a, b} <- Enum.zip(Tuple.to_list(actual), Tuple.to_list(expected)) do
      assert_in_delta a, b, 1.0e-10
    end
  end
end
