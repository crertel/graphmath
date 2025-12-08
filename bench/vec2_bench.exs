alias Graphmath.Vec2

# Test data setup
vec2_a = {1.5, 2.5}
vec2_b = {3.0, 4.0}
vec2_list = for _ <- 1..100, do: {Enum.random(1..1000) / 1.0, Enum.random(1..1000) / 1.0}
scalar = 2.5
angle = :math.pi() / 4

Benchee.run(
  %{
    # Invocation reference
    "Baseline/0" => fn -> {1,2} end,

    # Creation
    "Vec2.create/0" => fn -> Vec2.create() end,
    "Vec2.create/2" => fn -> Vec2.create(1.5, 2.5) end,

    # Basic arithmetic
    "Vec2.add/2" => fn -> Vec2.add(vec2_a, vec2_b) end,
    "Vec2.subtract/2" => fn -> Vec2.subtract(vec2_a, vec2_b) end,
    "Vec2.multiply/2" => fn -> Vec2.multiply(vec2_a, vec2_b) end,
    "Vec2.scale/2" => fn -> Vec2.scale(vec2_a, scalar) end,

    # Products
    "Vec2.dot/2" => fn -> Vec2.dot(vec2_a, vec2_b) end,
    "Vec2.perp_prod/2" => fn -> Vec2.perp_prod(vec2_a, vec2_b) end,

    # Length operations
    "Vec2.length/1" => fn -> Vec2.length(vec2_a) end,
    "Vec2.length_squared/1" => fn -> Vec2.length_squared(vec2_a) end,
    "Vec2.length_manhattan/1" => fn -> Vec2.length_manhattan(vec2_a) end,
    "Vec2.normalize/1" => fn -> Vec2.normalize(vec2_a) end,
    "Vec2.p_norm/2" => fn -> Vec2.p_norm(vec2_a, 1) end,

    # Distance operations
    "Vec2.chebyshev_distance/2" => fn -> Vec2.chebyshev_distance(vec2_a, vec2_b) end,
    "Vec2.minkowski_distance/2" => fn -> Vec2.minkowski_distance(vec2_a, vec2_b, 2) end,

    # Interpolation
    "Vec2.lerp/3" => fn -> Vec2.lerp(vec2_a, vec2_b, 0.5) end,

    # Rotation
    "Vec2.rotate/2" => fn -> Vec2.rotate(vec2_a, angle) end,

    # Comparison
    "Vec2.equal/2" => fn -> Vec2.equal(vec2_a, vec2_b) end,
    "Vec2.equal/3 (epsilon)" => fn -> Vec2.equal(vec2_a, vec2_b, 0.001) end,
    "Vec2.near/3" => fn -> Vec2.near(vec2_a, vec2_b, 0.001) end,

    # Projection/Reflection
    "Vec2.project/2" => fn -> Vec2.project(vec2_a, vec2_b) end,

    # Perpendicular
    "Vec2.perp/1" => fn -> Vec2.perp(vec2_a) end,

    # Random generation
    "Vec2.random_circle/0" => fn -> Vec2.random_circle() end,
    "Vec2.random_disc/0" => fn -> Vec2.random_disc() end,
    "Vec2.random_box/0" => fn -> Vec2.random_box() end,

    # Batch operation (sum of list)
    "Vec2 batch add (100 vectors)" => fn ->
      Enum.reduce(vec2_list, {0.0, 0.0}, &Vec2.add/2)
    end
  },
  warmup: 2,
  time: 5,
  memory_time: 2,
  formatters: [
    Benchee.Formatters.Console,
    {Benchee.Formatters.Markdown, file: "bench/results/vec2_results.md"}
  ]
)
