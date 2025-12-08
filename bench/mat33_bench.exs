alias Graphmath.Mat33

# Test data setup - 3x3 matrices stored as 9-element tuples (row-major)
mat33_a = {1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0}
mat33_b = {9.0, 8.0, 7.0, 6.0, 5.0, 4.0, 3.0, 2.0, 1.0}
mat33_invertible = {1.0, 0.0, 0.0, 0.0, 2.0, 0.0, 0.0, 0.0, 3.0}
vec2 = {3.0, 4.0}
vec3 = {3.0, 4.0, 1.0}
scalar = 2.5
angle = :math.pi() / 4
mat33_list = for _ <- 1..10, do: Mat33.identity()

Benchee.run(
  %{
    "Baseline" => fn -> {1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0} end,

    # Identity and creation
    "Mat33.identity/0" => fn -> Mat33.identity() end,
    "Mat33.zero/0" => fn -> Mat33.zero() end,

    # Basic arithmetic
    "Mat33.add/2" => fn -> Mat33.add(mat33_a, mat33_b) end,
    "Mat33.subtract/2" => fn -> Mat33.subtract(mat33_a, mat33_b) end,
    "Mat33.scale/2" => fn -> Mat33.scale(mat33_a, scalar) end,

    # Matrix multiplication
    "Mat33.multiply/2" => fn -> Mat33.multiply(mat33_a, mat33_b) end,
    "Mat33.multiply_transpose/2" => fn -> Mat33.multiply_transpose(mat33_a, mat33_b) end,

    # Inverse
    "Mat33.inverse/1" => fn -> Mat33.inverse(mat33_invertible) end,

    # Vector transformation
    "Mat33.apply/2 (vec2)" => fn -> Mat33.apply(mat33_a, vec3) end,
    "Mat33.apply_transpose/2 (vec2)" => fn -> Mat33.apply_transpose(mat33_a, vec3) end,
    "Mat33.apply_left/2 (vec2)" => fn -> Mat33.apply_left(vec3,mat33_a) end,
    "Mat33.apply_left_transpose/2 (vec2)" => fn -> Mat33.apply_left_transpose(vec3,mat33_a) end,
    "Mat33.transform_point/2" => fn -> Mat33.transform_point(mat33_a, vec2) end,
    "Mat33.transform_vector/2" => fn -> Mat33.transform_vector(mat33_a, vec2) end,

    # Rotation matrices
    "Mat33.make_rotate/1" => fn -> Mat33.make_rotate(angle) end,

    # Scale matrices
    "Mat33.make_scale/1 (uniform)" => fn -> Mat33.make_scale(2.0) end,
    "Mat33.make_scale/2" => fn -> Mat33.make_scale(1.0, 2.0, 3.0) end,

    # Translation matrices
    "Mat33.make_translate/2" => fn -> Mat33.make_translate(5.0, 10.0) end,

    # Component access
    "Mat33.at/3" => fn -> Mat33.at(mat33_a, 1, 1) end,
    "Mat33.row0/1" => fn -> Mat33.row0(mat33_a) end,
    "Mat33.row1/1" => fn -> Mat33.row1(mat33_a) end,
    "Mat33.row2/1" => fn -> Mat33.row2(mat33_a) end,
    "Mat33.column0/1" => fn -> Mat33.column0(mat33_a) end,
    "Mat33.column1/1" => fn -> Mat33.column1(mat33_a) end,
    "Mat33.column2/1" => fn -> Mat33.column2(mat33_a) end,
    "Mat33.diag/1" => fn -> Mat33.diag(mat33_a) end,

    # Round-trip operations
    "Mat33 rotate->inverse" => fn ->
      m = Mat33.make_rotate(angle)
      Mat33.inverse(m)
    end,

    # Batch operation (chain multiply 10 matrices)
    "Mat33 batch multiply (10 matrices)" => fn ->
      Enum.reduce(mat33_list, Mat33.identity(), &Mat33.multiply/2)
    end
  },
  warmup: 2,
  time: 5,
  memory_time: 2,
  formatters: [
    Benchee.Formatters.Console,
    {Benchee.Formatters.Markdown, file: "bench/results/mat33_results.md"}
  ]
)
