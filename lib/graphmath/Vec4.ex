defmodule Graphmath.Vec4 do
  @moduledoc """
  Four-dimensional vectors stored as `{x, y, z, w}` tuples of floats.

  Arithmetic, lengths, normalization, and comparisons use all four components.
  Integer and mixed numeric inputs are accepted and arithmetic results are floats.
  The float-specialized clauses expose types to the VM for arithmetic optimization.

  For homogeneous 3D coordinates, `from_point3/1` sets `w = 1.0` and
  `from_direction3/1` sets `w = 0.0`. Thus affine translation moves points
  and leaves directions unchanged. Use `Graphmath.Mat44.apply_left/2` for
  the library's row-vector graphics convention; `Graphmath.Mat44.apply/2`
  computes the column-vector product instead.

  `normalize/1` computes a unit vector in four dimensions. It does not divide
  by the homogeneous coordinate to recover a Cartesian point.
  """

  @type vec4 :: {float, float, float, float}
  @type vec3 :: {float, float, float}

  @doc """
  Returns the zero vector `{0.0, 0.0, 0.0, 0.0}`.

  Use `from_point3({0.0, 0.0, 0.0})` for the homogeneous 3D origin.
  """
  @spec create() :: vec4
  def create(), do: {0.0, 0.0, 0.0, 0.0}

  @doc """
  Creates a vector from four components, converting numeric inputs to floats.
  """
  @spec create(float, float, float, float) :: vec4
  def create(x, y, z, w)
      when is_float(x) and is_float(y) and is_float(z) and is_float(w) do
    {x, y, z, w}
  end

  def create(x, y, z, w) do
    {1.0 * x, 1.0 * y, 1.0 * z, 1.0 * w}
  end

  @doc """
  Creates a vector from the first four list entries, converting them to floats.
  Extra entries are ignored; fewer than four entries raise `FunctionClauseError`.
  """
  @spec create([float]) :: vec4
  def create([x, y, z, w | _])
      when is_float(x) and is_float(y) and is_float(z) and is_float(w) do
    {x, y, z, w}
  end

  def create([x, y, z, w | _]) do
    {1.0 * x, 1.0 * y, 1.0 * z, 1.0 * w}
  end

  @doc """
  Embeds a 3D point as `{x, y, z, 1.0}`, converting entries to floats.

  ## Examples

      iex> Graphmath.Vec4.from_point3({2, -3, 4})
      {2.0, -3.0, 4.0, 1.0}
  """
  @spec from_point3(vec3) :: vec4
  def from_point3({x, y, z})
      when is_float(x) and is_float(y) and is_float(z) do
    {x, y, z, 1.0}
  end

  def from_point3({x, y, z}) do
    {1.0 * x, 1.0 * y, 1.0 * z, 1.0}
  end

  @doc """
  Embeds a 3D direction as `{x, y, z, 0.0}`, converting entries to floats.

  ## Examples

      iex> Graphmath.Vec4.from_direction3({2, -3, 4})
      {2.0, -3.0, 4.0, 0.0}
  """
  @spec from_direction3(vec3) :: vec4
  def from_direction3({x, y, z})
      when is_float(x) and is_float(y) and is_float(z) do
    {x, y, z, 0.0}
  end

  def from_direction3({x, y, z}) do
    {1.0 * x, 1.0 * y, 1.0 * z, 0.0}
  end

  @doc """
  Adds corresponding components.
  """
  @spec add(vec4, vec4) :: vec4
  def add({x, y, z, w}, {u, v, s, t})
      when is_float(x) and is_float(y) and is_float(z) and is_float(w) and is_float(u) and
             is_float(v) and is_float(s) and is_float(t) do
    {x + u, y + v, z + s, w + t}
  end

  def add({x, y, z, w}, {u, v, s, t}) do
    {1.0 * x + u, 1.0 * y + v, 1.0 * z + s, 1.0 * w + t}
  end

  @doc """
  Subtracts corresponding components of `b` from `a`.
  """
  @spec subtract(vec4, vec4) :: vec4
  def subtract({x, y, z, w}, {u, v, s, t})
      when is_float(x) and is_float(y) and is_float(z) and is_float(w) and is_float(u) and
             is_float(v) and is_float(s) and is_float(t) do
    {x - u, y - v, z - s, w - t}
  end

  def subtract({x, y, z, w}, {u, v, s, t}) do
    {1.0 * x - u, 1.0 * y - v, 1.0 * z - s, 1.0 * w - t}
  end

  @doc """
  Multiplies corresponding components.
  """
  @spec multiply(vec4, vec4) :: vec4
  def multiply({x, y, z, w}, {u, v, s, t})
      when is_float(x) and is_float(y) and is_float(z) and is_float(w) and is_float(u) and
             is_float(v) and is_float(s) and is_float(t) do
    {x * u, y * v, z * s, w * t}
  end

  def multiply({x, y, z, w}, {u, v, s, t}) do
    {1.0 * x * u, 1.0 * y * v, 1.0 * z * s, 1.0 * w * t}
  end

  @doc """
  Multiplies all four components by `k`, including the homogeneous coordinate.
  """
  @spec scale(vec4, float) :: vec4
  def scale({x, y, z, w}, k)
      when is_float(x) and is_float(y) and is_float(z) and is_float(w) and is_float(k) do
    {x * k, y * k, z * k, w * k}
  end

  def scale({x, y, z, w}, k) do
    {1.0 * x * k, 1.0 * y * k, 1.0 * z * k, 1.0 * w * k}
  end

  @doc """
  Returns the four-dimensional dot product.
  """
  @spec dot(vec4, vec4) :: float
  def dot({x, y, z, w}, {u, v, s, t})
      when is_float(x) and is_float(y) and is_float(z) and is_float(w) and is_float(u) and
             is_float(v) and is_float(s) and is_float(t) do
    x * u + y * v + z * s + w * t
  end

  def dot({x, y, z, w}, {u, v, s, t}) do
    1.0 * x * u + y * v + z * s + w * t
  end

  @doc """
  Returns the Euclidean length, including the fourth component.
  """
  @spec length(vec4) :: float
  def length({x, y, z, w})
      when is_float(x) and is_float(y) and is_float(z) and is_float(w) do
    :math.sqrt(x * x + y * y + z * z + w * w)
  end

  def length({x, y, z, w}) do
    :math.sqrt(x * x + y * y + z * z + w * w)
  end

  @doc """
  Returns the squared Euclidean length.
  """
  @spec length_squared(vec4) :: float
  def length_squared({x, y, z, w})
      when is_float(x) and is_float(y) and is_float(z) and is_float(w) do
    x * x + y * y + z * z + w * w
  end

  def length_squared({x, y, z, w}) do
    1.0 * x * x + y * y + z * z + w * w
  end

  @doc """
  Returns the sum of the absolute values of all four components.
  """
  @spec length_manhattan(vec4) :: float
  def length_manhattan({x, y, z, w})
      when is_float(x) and is_float(y) and is_float(z) and is_float(w) do
    abs(x) + abs(y) + abs(z) + abs(w)
  end

  def length_manhattan({x, y, z, w}) do
    1.0 * abs(x) + abs(y) + abs(z) + abs(w)
  end

  @doc """
  Returns a unit vector in the same four-dimensional direction.
  Raises `ArithmeticError` for the zero vector.
  """
  @spec normalize(vec4) :: vec4
  def normalize({x, y, z, w})
      when is_float(x) and is_float(y) and is_float(z) and is_float(w) do
    inv_length = 1.0 / :math.sqrt(x * x + y * y + z * z + w * w)
    {x * inv_length, y * inv_length, z * inv_length, w * inv_length}
  end

  def normalize({x, y, z, w}) do
    inv_length = 1.0 / :math.sqrt(x * x + y * y + z * z + w * w)
    {x * inv_length, y * inv_length, z * inv_length, w * inv_length}
  end

  @doc """
  Linearly interpolates all four components: `(1 - alpha) * a + alpha * b`.
  Use `alpha` from 0.0 through 1.0 to interpolate between the endpoints.
  """
  @spec lerp(vec4, vec4, float) :: vec4
  def lerp({x, y, z, w}, {u, v, s, t}, alpha)
      when is_float(x) and is_float(y) and is_float(z) and is_float(w) and is_float(u) and
             is_float(v) and is_float(s) and is_float(t) and is_float(alpha) do
    {(1.0 - alpha) * x + alpha * u, (1.0 - alpha) * y + alpha * v, (1.0 - alpha) * z + alpha * s,
     (1.0 - alpha) * w + alpha * t}
  end

  def lerp({x, y, z, w}, {u, v, s, t}, alpha) do
    {(1.0 - alpha) * x + alpha * u, (1.0 - alpha) * y + alpha * v, (1.0 - alpha) * z + alpha * s,
     (1.0 - alpha) * w + alpha * t}
  end

  @doc """
  Tests exact numeric equality of all four components.
  """
  @spec equal(vec4, vec4) :: boolean
  def equal({x, y, z, w}, {u, v, s, t})
      when is_float(x) and is_float(y) and is_float(z) and is_float(w) and is_float(u) and
             is_float(v) and is_float(s) and is_float(t) do
    x == u and y == v and z == s and w == t
  end

  def equal({x, y, z, w}, {u, v, s, t}) do
    x == u and y == v and z == s and w == t
  end

  @doc """
  Tests whether each component differs by at most `eps` (inclusive).
  """
  @spec equal(vec4, vec4, float) :: boolean
  def equal({x, y, z, w}, {u, v, s, t}, eps)
      when is_float(x) and is_float(y) and is_float(z) and is_float(w) and is_float(u) and
             is_float(v) and is_float(s) and is_float(t) and is_float(eps) do
    abs(x - u) <= eps and abs(y - v) <= eps and abs(z - s) <= eps and abs(w - t) <= eps
  end

  def equal({x, y, z, w}, {u, v, s, t}, eps) do
    abs(x - u) <= eps and abs(y - v) <= eps and abs(z - s) <= eps and abs(w - t) <= eps
  end

  @doc """
  Tests whether the Euclidean distance is strictly less than `distance`.
  Points exactly on the distance boundary return false.
  """
  @spec near(vec4, vec4, float) :: boolean
  def near({x, y, z, w}, {u, v, s, t}, distance)
      when is_float(x) and is_float(y) and is_float(z) and is_float(w) and is_float(u) and
             is_float(v) and is_float(s) and is_float(t) and is_float(distance) do
    dx = x - u
    dy = y - v
    dz = z - s
    dw = w - t
    distance > :math.sqrt(dx * dx + dy * dy + dz * dz + dw * dw)
  end

  def near({x, y, z, w}, {u, v, s, t}, distance) do
    dx = x - u
    dy = y - v
    dz = z - s
    dw = w - t
    distance > :math.sqrt(dx * dx + dy * dy + dz * dz + dw * dw)
  end

  @doc """
  Negates all four components.
  """
  @spec negate(vec4) :: vec4
  def negate({x, y, z, w})
      when is_float(x) and is_float(y) and is_float(z) and is_float(w) do
    {-x, -y, -z, -w}
  end

  def negate({x, y, z, w}) do
    {-1.0 * x, -1.0 * y, -1.0 * z, -1.0 * w}
  end

  @doc """
  Returns `a * v1 + b * v2`, using all four components.
  """
  @spec weighted_sum(float, vec4, float, vec4) :: vec4
  def weighted_sum(a, {x, y, z, w}, b, {u, v, s, t})
      when is_float(a) and is_float(x) and is_float(y) and is_float(z) and is_float(w) and
             is_float(b) and is_float(u) and is_float(v) and is_float(s) and is_float(t) do
    {a * x + b * u, a * y + b * v, a * z + b * s, a * w + b * t}
  end

  def weighted_sum(a, {x, y, z, w}, b, {u, v, s, t}) do
    {1.0 * a * x + b * u, 1.0 * a * y + b * v, 1.0 * a * z + b * s, 1.0 * a * w + b * t}
  end

  @doc """
  Projects `a` onto `b` in four dimensions.
  Raises `ArithmeticError` when the target `b` is zero.
  """
  @spec project(vec4, vec4) :: vec4
  def project({x, y, z, w}, {u, v, s, t})
      when is_float(x) and is_float(y) and is_float(z) and is_float(w) and is_float(u) and
             is_float(v) and is_float(s) and is_float(t) do
    coefficient = (x * u + y * v + z * s + w * t) / (u * u + v * v + s * s + t * t)
    {coefficient * u, coefficient * v, coefficient * s, coefficient * t}
  end

  def project({x, y, z, w}, {u, v, s, t}) do
    coefficient = (x * u + y * v + z * s + w * t) / (u * u + v * v + s * s + t * t)
    {coefficient * u, coefficient * v, coefficient * s, coefficient * t}
  end

  @doc """
  Returns the Lp norm using all four components.
  `order` should be at least 1.0; order zero raises `ArithmeticError`.
  """
  @spec p_norm(vec4, float) :: float
  def p_norm({x, y, z, w}, order)
      when is_float(x) and is_float(y) and is_float(z) and is_float(w) and is_float(order) do
    sum =
      :math.pow(abs(x), order) + :math.pow(abs(y), order) +
        :math.pow(abs(z), order) + :math.pow(abs(w), order)

    :math.pow(sum, 1.0 / order)
  end

  def p_norm({x, y, z, w}, order) do
    sum =
      :math.pow(abs(x), order) + :math.pow(abs(y), order) +
        :math.pow(abs(z), order) + :math.pow(abs(w), order)

    :math.pow(sum, 1.0 / order)
  end

  @doc """
  Returns the Minkowski distance using all four components.
  `order` should be at least 1.0; order zero raises `ArithmeticError`.
  """
  @spec minkowski_distance(vec4, vec4, float) :: float
  def minkowski_distance({x, y, z, w}, {u, v, s, t}, order)
      when is_float(x) and is_float(y) and is_float(z) and is_float(w) and is_float(u) and
             is_float(v) and is_float(s) and is_float(t) and is_float(order) do
    sum =
      :math.pow(abs(x - u), order) + :math.pow(abs(y - v), order) +
        :math.pow(abs(z - s), order) + :math.pow(abs(w - t), order)

    :math.pow(sum, 1.0 / order)
  end

  def minkowski_distance({x, y, z, w}, {u, v, s, t}, order) do
    sum =
      :math.pow(abs(x - u), order) + :math.pow(abs(y - v), order) +
        :math.pow(abs(z - s), order) + :math.pow(abs(w - t), order)

    :math.pow(sum, 1.0 / order)
  end

  @doc """
  Returns the largest absolute difference between corresponding components.
  """
  @spec chebyshev_distance(vec4, vec4) :: float
  def chebyshev_distance({x, y, z, w}, {u, v, s, t})
      when is_float(x) and is_float(y) and is_float(z) and is_float(w) and is_float(u) and
             is_float(v) and is_float(s) and is_float(t) do
    max(max(abs(x - u), abs(y - v)), max(abs(z - s), abs(w - t)))
  end

  def chebyshev_distance({x, y, z, w}, {u, v, s, t}) do
    1.0 * max(max(abs(x - u), abs(y - v)), max(abs(z - s), abs(w - t)))
  end
end
