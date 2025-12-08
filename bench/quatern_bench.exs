alias Graphmath.Quatern
alias Graphmath.Mat33

# Test data setup - quaternions stored as {w, x, y, z}
quat_a = Quatern.from_axis_angle(:math.pi() / 4, {0.0, 1.0, 0.0})
quat_b = Quatern.from_axis_angle(:math.pi() / 3, {1.0, 0.0, 0.0})
quat_identity = Quatern.identity()
vec3 = {3.0, 4.0, 5.0}
scalar = 2.5
angle = :math.pi() / 4
axis = {0.0, 1.0, 0.0}
quat_list = for _ <- 1..10, do: Quatern.identity()

Benchee.run(
  %{
    # Baseline
    "Baseline" => fn -> {1.0, 0.0, 0.0, 0.0} end,

    # Identity and creation
    "Quatern.zero/0" => fn -> Quatern.zero() end,
    "Quatern.identity/0" => fn -> Quatern.identity() end,
    "Quatern.from_axis_angle/2" => fn -> Quatern.from_axis_angle(angle, axis) end,
    "Quatern.random/0" => fn -> Quatern.random() end,

    # Basic arithmetic
    "Quatern.add/2" => fn -> Quatern.add(quat_a, quat_b) end,
    "Quatern.subtract/2" => fn -> Quatern.subtract(quat_a, quat_b) end,
    "Quatern.scale/2" => fn -> Quatern.scale(quat_a, scalar) end,

    # Quaternion multiplication (Hamilton product)
    "Quatern.multiply/2" => fn -> Quatern.multiply(quat_a, quat_b) end,

    # Conjugate and inverse
    "Quatern.conjugate/1" => fn -> Quatern.conjugate(quat_a) end,
    "Quatern.inverse/1" => fn -> Quatern.inverse(quat_a) end,

    # Length operations
    "Quatern.norm/1" => fn -> Quatern.norm(quat_a) end,
    "Quatern.normalize/1" => fn -> Quatern.normalize(quat_a) end,
    "Quatern.normalize_strict/1" => fn -> Quatern.normalize_strict(quat_a) end,

    # Vector rotation
    "Quatern.transform_vector/2" => fn -> Quatern.transform_vector(quat_a, vec3) end,

    # Interpolation
    "Quatern.slerp/3" => fn -> Quatern.slerp(quat_a, quat_b, 0.5) end,

    # Dot product
    "Quatern.dot/2" => fn -> Quatern.dot(quat_a, quat_b) end,

    # Comparison
    "Quatern.equal/2" => fn -> Quatern.equal(quat_a, quat_b) end,
    "Quatern.equal/3 (epsilon)" => fn -> Quatern.equal(quat_a, quat_b, 0.001) end,
    "Quatern.equal_elements/2" => fn -> Quatern.equal_elements(quat_a, quat_b) end,
    "Quatern.equal_elements/3 (epsilon)" => fn -> Quatern.equal_elements(quat_a, quat_b, 0.001) end,

    # Conversion
    "Quatern.to_rotation_matrix_33/1" => fn -> Quatern.to_rotation_matrix_33(quat_a) end,
    "Quatern.to_rotation_matrix_44/1" => fn -> Quatern.to_rotation_matrix_44(quat_a) end,
    "Quatern.from_rotation_matrix/1" => fn ->
      mat = Mat33.make_rotate(angle)
      Quatern.from_rotation_matrix(mat)
    end,
    "Quatern.from_axis_angle/1" => fn -> Quatern.from_axis_angle( 0.0, {1,0,0}) end,
    "Quatern.from_list/1" => fn -> Quatern.from_list([1,2,3,0]) end,

    # Pitch/yaw/roll extraction
    "Quatern.get_pitch/1" => fn -> Quatern.get_pitch(quat_a) end,
    "Quatern.get_yaw/1" => fn -> Quatern.get_yaw(quat_a) end,
    "Quatern.get_roll/1" => fn -> Quatern.get_roll(quat_a) end,

    # Complex operations
    "Quatern.integrate" => fn -> Quatern.integrate({1.0, 0.0, 0.0, 0.0}, {0.0, :math.pi(), 0.0}, 1.0) end,
    "Quatern rotate->inverse->transform" => fn ->
      q = Quatern.from_axis_angle(angle, {0.0, 1.0, 0.0})
      q_inv = Quatern.inverse(q)
      rotated = Quatern.transform_vector(q, vec3)
      Quatern.transform_vector(q_inv, rotated)
    end,

    # Batch operation (chain multiply 10 quaternions)
    "Quatern batch multiply (10 quaternions)" => fn ->
      Enum.reduce(quat_list, Quatern.identity(), &Quatern.multiply/2)
    end,

    # Slerp chain (useful for animation)
    "Quatern slerp chain (10 steps)" => fn ->
      for t <- 0..9 do
        Quatern.slerp(quat_a, quat_b, t / 9.0)
      end
    end
  },
  warmup: 2,
  time: 5,
  memory_time: 2,
  formatters: [
    Benchee.Formatters.Console,
    {Benchee.Formatters.Markdown, file: "bench/results/quatern_results.md"}
  ]
)
