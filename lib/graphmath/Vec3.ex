defmodule Graphmath.Vec3 do
  @moduledoc """
  This is the 3D mathematics library for graphmath.

  This submodule handles 3D vectors using tuples of floats.
  """

  @type vec3 :: {float, float, float}

  @doc """
  `create()` creates a zeroed `vec3`.

  It takes no arguments.

  It returns a `vec3` of the form `{ 0.0, 0.0, 0.0 }`.
  """
  @spec create() :: vec3
  def create() do
    {0.0, 0.0, 0.0}
  end

  @doc """
  `create(x,y,z)` creates a `vec3` of value (x,y,z).

  `x` is the first element of the `vec3` to be created.

  `y` is the second element of the `vec3` to be created.

  `z` is the third element of the `vec3` to be created.

  It returns a `vec3` of the form `{x,y,z}`.
  """
  @spec create(float, float, float) :: vec3
  def create(x, y, z) do
    {x, y, z}
  end

  @doc """
  `create(vec)` creates a `vec3` from a list of 3 or more floats.

  `vec` is a list of 3 or more floats.

  It returns a `vec3` of the form `{x,y,z}`, where `x`, `y`, and `z` are the first three elements in `vec`.
  """
  @spec create([float]) :: vec3
  def create(vec) do
    [x, y, z | _] = vec
    {x, y, z}
  end

  @doc """
  `add( a, b)` adds two `vec3`s.

  `a` is the first `vec3`.

  `b` is the second `vec3`.

  It returns a `vec3` of the form { a<sub>x</sub> + b<sub>x</sub>, a<sub>y</sub> + b<sub>y</sub>, a<sub>z</sub> + b<sub>z</sub> }.
  """
  @spec add(vec3, vec3) :: vec3
  def add(a, b) do
    {x, y, z} = a
    {u, v, w} = b
    {x + u, y + v, z + w}
  end

  @doc """
  `subtract(a, b)` subtracts one `vec3` from another `vec3`.

  `a` is the `vec3` minuend.

  `b` is the `vec3` subtrahend.

  It returns a `vec3` of the form { a<sub>x</sub> - b<sub>x</sub>, a<sub>y</sub> - b<sub>y</sub>, a<sub>z</sub> - b<sub>z</sub> }.

  (the terminology was found [here](http://mathforum.org/library/drmath/view/58801.html)).
  """
  @spec subtract(vec3, vec3) :: vec3
  def subtract(a, b) do
    {x, y, z} = a
    {u, v, w} = b
    {x - u, y - v, z - w}
  end

  @doc """
  `multiply( a, b)` multiplies element-wise a `vec3` by another `vec3`.

  `a` is the `vec3` multiplicand.

  `b` is the `vec3` multiplier.

  It returns a `vec3` of the form { a<sub>x</sub>b<sub>x</sub>, a<sub>y</sub>b<sub>y</sub>, a<sub>z</sub>b<sub>z</sub> }.
  """
  @spec multiply(vec3, vec3) :: vec3
  def multiply(a, b) do
    {x, y, z} = a
    {u, v, w} = b
    {x * u, y * v, z * w}
  end

  @doc """
  `scale( a, scale)` uniformly scales a `vec3`.

  `a` is the `vec3` to be scaled.

  `scale` is the float to scale each element of `a` by.

  It returns a tuple of the form { a<sub>x</sub>scale, a<sub>y</sub>scale, a<sub>z</sub>scale }.
  """
  @spec scale(vec3, float) :: vec3
  def scale(a, scale) do
    {x, y, z} = a
    {x * scale, y * scale, z * scale}
  end

  @doc """
  `dot( a, b)` finds the dot (inner) product of one `vec3` with another `vec3`.

  `a` is the first `vec3`.

  `b` is the second `vec3`.

  It returns a float of the value (a<sub>x</sub>b<sub>x</sub> + a<sub>y</sub>b<sub>y</sub> + a<sub>z</sub>b<sub>z</sub>).
  """
  @spec dot(vec3, vec3) :: float
  def dot(a, b) do
    {x, y, z} = a
    {u, v, w} = b
    x * u + y * v + z * w
  end

  @doc """
  `cross( a, b)` finds the cross productof one `vec3` with another `vec3`.

  `a` is the first `vec3`.

  `b` is the second `vec3`.

  It returns a float of the value ( a<sub>y</sub>b<sub>z</sub> - a<sub>z</sub>b<sub>y</sub>, a<sub>z</sub>b<sub>x</sub> - a<sub>x</sub>b<sub>z</sub>, a<sub>x</sub>b<sub>y</sub> - a<sub>y</sub>b<sub>x</sub>).

  The cross product of two vectors is a vector perpendicular to the two source vectors.
  Its magnitude will be the area of the parallelogram made by the two souce vectors.

  """
  @spec cross(vec3, vec3) :: vec3
  def cross(a, b) do
    {x, y, z} = a
    {u, v, w} = b
    {y * w - z * v, z * u - x * w, x * v - y * u}
  end

  @doc """
  `length(a)` finds the length (Eucldiean or L2 norm) of a `vec3`.

  `a` is the `vec3` to find the length of.

  It returns a float of the value (sqrt( a<sub>x</sub><sup>2</sup> + a<sub>y</sub><sup>2</sup> + a<sub>z</sub><sup>2</sup>)).
  """
  @spec length(vec3) :: float
  def length(a) do
    {x, y, z} = a
    :math.sqrt(x * x + y * y + z * z)
  end

  @doc """
  `length_squared(a)` finds the square of the length of a `vec3`.

  `a` is the `vec3` to find the length squared of.

  It returns a float of the value a<sub>x</sub><sup>2</sup> + a<sub>y</sub><sup>2</sup> + a<sub>z</sub><sup>2</sup>.

  In many cases, this is sufficient for comparisons and avoids a square root.
  """
  @spec length_squared(vec3) :: float
  def length_squared(a) do
    {x, y, z} = a
    x * x + y * y + z * z
  end

  @doc """
  `length_manhattan(a)` finds the Manhattan (L1 norm) length of a `vec3`.

  `a` is the `vec3` to find the Manhattan length of.

  It returns a float of the value (a<sub>x</sub> + a<sub>y</sub> + a<sub>z</sub>).

  The Manhattan length is the sum of the components.
  """
  @spec length_manhattan(vec3) :: float
  def length_manhattan(a) do
    {x, y, z} = a
    x + y + z
  end

  @doc """
  `normalize(a)` finds the unit vector with the same direction as a `vec3`.

  `a` is the `vec3` to be normalized.

  It returns a `vec3` of the form `{normx, normy, normz}`.

  This is done by dividing each component by the vector's magnitude.
  """
  @spec normalize(vec3) :: vec3
  def normalize(a) do
    {x, y, z} = a
    imag = 1 / :math.sqrt(x * x + y * y + z * z)
    {x * imag, y * imag, z * imag}
  end

  @doc """
  `lerp(a,b,t)` linearly interpolates between one `vec3` and another `vec3` along an interpolant.

  `a` is the starting `vec3`.

  `b` is the ending `vec3`.

  `t` is the interpolant float, on the domain [0,1].

  It returns a `vec3` of the form (1-t)**a** - (t)**b**.

  The interpolant `t` is on the domain [0,1]. Behavior outside of that is undefined.
  """
  @spec lerp(vec3, vec3, float) :: vec3
  def lerp(a, b, t) do
    {x, y, z} = a
    {u, v, w} = b
    {t * u + (1 - t) * x, t * v + (1 - t) * y, t * w + (1 - t) * z}
  end

  @doc """
  `near(a,b, distance)` checks whether two `vec3`s are within a certain distance of each other.

  `a` is the first `vec3`.

  `b` is the second `vec3`.

  `distance` is the distance between them as a float.
  """
  @spec near(vec3, vec3, float) :: boolean
  def near(a, b, distance) do
    {x, y, z} = a
    {u, v, w} = b
    dx = u - x
    dy = v - y
    dz = w - z
    distance > :math.sqrt(dx * dx + dy * dy + dz * dz)
  end

  @doc """
  `rotate( v, k, theta)` rotates a vector (v) about a unit vector (k) by theta radians.

  `v` is the `vec3` to be rotated.

  `k` is the `vec3` axis of rotation. *It must be of unit length*.

  `theta` is the angle in radians to rotate as a float.

  This uses the [Formula of Rodriguez](http://en.wikipedia.org/wiki/Rodrigues%27_rotation_formula):

  **V**<sub>rot</sub> = **V**cos(theta) + (**K** x **V**)sin(theta) + **K**(**K** dot **V**)(1-cos(theta))
  """
  @spec rotate(vec3, vec3, float) :: vec3
  def rotate(v, k, theta) do
    {vx, vy, vz} = v
    {kx, ky, kz} = k
    ct = :math.cos(theta)
    st = :math.sin(theta)
    k_dot_v = vx * kx + vy * ky + vz * kz
    coeff = (1.0 - ct) * k_dot_v

    v
    |> scale(ct)
    |> add(scale(cross(k, v), st))
    |> add(scale(k, coeff))
  end

  @doc """
  `equal(a, b)` checks to see if two vec3s a and b are equivalent.

  `a` is the `vec3`.

  `b` is the `vec3`.

  It returns true if the vectors have equal elements.

  Note that due to precision issues, you may want to use `equal/3` instead.
  """
  @spec equal(vec3, vec3) :: boolean
  def equal({ax, ay, az}, {bx, by, bz}) do
    ax == bx and ay == by and az == bz
  end

  @doc """
  `equal(a, b, eps)` checks to see if two vec3s a and b are equivalent within some tolerance.

  `a` is the `vec3`.

  `b` is the `vec3`.

  `eps` is the tolerance, a float.

  It returns true if the vectors have equal elements within some tolerance.
  """
  @spec equal(vec3, vec3, float) :: boolean
  def equal({ax, ay, az}, {bx, by, bz}, eps) do
    abs(ax - bx) <= eps and
      abs(ay - by) <= eps and
      abs(az - bz) <= eps
  end

  @doc """
  `random_sphere()` gives a point at or within unit distance of the origin, using [this](http://extremelearning.com.au/how-to-generate-uniformly-random-points-on-n-spheres-and-n-balls/) polar method.
  Another really nice exploration of this is [here](http://mathworld.wolfram.com/SpherePointPicking.html).

  It returns a vec3 within at most unit distance of the origin.
  """
  @spec random_sphere() :: vec3
  def random_sphere() do
    u = 2.0 * :rand.uniform() - 1
    phi = 2.0 * :math.pi() * :rand.uniform()
    x = :math.cos(phi) * :math.sqrt(1 - u * u)
    y = :math.sin(phi) * :math.sqrt(1 - u * u)
    z = u
    {x, y, z}
  end

  @doc """
  `random_ball()` gives a point at or within unit distance of the origin, using [the last algo here](https://karthikkaranth.me/blog/generating-random-points-in-a-sphere/).

  It returns a vec3 within at most unit distance of the origin.
  """
  @spec random_ball() :: vec3
  def random_ball() do
    u = :rand.uniform()
    v = :rand.uniform()
    theta = 2.0 * u * :math.pi()
    phi = :math.acos(2.0 * v - 1.0)
    # basically cube root
    r = :math.pow(:rand.uniform(), 1 / 3)
    sin_theta = :math.sin(theta)
    cos_theta = :math.cos(theta)
    sin_phi = :math.sin(phi)
    cos_phi = :math.cos(phi)
    x = r * sin_phi * cos_theta
    y = r * sin_phi * sin_theta
    z = r * cos_phi
    {x, y, z}
  end

  @doc """
  `random_box()` gives a point on or in the unit box [0,1]x[0,1]x[0,1].

  It returns a vec3.
  """
  @spec random_box() :: vec3
  def random_box(), do: {:rand.uniform(), :rand.uniform(), :rand.uniform()}

  @doc """
  `negate(v)` creates a vector whose elements are opposite in sign to `v`.
  """
  @spec negate(vec3) :: vec3
  def negate({x, y, z}), do: {-1.0 * x, -1.0 * y, -1.0 * z}

  @doc """
  `weighted_sum(a, v1, b, v2)` returns the sum of vectors `v1` and `v2` having been scaled by `a` and `b`, respectively.
  """
  @spec weighted_sum(number, vec3, number, vec3) :: vec3
  def weighted_sum(a, {x, y, z}, b, {u, v, w}) do
    {a * x + b * u, a * y + b * v, a * z + b * w}
  end

  @doc """
  `scalar_triple(a,b,c)` returns the [scalar triple product](https://en.wikipedia.org/wiki/Triple_product#Scalar_triple_product) of three vectors.

  We're using the `a*(b x c)` form.
  """
  @spec scalar_triple(vec3, vec3, vec3) :: float
  def scalar_triple({ax, ay, az}, {bx, by, bz}, {cx, cy, cz}) do
    ax * (by * cz - bz * cy) + ay * (bz * cx - bx * cz) + az * (bx * cy - by * cx)
  end

  @doc """
  `minkowski_distance(a,b,order)` returns the [Minkowski distance](https://en.wikipedia.org/wiki/Minkowski_distance) between two points `a` and b` of order `order`.

  `order` needs to be greater than or equal to 1 to define a [metric space](https://en.wikipedia.org/wiki/Metric_space).

  `order` 1 is equivalent to manhattan distance, 2 to Euclidean distance, otherwise all bets are off.
  """
  @spec minkowski_distance( vec3, vec3, number) :: number
  def minkowski_distance({x1,y1,z1}, {x2,y2,z2}, order) do
    adx = abs(x2 - x1)
    ady = abs(y2 - y1)
    adz = abs(z2 - z1)
    temp = :math.pow(adx, order) + :math.pow(ady, order) + :math.pow(adz, order)
    :math.pow(temp, 1 / order)
  end

  @doc """
  `chebyshev_distance(a,b)` returns the [Chebyshev distance](https://en.wikipedia.org/wiki/Chebyshev_distance) between two points `a` and b`.
  """
  @spec chebyshev_distance( vec3, vec3) :: number
  def chebyshev_distance({x1,y1,z1}, {x2,y2,z2}) do
    adx = abs(x2 - x1)
    ady = abs(y2 - y1)
    adz = abs(z2 - z1)
    max(adx, max(ady,adz))
  end

  @doc """
  `p_norm(v,order)` returns the [P-norm](https://en.wikipedia.org/wiki/Lp_space#The_p-norm_in_finite_dimensions) of vector `v` of order `order`.

  `order` needs to be greater than or equal to 1 to define a [metric space](https://en.wikipedia.org/wiki/Metric_space).

  `order` 1 is equivalent to manhattan distance, 2 to Euclidean distance, otherwise all bets are off.
  """
  @spec p_norm( vec3, number) :: number
  def p_norm({x, y, z}, order) do
    ax = abs(x)
    ay = abs(y)
    az = abs(z)
    temp = :math.pow(ax, order) + :math.pow(ay, order) + :math.pow(az, order)
    :math.pow(temp, 1 / order)
  end
end
