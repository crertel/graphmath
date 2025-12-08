alias Graphmath.Vec3

# Test data setup
vec3_a = {1.5, 2.5, 3.5}
vec3_b = {3.0, 4.0, 5.0}
vec3_c = {0.5, 1.0, 1.5}
vec3_list = for _ <- 1..100, do: {Enum.random(1..1000) / 1.0, Enum.random(1..1000) / 1.0, Enum.random(1..1000) / 1.0}
scalar = 2.5
axis = Vec3.normalize({0.0, 1.0, 0.0})
angle = :math.pi() / 4

Benchee.run(
  %{
    # Baseline
    "Baseline" => fn -> {1,2,3} end,

    # Creation
    "Vec3.create/0" => fn -> Vec3.create() end,
    "Vec3.create/3" => fn -> Vec3.create(1.5, 2.5, 3.5) end,

    # Basic arithmetic
    "Vec3.add/2" => fn -> Vec3.add(vec3_a, vec3_b) end,
    "Vec3.subtract/2" => fn -> Vec3.subtract(vec3_a, vec3_b) end,
    "Vec3.multiply/2" => fn -> Vec3.multiply(vec3_a, vec3_b) end,
    "Vec3.scale/2" => fn -> Vec3.scale(vec3_a, scalar) end,

    # Products
    "Vec3.dot/2" => fn -> Vec3.dot(vec3_a, vec3_b) end,
    "Vec3.cross/2" => fn -> Vec3.cross(vec3_a, vec3_b) end,
    "Vec3.scalar_triple/3" => fn -> Vec3.scalar_triple(vec3_a, vec3_b, vec3_c) end,

    # Length operations
    "Vec3.length/1" => fn -> Vec3.length(vec3_a) end,
    "Vec3.length_squared/1" => fn -> Vec3.length_squared(vec3_a) end,
    "Vec3.length_manhattan/1" => fn -> Vec3.length_manhattan(vec3_a) end,
    "Vec3.normalize/1" => fn -> Vec3.normalize(vec3_a) end,

    # Distance operations
    "Vec3.minkowski_distance/3" => fn -> Vec3.minkowski_distance(vec3_a, vec3_b, 2) end,
    "Vec3.chebyshev_distance/2" => fn -> Vec3.chebyshev_distance(vec3_a, vec3_b) end,

    # Interpolation
    "Vec3.lerp/3" => fn -> Vec3.lerp(vec3_a, vec3_b, 0.5) end,

    # Rotation (Rodrigues' formula)
    "Vec3.rotate/3" => fn -> Vec3.rotate(vec3_a, axis, angle) end,

    # Comparison
    "Vec3.equal/2" => fn -> Vec3.equal(vec3_a, vec3_b) end,
    "Vec3.equal/3 (epsilon)" => fn -> Vec3.equal(vec3_a, vec3_b, 0.001) end,
    "Vec3.near/3" => fn -> Vec3.near(vec3_a, vec3_b, 0.001) end,

    # Random generation
    "Vec3.random_sphere/0" => fn -> Vec3.random_sphere() end,
    "Vec3.random_ball/0" => fn -> Vec3.random_ball() end,
    "Vec3.random_box/0" => fn -> Vec3.random_box() end,

    # Batch operation (sum of list)
    "Vec3 batch add (100 vectors)" => fn ->
      Enum.reduce(vec3_list, {0.0, 0.0, 0.0}, &Vec3.add/2)
    end
  },
  warmup: 2,
  time: 5,
  memory_time: 2,
  formatters: [
    Benchee.Formatters.Console,
    {Benchee.Formatters.Markdown, file: "bench/results/vec3_results.md"}
  ]
)
