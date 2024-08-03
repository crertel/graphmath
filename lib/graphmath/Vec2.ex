defmodule Graphmath.Vec2 do
  @moduledoc """
  This is the 2D mathematics.

  This submodule handles vectors stored as tuples of floats ex: `{1.0, 2.0}`.
  """

  @type vec2 :: {float, float}

  @doc """
  `create()` creates a zero vec2.

  It will return a tuple of the form {0.0,0.0}.
  `create()` creates a zeroed `vec2`.

  It takes no arguments.

  It returns a `vec2` of the form `{ 0.0, 0.0 }`.
  """
  @spec create() :: vec2
  def create(), do: {0.0, 0.0}

  @doc """
  `create(x,y)` creates a `vec2` of value (x,y).

  `x` is the first element of the `vec3` to be created.

  `y` is the second element of the `vec3` to be created.

  It returns a `vec2` of the form `{x,y}`.
  """
  @spec create(float, float) :: vec2
  def create(x, y) when is_float(x) and is_float(y), do: {x, y}
  def create(x, y), do: {1.0 * x, 1.0 * y}

  @doc """
  `create(vec)` creates a `vec2` from a list of 2 or more floats.

  `vec` is a list of 2 or more floats.

  It returns a `vec2` of the form `{x,y}`, where `x` and `y` are the first three elements in `vec`.
  """
  @spec create([float]) :: vec2
  def create([x, y | _]) when is_float(x) and is_float(y), do: {x, y}
  def create([x, y | _]), do: {1.0 * x, 1.0 * y}

  @doc """
  `add( a, b)` adds a vec2 (a) to a vec2 (b).

  It returns a tuple of the form { ax + bx, ay + by }.

  `add( a, b )` adds two `vec2`s.

  `a` is the first `vec2`.

  `b` is the second `vec2`.

  It returns a `vec2` of the form { a<sub>x</sub> + b<sub>x</sub>, a<sub>y</sub> + b<sub>y</sub> }.
  """
  @spec add(vec2, vec2) :: vec2
  def add({x, y}, {u, v}) when is_float(x) and is_float(y) and is_float(u) and is_float(v),
    do: {x + u, y + v}

  def add({x, y}, {u, v}), do: {1.0 * x + u, 1.0 * y + v}

  @doc """
  `subtract(a, b )` subtracts one `vec2` from another `vec2`.

  `a` is the `vec2` minuend.

  `b` is the `vec2` subtrahend.

  It returns a `vec2` of the form { a<sub>x</sub> - b<sub>x</sub>, a<sub>y</sub> - b<sub>y</sub> }.

  (the terminology was found [here](http://mathforum.org/library/drmath/view/58801.html)).
  """
  @spec subtract(vec2, vec2) :: vec2
  def subtract({x, y}, {u, v}) when is_float(x) and is_float(y) and is_float(u) and is_float(v),
    do: {x - u, y - v}

  def subtract({x, y}, {u, v}), do: {1.0 * x - u, 1.0 * y - v}

  @doc """
  `multiply( a, b)` mulitplies element-wise a vec2 (a) by a vec2 (b).

  It returns a tuple of the form `{ ax*bx, ay*by }`.

  `multiply( a, b )` multiplies element-wise a `vec2` by another `vec2`.

  `a` is the `vec2` multiplicand.

  `b` is the `vec2` multiplier.

  It returns a `vec2` of the form { a<sub>x</sub>b<sub>x</sub>, a<sub>y</sub>b<sub>y</sub> }.
  """
  @spec multiply(vec2, vec2) :: vec2
  def multiply({x, y}, {u, v}) when is_float(x) and is_float(y) and is_float(u) and is_float(v),
    do: {x * u, y * v}

  def multiply({x, y}, {u, v}), do: {1.0 * x * u, 1.0 * y * v}

  @doc """
  `scale( a, scale )` uniformly scales a `vec2`.

  `a` is the `vec2` to be scaled.

  `scale` is the float to scale each element of `a` by.

  It returns a tuple of the form { a<sub>x</sub>scale, a<sub>y</sub>scale }.
  """
  @spec scale(vec2, float) :: vec2
  def scale({x, y}, scale) when is_float(x) and is_float(y) and is_float(scale),
    do: {x * scale, y * scale}

  def scale({x, y}, scale), do: {1.0 * x * scale, 1.0 * y * scale}

  @doc """
  `dot( a, b )` finds the dot (inner) product of one `vec2` with another `vec2`.

  `a` is the first `vec2`.

  `b` is the second `vec2`.

  It returns a float of the value (a<sub>x</sub>b<sub>x</sub> + a<sub>y</sub>b<sub>y</sub> ).
  """
  @spec dot(vec2, vec2) :: float
  def dot({x, y}, {u, v}) when is_float(x) and is_float(y) and is_float(u) and is_float(v),
    do: x * u + y * v

  def dot({x, y}, {u, v}), do: 1.0 * x * u + y * v

  @doc """
  `perp_prod( a, b )` finds the perpindicular product of one `vec2` with another `vec2`.

  `a` is the first `vec2`.

  `b` is the second `vec2`.

  The perpindicular product is the magnitude of the cross-product between the two vectors.

  It returns a float of the value (a<sub>x</sub>b<sub>y</sub> - b<sub>x</sub>a<sub>y</sub>).
  """
  @spec perp_prod(vec2, vec2) :: float
  def perp_prod({x, y}, {u, v}) when is_float(x) and is_float(y) and is_float(u) and is_float(v),
    do: x * v - u * y

  def perp_prod({x, y}, {u, v}), do: 1.0 * x * v - u * y

  @doc """
  `length(a)` finds the length (Eucldiean or L2 norm) of a `vec2`.

  `a` is the `vec2` to find the length of.

  It returns a float of the value (sqrt( a<sub>x</sub><sup>2</sup> + a<sub>y</sub><sup>2</sup>)).
  """
  @spec length(vec2) :: float
  def length({x, y}) when is_float(x) and is_float(y), do: :math.sqrt(x * x + y * y)
  def length({x, y}), do: :math.sqrt(x * x + y * y)

  @doc """
  `length_squared(a)` finds the square of the length of a vec2 (a).

  In many cases, this is sufficient for comparisions and avaoids a sqrt.

  It returns a float of the value (ax*ax + ay*ay).
  `length_squared(a)` finds the square of the length of a `vec2`.

  `a` is the `vec2` to find the length squared of.

  It returns a float of the value a<sub>x</sub><sup>2</sup> + a<sub>y</sub><sup>2</sup>.

  In many cases, this is sufficient for comparisons and avoids a square root.
  """
  @spec length_squared(vec2) :: float
  def length_squared({x, y}) when is_float(x) and is_float(y), do: x * x + y * y
  def length_squared({x, y}), do: 1.0 * x * x + y * y

  @doc """
  `length_manhattan(a)` finds the Manhattan (L1 norm) length of a `vec2`.

  `a` is the `vec2` to find the Manhattan length of.

  It returns a float of the value (a<sub>x</sub> + a<sub>y</sub>).

  The Manhattan length is the sum of the components.
  """
  @spec length_manhattan(vec2) :: float
  def length_manhattan({x, y}) when is_float(x) and is_float(y), do: x + y
  def length_manhattan({x, y}), do: 1.0 * x + y

  @doc """
  `normalize(a)` finds the unit vector with the same direction as a `vec2`.

  `a` is the `vec2` to be normalized.

  It returns a `vec2` of the form `{normx, normy}`.

  This is done by dividing each component by the vector's magnitude.
  """
  @spec normalize(vec2) :: vec2
  def normalize({x, y}) when is_float(x) and is_float(y) do
    invmag = 1.0 / :math.sqrt(x * x + y * y)
    {x * invmag, y * invmag}
  end

  def normalize({x, y}) do
    invmag = 1.0 / :math.sqrt(x * x + y * y)
    {1.0 * x * invmag, 1.0 * y * invmag}
  end

  @doc """
  `lerp(a,b,t)` is used to linearly interpolate between two given vectors a and b along an interpolant t.

  The interpolant `t`  is on the domain [0,1]. Behavior outside of that is undefined.
  `lerp(a,b,t)` linearly interpolates between one `vec2` and another `vec2` along an interpolant.

  `a` is the starting `vec2`.

  `b` is the ending `vec2`.

  `t` is the interpolant float, on the domain [0,1].

  It returns a `vec2` of the form (1-t)**a** - (t)**b**.

  The interpolant `t` is on the domain [0,1]. Behavior outside of that is undefined.
  """
  @spec lerp(vec2, vec2, float) :: vec2
  def lerp({x, y}, {u, v}, t)
      when is_float(x) and is_float(y) and is_float(u) and is_float(v) and is_float(t),
      do: {t * u + (1.0 - t) * x, t * v + (1.0 - t) * y}

  def lerp({x, y}, {u, v}, t), do: {t * u + (1.0 - t) * x, t * v + (1.0 - t) * y}

  @doc """
  `rotate(a,theta)` rotates a `vec2` CCW about the +Z axis.

  `a` is the `vec2` to rotate.

  `theta` is the number of radians to rotate by as a float.

  This returns a `vec2`.
  """
  @spec rotate(vec2, float) :: vec2
  def rotate({x, y}, theta) when is_float(x) and is_float(y) and is_float(theta) do
    ct = :math.cos(theta)
    st = :math.sin(theta)
    {x * ct - y * st, x * st + y * ct}
  end

  def rotate({x, y}, theta) do
    ct = :math.cos(theta)
    st = :math.sin(theta)
    {1.0 * x * ct - y * st, 1.0 * x * st + y * ct}
  end

  @doc """
  `near(a,b, distance)` checks whether two `vec2`s are within a certain distance of each other.

  `a` is the first `vec2`.

  `b` is the second `vec2`.

  `distance` is the distance between them as a float.
  """
  @spec near(vec2, vec2, float) :: boolean
  def near({x, y}, {u, v}, distance)
      when is_float(x) and is_float(y) and is_float(u) and is_float(v) and is_float(distance) do
    dx = x - u
    dy = y - v
    distance > :math.sqrt(dx * dx + dy * dy)
  end

  def near({x, y}, {u, v}, distance) do
    dx = x - u
    dy = y - v
    distance > :math.sqrt(dx * dx + dy * dy)
  end

  @doc """
  `project(a,b)` projects one `vec2` onto another `vec2`.

  `a` is the first `vec2`.

  `b` is the second `vec2`.

  This returns a `vec2` representing the image of `a` in the direction of `b`.
  """
  @spec project(vec2, vec2) :: vec2
  def project({x, y}, {u, v}) when is_float(x) and is_float(y) and is_float(u) and is_float(v) do
    coeff = (x * u + y * v) / (u * u + v * v)
    {u * coeff, v * coeff}
  end

  def project({x, y}, {u, v}) do
    coeff = (x * u + y * v) / (u * u + v * v)
    {u * coeff, v * coeff}
  end

  @doc """
  `perp(a)` creates a vector perpendicular to another vector `a`.

  `a` is the `vec2` to be perpindicular to.

  This returns a `vec2` perpindicular to `a`, to the right of the original `a`.
  """
  @spec perp(vec2) :: vec2
  def perp({x, y}) when is_float(x) and is_float(y), do: {-1.0 * y, 1.0 * x}
  def perp({x, y}), do: {-1.0 * y, 1.0 * x}

  @doc """
  `equal(a, b)` checks to see if two vec2s a and b are equivalent.

  `a` is the `vec2`.

  `b` is the `vec2`.

  It returns true if the vectors have equal elements.

  Note that due to precision issues, you may want to use `equal/3` instead.
  """
  @spec equal(vec2, vec2) :: boolean
  def equal({ax, ay}, {bx, by})
      when is_float(ax) and is_float(ay) and is_float(bx) and is_float(by),
      do: ax == bx and ay == by

  def equal({ax, ay}, {bx, by}), do: ax == bx and ay == by

  @doc """
  `equal(a, b, eps)` checks to see if two vec2s a and b are equivalent within some tolerance.

  `a` is the `vec2`.

  `b` is the `vec2`.

  `eps` is the tolerance, a float.

  It returns true if the vectors have equal elements within some tolerance.
  """
  @spec equal(vec2, vec2, float) :: boolean
  def equal({ax, ay}, {bx, by}, eps)
      when is_float(ax) and is_float(ay) and is_float(bx) and is_float(by) and is_float(eps),
      do:
        abs(ax - bx) <= eps and
          abs(ay - by) <= eps

  def equal({ax, ay}, {bx, by}, eps),
    do:
      abs(ax - bx) <= eps and
        abs(ay - by) <= eps

  @doc """
  `random_circle()` generates a point on the unit circle.

  It returns a vec2 with distance 1 from the origin.
  """
  @spec random_circle() :: vec2
  def random_circle() do
    pi = :math.pi()
    theta = :rand.uniform()
    {:math.cos(2.0 * pi * theta), :math.sin(2.0 * pi * theta)}
  end

  @doc """
  `random_disc()` generates a point on or inside the unit circle using the method [here](http://mathworld.wolfram.com/DiskPointPicking.html).

  It returns a vec2 with distance 1 from the origin.
  """
  @spec random_disc() :: vec2
  def random_disc() do
    pi = :math.pi()
    theta = :rand.uniform()
    rho = :math.sqrt(:rand.uniform())
    {rho * :math.cos(2.0 * pi * theta), rho * :math.sin(2.0 * pi * theta)}
  end

  @doc """
  `random_box()` generates a point on or inside the unit box [0,1]x[0,1].
  """
  @spec random_box() :: vec2
  def random_box(), do: {:rand.uniform(), :rand.uniform()}

  @doc """
  `negate(v)` creates a vector whose elements are opposite in sign to `v`.
  """
  @spec negate(vec2) :: vec2
  def negate({x, y}) when is_float(x) and is_float(y), do: {-1.0 * x, -1.0 * y}
  def negate({x, y}), do: {-1.0 * x, -1.0 * y}

  @doc """
  `weighted_sum(a, v1, b, v2)` returns the sum of vectors `v1` and `v2` having been scaled by `a` and `b`, respectively.
  """
  @spec weighted_sum(number, vec2, number, vec2) :: vec2
  def weighted_sum(a, {x, y}, b, {u, v})
      when is_float(a) and is_float(x) and is_float(y) and
             is_float(b) and is_float(u) and is_float(v),
      do: {a * x + b * u, a * y + b * v}

  def weighted_sum(a, {x, y}, b, {u, v}), do: {1.0 * a * x + b * u, 1.0 * a * y + b * v}

  @doc """
  `minkowski_distance(a,b,order)` returns the [Minkowski distance](https://en.wikipedia.org/wiki/Minkowski_distance) between two points `a` and `b` of order `order`.

  Order 1 is equivalent to manhattan distance, 2 to Euclidean distance, otherwise all bets are off.
  """
  @spec minkowski_distance(vec2, vec2, number) :: number
  def minkowski_distance({x1, y1}, {x2, y2}, order)
      when is_float(x1) and is_float(y1) and is_float(x2) and is_float(y2) and is_float(order) do
    adx = abs(x2 - x1)
    ady = abs(y2 - y1)
    temp = :math.pow(adx, order) + :math.pow(ady, order)
    :math.pow(temp, 1.0 / order)
  end

  def minkowski_distance({x1, y1}, {x2, y2}, order) do
    adx = abs(x2 - x1)
    ady = abs(y2 - y1)
    temp = :math.pow(adx, order) + :math.pow(ady, order)
    :math.pow(temp, 1.0 / order)
  end

  @doc """
  `chebyshev_distance(a,b)` returns the [Chebyshev distance](https://en.wikipedia.org/wiki/Chebyshev_distance) between two points `a` and `b`.
  """
  @spec chebyshev_distance(vec2, vec2) :: number
  def chebyshev_distance({x1, y1}, {x2, y2})
      when is_float(x1) and is_float(y1) and is_float(x2) and is_float(y2),
      do: max(abs(x2 - x1), abs(y2 - y1))

  def chebyshev_distance({x1, y1}, {x2, y2}), do: max(abs(x2 - x1), abs(y2 - y1))

  @doc """
  `p_norm(v,order)` returns the [P-norm](https://en.wikipedia.org/wiki/Lp_space#The_p-norm_in_finite_dimensions) of vector `v` of order `order`.

  `order` needs to be greater than or equal to 1 to define a [metric space](https://en.wikipedia.org/wiki/Metric_space).

  `order` 1 is equivalent to manhattan distance, 2 to Euclidean distance, otherwise all bets are off.
  """
  @spec p_norm(vec2, number) :: number
  def p_norm({x, y}, order) when is_float(x) and is_float(y) and is_float(order),
    do: :math.pow(:math.pow(abs(x), order) + :math.pow(abs(y), order), 1.0 / order)

  def p_norm({x, y}, order),
    do: :math.pow(:math.pow(abs(x), order) + :math.pow(abs(y), order), 1.0 / order)
end
