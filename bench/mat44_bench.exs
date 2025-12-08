alias Graphmath.Mat44

# Test data setup - 4x4 matrices stored as 16-element tuples (row-major)
mat44_a = {1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0}
mat44_b = {16.0, 15.0, 14.0, 13.0, 12.0, 11.0, 10.0, 9.0, 8.0, 7.0, 6.0, 5.0, 4.0, 3.0, 2.0, 1.0}
vec3 = {3.0, 4.0, 5.0}
vec4 = {3.0, 4.0, 5.0, 1.0}
scalar = 2.5
angle = :math.pi() / 4
mat44_list = for _ <- 1..10, do: Mat44.identity()

Benchee.run(
  %{
    # Identity and creation
    "Mat44.identity/0" => fn -> Mat44.identity() end,
    "Mat44.zero/0" => fn -> Mat44.zero() end,

    # Basic arithmetic
    "Mat44.add/2" => fn -> Mat44.add(mat44_a, mat44_b) end,
    "Mat44.subtract/2" => fn -> Mat44.subtract(mat44_a, mat44_b) end,
    "Mat44.scale/2" => fn -> Mat44.scale(mat44_a, scalar) end,

    # Matrix multiplication
    "Mat44.multiply/2" => fn -> Mat44.multiply(mat44_a, mat44_b) end,
    "Mat44.multiply_transpose/2" => fn -> Mat44.multiply_transpose(mat44_a, mat44_b) end,

    # Vector transformation
    "Mat44.apply/2 (vec3)" => fn -> Mat44.apply(mat44_a, vec4) end,
    "Mat44.apply_transpose/2 (vec3)" => fn -> Mat44.apply_transpose(mat44_a, vec4) end,
    "Mat44.apply_left/2 (vec3)" => fn -> Mat44.apply_left(vec4, mat44_a) end,
    "Mat44.apply_left_transpose/2 (vec3)" => fn -> Mat44.apply_left_transpose(vec4, mat44_a) end,
    "Mat44.transform_point/2" => fn -> Mat44.transform_point(mat44_a, vec3) end,
    "Mat44.transform_vector/2" => fn -> Mat44.transform_vector(mat44_a, vec3) end,

    # Rotation matrices
    "Mat44.make_rotate_x/1" => fn -> Mat44.make_rotate_x(angle) end,
    "Mat44.make_rotate_y/1" => fn -> Mat44.make_rotate_y(angle) end,
    "Mat44.make_rotate_z/1" => fn -> Mat44.make_rotate_z(angle) end,

    # Scale matrices
    "Mat44.make_scale/1 (uniform)" => fn -> Mat44.make_scale(2.0) end,
    "Mat44.make_scale/4" => fn -> Mat44.make_scale(2.0, 3.0, 4.0, 5.0) end,

    # Translation matrices
    "Mat44.make_translate/3" => fn -> Mat44.make_translate(5.0, 10.0, 15.0) end,

    # Component access
    "Mat44.row0/1" => fn -> Mat44.row0(mat44_a) end,
    "Mat44.row1/1" => fn -> Mat44.row1(mat44_a) end,
    "Mat44.row2/1" => fn -> Mat44.row2(mat44_a) end,
    "Mat44.row3/1" => fn -> Mat44.row3(mat44_a) end,
    "Mat44.column0/1" => fn -> Mat44.column0(mat44_a) end,
    "Mat44.column1/1" => fn -> Mat44.column1(mat44_a) end,
    "Mat44.column2/1" => fn -> Mat44.column2(mat44_a) end,
    "Mat44.column3/1" => fn -> Mat44.column3(mat44_a) end,
    "Mat44.diag/1" => fn -> Mat44.diag(mat44_a) end,
    "Mat44.at/3" => fn -> Mat44.at(mat44_a, 2, 2) end,

    # Extract submatrices
    "Mat44.round/2" => fn -> Mat44.round(mat44_a, 3) end,

    # Batch operation (chain multiply 10 matrices)
    "Mat44 batch multiply (10 matrices)" => fn ->
      Enum.reduce(mat44_list, Mat44.identity(), &Mat44.multiply/2)
    end
  },
  warmup: 2,
  time: 5,
  memory_time: 2,
  formatters: [
    Benchee.Formatters.Console,
    {Benchee.Formatters.Markdown, file: "bench/results/mat44_results.md"}
  ]
)
