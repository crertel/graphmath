defmodule Graphmath.Mat44 do
  @moduledoc """
  4x4 matrices and 3D affine transformations, using tuples of floats.

  Reflection and shear constructors act on three spatial coordinates and
  preserve the fourth, homogeneous coordinate. Use `transform_point/2` for
  points (`w = 1`) and `transform_vector/2` for directions (`w = 0`), so that
  translation affects only points. A shear can change X, Y or Z; `w` is not
  another spatial axis.

  Tuples store matrix rows in order. `apply(a, v)` computes the column-vector
  product **A****v**. Graphics constructors use row vectors: `transform_point/2`
  and `transform_vector/2` multiply `{x,y,z,1}` and `{x,y,z,0}` by **A** from the
  left, then drop the fourth coordinate. Use `apply_left(v, a)` or
  `apply_transpose(a, v)` for the corresponding full four-component product.

  For full vectors, `apply_left(v, multiply(a, b))` applies `a` first, then `b`.

  `perspective/4` and `ortho/6` project right-handed camera coordinates with -Z
  forward into the OpenGL normalized device depth range [-1, +1]. Perspective
  projection requires keeping the output of `apply_left/2` and dividing its
  first three coordinates by `w`; `transform_point/2` does not perform that step.
  """

  @type mat44 ::
          {float, float, float, float, float, float, float, float, float, float, float, float,
           float, float, float, float}
  @type vec4 :: {float, float, float, float}
  @type vec3 :: {float, float, float}

  @doc """
  `identity()` creates an identity `mat44`.

  This returns an identity `mat44`.
  """
  @spec identity() :: mat44
  def identity(),
    do: {1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0}

  @doc """
  `zero()` creates a zeroed `mat44`.

  This returns a zeroed `mat44`.
  """
  @spec zero() :: mat44
  def zero(), do: {0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0}

  @doc """
  `add(a,b)` adds one `mat44` to another `mat44`.

  `a` is the first `mat44`.

  `b` is the second `mat44`.

  This returns a `mat44` which is the element-wise sum of `a` and `b`.
  """
  @spec add(mat44, mat44) :: mat44
  def add(
        {a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44},
        {b11, b12, b13, b14, b21, b22, b23, b24, b31, b32, b33, b34, b41, b42, b43, b44}
      )
      when is_float(a11) and is_float(a12) and is_float(a13) and is_float(a14) and
             is_float(a21) and is_float(a22) and is_float(a23) and is_float(a24) and
             is_float(a31) and is_float(a32) and is_float(a33) and is_float(a34) and
             is_float(a41) and is_float(a42) and is_float(a43) and is_float(a44) and
             is_float(b11) and is_float(b12) and is_float(b13) and is_float(b14) and
             is_float(b21) and is_float(b22) and is_float(b23) and is_float(b24) and
             is_float(b31) and is_float(b32) and is_float(b33) and is_float(b34) and
             is_float(b41) and is_float(b42) and is_float(b43) and is_float(b44),
      do:
        {a11 + b11, a12 + b12, a13 + b13, a14 + b14, a21 + b21, a22 + b22, a23 + b23, a24 + b24,
         a31 + b31, a32 + b32, a33 + b33, a34 + b34, a41 + b41, a42 + b42, a43 + b43, a44 + b44}

  def add(
        {a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44},
        {b11, b12, b13, b14, b21, b22, b23, b24, b31, b32, b33, b34, b41, b42, b43, b44}
      ),
      do:
        {a11 + b11, a12 + b12, a13 + b13, a14 + b14, a21 + b21, a22 + b22, a23 + b23, a24 + b24,
         a31 + b31, a32 + b32, a33 + b33, a34 + b34, a41 + b41, a42 + b42, a43 + b43, a44 + b44}

  @doc """
  `subtract(a,b)` subtracts one `mat44` from another `mat44`.

  `a` is the minuend.

  `b` is the subtraherd.

  This returns a `mat44` formed by the element-wise subtraction of `b` from `a`.
  """
  @spec subtract(mat44, mat44) :: mat44
  def subtract(
        {a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44},
        {b11, b12, b13, b14, b21, b22, b23, b24, b31, b32, b33, b34, b41, b42, b43, b44}
      )
      when is_float(a11) and is_float(a12) and is_float(a13) and is_float(a14) and
             is_float(a21) and is_float(a22) and is_float(a23) and is_float(a24) and
             is_float(a31) and is_float(a32) and is_float(a33) and is_float(a34) and
             is_float(a41) and is_float(a42) and is_float(a43) and is_float(a44) and
             is_float(b11) and is_float(b12) and is_float(b13) and is_float(b14) and
             is_float(b21) and is_float(b22) and is_float(b23) and is_float(b24) and
             is_float(b31) and is_float(b32) and is_float(b33) and is_float(b34) and
             is_float(b41) and is_float(b42) and is_float(b43) and is_float(b44),
      do:
        {a11 - b11, a12 - b12, a13 - b13, a14 - b14, a21 - b21, a22 - b22, a23 - b23, a24 - b24,
         a31 - b31, a32 - b32, a33 - b33, a34 - b34, a41 - b41, a42 - b42, a43 - b43, a44 - b44}

  def subtract(
        {a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44},
        {b11, b12, b13, b14, b21, b22, b23, b24, b31, b32, b33, b34, b41, b42, b43, b44}
      ),
      do:
        {a11 - b11, a12 - b12, a13 - b13, a14 - b14, a21 - b21, a22 - b22, a23 - b23, a24 - b24,
         a31 - b31, a32 - b32, a33 - b33, a34 - b34, a41 - b41, a42 - b42, a43 - b43, a44 - b44}

  @doc """
  `scale( a, k )` scales every element in a `mat44` by a coefficient k.

  `a` is the `mat44` to scale.

  `k` is the float to scale by.

  This returns a `mat44` `a` scaled element-wise by `k`.
  """
  @spec scale(mat44, float) :: mat44
  def scale({a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44}, k)
      when is_float(a11) and is_float(a12) and is_float(a13) and is_float(a14) and
             is_float(a21) and is_float(a22) and is_float(a23) and is_float(a24) and
             is_float(a31) and is_float(a32) and is_float(a33) and is_float(a34) and
             is_float(a41) and is_float(a42) and is_float(a43) and is_float(a44) and is_float(k),
      do:
        {a11 * k, a12 * k, a13 * k, a14 * k, a21 * k, a22 * k, a23 * k, a24 * k, a31 * k, a32 * k,
         a33 * k, a34 * k, a41 * k, a42 * k, a43 * k, a44 * k}

  def scale({a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44}, k),
    do:
      {a11 * k, a12 * k, a13 * k, a14 * k, a21 * k, a22 * k, a23 * k, a24 * k, a31 * k, a32 * k,
       a33 * k, a34 * k, a41 * k, a42 * k, a43 * k, a44 * k}

  @doc """
  `make_scale( k )` creates a `mat44` that uniformly scales.

  `k` is the float value to scale by.

  This returns a `mat44` whose diagonal is all `k`s.
  """
  @spec make_scale(float) :: mat44
  def make_scale(k) when is_float(k),
    do: {k, 0.0, 0.0, 0.0, 0.0, k, 0.0, 0.0, 0.0, 0.0, k, 0.0, 0.0, 0.0, 0.0, k}

  def make_scale(k),
    do: {k, 0.0, 0.0, 0.0, 0.0, k, 0.0, 0.0, 0.0, 0.0, k, 0.0, 0.0, 0.0, 0.0, k}

  @doc """
  `make_scale( sx, sy, sz, sw )` creates a `mat44` that scales each axis independently.

  `sx` is a float for scaling the x-axis.

  `sy` is a float for scaling the y-axis.

  `sz` is a float for scaling the z-axis.

  `sw` is a float for scaling the w-axis.

  This returns a `mat44` whose diagonal is `{ sx, sy, sz, sw }`.

  Note that, when used with `vec3`s via the *transform* methods, `sw` will have no effect.
  """
  @spec make_scale(float, float, float, float) :: mat44
  def make_scale(sx, sy, sz, sw)
      when is_float(sx) and is_float(sy) and is_float(sz) and is_float(sw),
      do: {sx, 0.0, 0.0, 0.0, 0.0, sy, 0.0, 0.0, 0.0, 0.0, sz, 0.0, 0.0, 0.0, 0.0, sw}

  def make_scale(sx, sy, sz, sw),
    do: {sx, 0.0, 0.0, 0.0, 0.0, sy, 0.0, 0.0, 0.0, 0.0, sz, 0.0, 0.0, 0.0, 0.0, sw}

  @doc """
  `make_translate( tx, ty, tz )` creates a mat44 that translates a point by tx, ty, and tz.

  `make_translate( tx, ty, tz )` creates a mat44 that translates a vec3 by (tx, ty, tz).

  `tx` is a float for translating along the x-axis.

  `ty` is a float for translating along the y-axis.

  `tz` is a float for translating along the z-axis.

  This returns a `mat44` which translates by a `vec3` `{ tx, ty, tz }`.
  """
  @spec make_translate(float, float, float) :: mat44
  def make_translate(tx, ty, tz) when is_float(tx) and is_float(ty) and is_float(tz),
    do: {1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, tx, ty, tz, 1.0}

  def make_translate(tx, ty, tz),
    do: {1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, tx, ty, tz, 1.0}

  @doc """
  `make_rotate_x( theta )` creates a `mat44` that rotates a `vec3` by `theta` radians about the +X axis.

  `theta` is the float of the number of radians of rotation the matrix will provide.

  This returns a `mat44` which rotates by `theta` radians about the +X axis.
  """
  @spec make_rotate_x(float) :: mat44
  def make_rotate_x(theta) when is_float(theta) do
    st = :math.sin(theta)
    ct = :math.cos(theta)

    {1.0, 0.0, 0.0, 0.0, 0.0, ct, st, 0.0, 0.0, -st, ct, 0.0, 0.0, 0.0, 0.0, 1.0}
  end

  def make_rotate_x(theta) do
    st = :math.sin(theta)
    ct = :math.cos(theta)

    {1.0, 0.0, 0.0, 0.0, 0.0, ct, st, 0.0, 0.0, -st, ct, 0.0, 0.0, 0.0, 0.0, 1.0}
  end

  @doc """
  `make_rotate_y( theta )` creates a `mat44` that rotates a `vec3` by `theta` radians about the +Y axis.

  `theta` is the float of the number of radians of rotation the matrix will provide.

  This returns a `mat44` which rotates by `theta` radians about the +Y axis.
  """
  @spec make_rotate_y(float) :: mat44
  def make_rotate_y(theta) when is_float(theta) do
    st = :math.sin(theta)
    ct = :math.cos(theta)

    {ct, 0.0, -st, 0.0, 0.0, 1.0, 0.0, 0.0, st, 0.0, ct, 0.0, 0.0, 0.0, 0.0, 1.0}
  end

  def make_rotate_y(theta) do
    st = :math.sin(theta)
    ct = :math.cos(theta)

    {ct, 0.0, -st, 0.0, 0.0, 1.0, 0.0, 0.0, st, 0.0, ct, 0.0, 0.0, 0.0, 0.0, 1.0}
  end

  @doc """
  `make_rotate_Z( theta )` creates a `mat44` that rotates a `vec3` by `theta` radians about the +Z axis.

  `theta` is the float of the number of radians of rotation the matrix will provide.

  This returns a `mat44` which rotates by `theta` radians about the +Z axis.
  """
  @spec make_rotate_z(float) :: mat44
  def make_rotate_z(theta) when is_float(theta) do
    st = :math.sin(theta)
    ct = :math.cos(theta)

    {ct, st, 0.0, 0.0, -st, ct, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0}
  end

  def make_rotate_z(theta) do
    st = :math.sin(theta)
    ct = :math.cos(theta)

    {ct, st, 0.0, 0.0, -st, ct, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0}
  end

  @doc """
  Creates a right-handed perspective projection for row vectors.

  `fov_y` is the vertical field of view in radians, `aspect` is width / height,
  and `near` and `far` are positive distances along the camera's -Z direction.
  Requires `0 < fov_y < pi`, `aspect > 0`, and `0 < near < far`.
  Invalid parameters raise `ArithmeticError`.

  Maps the near and far planes to normalized device depths -1 and +1,
  respectively, following the OpenGL depth convention. Apply with `apply_left/2`
  to a homogeneous point `{x, y, z, 1.0}`, then divide the first three output
  coordinates by the fourth (`w = -z`). No clipping or division is performed
  by this constructor. `transform_point/2` discards `w` and is unsuitable for
  completing a perspective projection.

  ## Examples

      iex> projection = Graphmath.Mat44.perspective(:math.pi() / 2, 1.0, 1.0, 3.0)
      iex> {x, y, z, w} = Graphmath.Mat44.apply_left({0.0, 0.0, -1.0, 1.0}, projection)
      iex> {x / w, y / w, z / w}
      {0.0, 0.0, -1.0}
  """
  @spec perspective(float, float, float, float) :: mat44
  def perspective(fov_y, aspect, near, far)
      when is_float(fov_y) and is_float(aspect) and is_float(near) and is_float(far) do
    if fov_y <= 0.0 or fov_y >= :math.pi() or aspect <= 0.0 or near <= 0.0 or far <= near do
      raise ArithmeticError,
            "perspective requires 0 < fov_y < pi, aspect > 0, and 0 < near < far"
    end

    cotangent = 1.0 / :math.tan(fov_y / 2.0)
    depth_ratio = near / (far - near)

    # Equivalent to -(far + near)/(far - near) and -2*far*near/(far - near),
    # without multiplying the near and far distances together.
    {cotangent / aspect, 0.0, 0.0, 0.0, 0.0, cotangent, 0.0, 0.0, 0.0, 0.0,
     -(1.0 + 2.0 * depth_ratio), -1.0, 0.0, 0.0, -2.0 * near * (1.0 + depth_ratio), 0.0}
  end

  def perspective(fov_y, aspect, near, far) do
    perspective(1.0 * fov_y, 1.0 * aspect, 1.0 * near, 1.0 * far)
  end

  @doc """
  Creates a right-handed orthographic projection for row vectors.

  Maps X bounds `x_min` and `x_max` to -1 and +1, and Y bounds `y_min` and
  `y_max` to -1 and +1. The camera looks down -Z: eye-space `z = -near`
  maps to depth -1, and `z = -far` maps to depth +1 (the OpenGL convention).

  Each pair of bounds must have distinct endpoints; equal endpoints raise
  `ArithmeticError`. Reversed bounds flip the corresponding axis. Unlike
  `perspective/4`, `near` and `far` may be zero or negative, allowing volumes
  that extend behind the eye.

  Preserves the homogeneous coordinate, so `transform_point/2` can apply this
  projection directly. With `apply_left/2`, a point's output `w` remains 1.

  ## Examples

      iex> projection = Graphmath.Mat44.ortho(-2.0, 6.0, -4.0, 4.0, 1.0, 3.0)
      iex> Graphmath.Mat44.transform_point(projection, {2.0, 0.0, -2.0})
      {0.0, 0.0, 0.0}
  """
  @spec ortho(float, float, float, float, float, float) :: mat44
  def ortho(x_min, x_max, y_min, y_max, near, far)
      when is_float(x_min) and is_float(x_max) and is_float(y_min) and is_float(y_max) and
             is_float(near) and is_float(far) do
    if x_min == x_max or y_min == y_max or near == far do
      raise ArithmeticError, "orthographic bounds must have nonzero extent on every axis"
    end

    {2.0 / (x_max - x_min), 0.0, 0.0, 0.0, 0.0, 2.0 / (y_max - y_min), 0.0, 0.0, 0.0, 0.0,
     -2.0 / (far - near), 0.0, -(x_max + x_min) / (x_max - x_min),
     -(y_max + y_min) / (y_max - y_min), -(far + near) / (far - near), 1.0}
  end

  def ortho(x_min, x_max, y_min, y_max, near, far) do
    ortho(1.0 * x_min, 1.0 * x_max, 1.0 * y_min, 1.0 * y_max, 1.0 * near, 1.0 * far)
  end

  @doc """
  Creates a 3D affine reflection across `nx*x + ny*y + nz*z = offset`.

  The normal may have any nonzero length. `offset` is the plane equation
  constant; it is a signed distance only when the normal has unit length.
  Scaling the normal and offset by the same nonzero factor leaves the mirror
  unchanged. A zero normal raises `ArithmeticError`.

  Use `transform_point/2` for points and `transform_vector/2` for directions.
  The homogeneous coordinate is preserved; translation affects only points.
  """
  @spec make_reflect(vec3, float) :: mat44
  def make_reflect({nx, ny, nz}, offset)
      when is_float(nx) and is_float(ny) and is_float(nz) and is_float(offset) do
    scale = max(abs(nx), max(abs(ny), abs(nz)))
    ux = nx / scale
    uy = ny / scale
    uz = nz / scale
    factor = 2.0 / (ux * ux + uy * uy + uz * uz)
    scaled_offset = offset / scale

    {1.0 - factor * ux * ux, -factor * ux * uy, -factor * ux * uz, 0.0, -factor * uy * ux,
     1.0 - factor * uy * uy, -factor * uy * uz, 0.0, -factor * uz * ux, -factor * uz * uy,
     1.0 - factor * uz * uz, 0.0, factor * scaled_offset * ux, factor * scaled_offset * uy,
     factor * scaled_offset * uz, 1.0}
  end

  def make_reflect({nx, ny, nz}, offset) do
    scale = max(abs(nx), max(abs(ny), abs(nz)))
    ux = nx / scale
    uy = ny / scale
    uz = nz / scale
    factor = 2.0 / (ux * ux + uy * uy + uz * uz)
    scaled_offset = offset / scale

    {1.0 - factor * ux * ux, -factor * ux * uy, -factor * ux * uz, 0.0, -factor * uy * ux,
     1.0 - factor * uy * uy, -factor * uy * uz, 0.0, -factor * uz * ux, -factor * uz * uy,
     1.0 - factor * uz * uz, 0.0, factor * scaled_offset * ux, factor * scaled_offset * uy,
     factor * scaled_offset * uz, 1.0}
  end

  @doc """
  Creates a 3D affine X shear: `x' = x + ky*y + kz*z`.

  The other spatial coordinates and homogeneous coordinate are unchanged.
  Use `transform_point/2` or `transform_vector/2` with 3 spatial components.
  """
  @spec make_shear_x(float, float) :: mat44
  def make_shear_x(ky, kz)
      when is_float(ky) and is_float(kz) do
    {1.0, 0.0, 0.0, 0.0, ky, 1.0, 0.0, 0.0, kz, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0}
  end

  def make_shear_x(ky, kz) do
    {1.0, 0.0, 0.0, 0.0, 1.0 * ky, 1.0, 0.0, 0.0, 1.0 * kz, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0}
  end

  @doc """
  Creates a 3D affine Y shear: `y' = y + kx*x + kz*z`.

  The other spatial coordinates and homogeneous coordinate are unchanged.
  Use `transform_point/2` or `transform_vector/2` with 3 spatial components.
  """
  @spec make_shear_y(float, float) :: mat44
  def make_shear_y(kx, kz)
      when is_float(kx) and is_float(kz) do
    {1.0, kx, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, kz, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0}
  end

  def make_shear_y(kx, kz) do
    {1.0, 1.0 * kx, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0 * kz, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0}
  end

  @doc """
  Creates a 3D affine Z shear: `z' = z + kx*x + ky*y`.

  The other spatial coordinates and homogeneous coordinate are unchanged.
  Use `transform_point/2` or `transform_vector/2` with 3 spatial components.
  """
  @spec make_shear_z(float, float) :: mat44
  def make_shear_z(kx, ky)
      when is_float(kx) and is_float(ky) do
    {1.0, 0.0, kx, 0.0, 0.0, 1.0, ky, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0}
  end

  def make_shear_z(kx, ky) do
    {1.0, 0.0, 1.0 * kx, 0.0, 0.0, 1.0, 1.0 * ky, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0}
  end

  @doc """
  `round( a, sigfigs )` rounds every element of a `mat44` to some number of decimal places.

  `a` is the `mat44` to round.

  `sigfigs` is an integer on [0,15] of the number of decimal places to round to.

  This returns a `mat44` which is the result of rounding `a`.
  """
  @spec round(mat44, 0..15) :: mat44
  def round(
        {a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44},
        sigfigs
      )
      when is_float(a11) and is_float(a12) and is_float(a13) and is_float(a14) and
             is_float(a21) and is_float(a22) and is_float(a23) and is_float(a24) and
             is_float(a31) and is_float(a32) and is_float(a33) and is_float(a34) and
             is_float(a41) and is_float(a42) and is_float(a43) and is_float(a44) and
             is_integer(sigfigs) and sigfigs <= 15,
      do: {
        Float.round(1.0 * a11, sigfigs),
        Float.round(1.0 * a12, sigfigs),
        Float.round(1.0 * a13, sigfigs),
        Float.round(1.0 * a14, sigfigs),
        Float.round(1.0 * a21, sigfigs),
        Float.round(1.0 * a22, sigfigs),
        Float.round(1.0 * a23, sigfigs),
        Float.round(1.0 * a24, sigfigs),
        Float.round(1.0 * a31, sigfigs),
        Float.round(1.0 * a32, sigfigs),
        Float.round(1.0 * a33, sigfigs),
        Float.round(1.0 * a34, sigfigs),
        Float.round(1.0 * a41, sigfigs),
        Float.round(1.0 * a42, sigfigs),
        Float.round(1.0 * a43, sigfigs),
        Float.round(1.0 * a44, sigfigs)
      }

  def round(
        {a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44},
        sigfigs
      ),
      do: {
        Float.round(1.0 * a11, sigfigs),
        Float.round(1.0 * a12, sigfigs),
        Float.round(1.0 * a13, sigfigs),
        Float.round(1.0 * a14, sigfigs),
        Float.round(1.0 * a21, sigfigs),
        Float.round(1.0 * a22, sigfigs),
        Float.round(1.0 * a23, sigfigs),
        Float.round(1.0 * a24, sigfigs),
        Float.round(1.0 * a31, sigfigs),
        Float.round(1.0 * a32, sigfigs),
        Float.round(1.0 * a33, sigfigs),
        Float.round(1.0 * a34, sigfigs),
        Float.round(1.0 * a41, sigfigs),
        Float.round(1.0 * a42, sigfigs),
        Float.round(1.0 * a43, sigfigs),
        Float.round(1.0 * a44, sigfigs)
      }

  @doc """
  `multiply( a, b )` multiply two matrices a and b together.

  `a` is the `mat44` multiplicand.

  `b` is the `mat44` multiplier.

  This returns the `mat44` product of the `a` and `b`.
  """
  @spec multiply(mat44, mat44) :: mat44
  def multiply(
        {a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44},
        {b11, b12, b13, b14, b21, b22, b23, b24, b31, b32, b33, b34, b41, b42, b43, b44}
      )
      when is_float(a11) and is_float(a12) and is_float(a13) and is_float(a14) and
             is_float(a21) and is_float(a22) and is_float(a23) and is_float(a24) and
             is_float(a31) and is_float(a32) and is_float(a33) and is_float(a34) and
             is_float(a41) and is_float(a42) and is_float(a43) and is_float(a44) and
             is_float(b11) and is_float(b12) and is_float(b13) and is_float(b14) and
             is_float(b21) and is_float(b22) and is_float(b23) and is_float(b24) and
             is_float(b31) and is_float(b32) and is_float(b33) and is_float(b34) and
             is_float(b41) and is_float(b42) and is_float(b43) and is_float(b44),
      do: {
        a11 * b11 + a12 * b21 + a13 * b31 + a14 * b41,
        a11 * b12 + a12 * b22 + a13 * b32 + a14 * b42,
        a11 * b13 + a12 * b23 + a13 * b33 + a14 * b43,
        a11 * b14 + a12 * b24 + a13 * b34 + a14 * b44,
        a21 * b11 + a22 * b21 + a23 * b31 + a24 * b41,
        a21 * b12 + a22 * b22 + a23 * b32 + a24 * b42,
        a21 * b13 + a22 * b23 + a23 * b33 + a24 * b43,
        a21 * b14 + a22 * b24 + a23 * b34 + a24 * b44,
        a31 * b11 + a32 * b21 + a33 * b31 + a34 * b41,
        a31 * b12 + a32 * b22 + a33 * b32 + a34 * b42,
        a31 * b13 + a32 * b23 + a33 * b33 + a34 * b43,
        a31 * b14 + a32 * b24 + a33 * b34 + a34 * b44,
        a41 * b11 + a42 * b21 + a43 * b31 + a44 * b41,
        a41 * b12 + a42 * b22 + a43 * b32 + a44 * b42,
        a41 * b13 + a42 * b23 + a43 * b33 + a44 * b43,
        a41 * b14 + a42 * b24 + a43 * b34 + a44 * b44
      }

  def multiply(
        {a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44},
        {b11, b12, b13, b14, b21, b22, b23, b24, b31, b32, b33, b34, b41, b42, b43, b44}
      ),
      do: {
        a11 * b11 + a12 * b21 + a13 * b31 + a14 * b41,
        a11 * b12 + a12 * b22 + a13 * b32 + a14 * b42,
        a11 * b13 + a12 * b23 + a13 * b33 + a14 * b43,
        a11 * b14 + a12 * b24 + a13 * b34 + a14 * b44,
        a21 * b11 + a22 * b21 + a23 * b31 + a24 * b41,
        a21 * b12 + a22 * b22 + a23 * b32 + a24 * b42,
        a21 * b13 + a22 * b23 + a23 * b33 + a24 * b43,
        a21 * b14 + a22 * b24 + a23 * b34 + a24 * b44,
        a31 * b11 + a32 * b21 + a33 * b31 + a34 * b41,
        a31 * b12 + a32 * b22 + a33 * b32 + a34 * b42,
        a31 * b13 + a32 * b23 + a33 * b33 + a34 * b43,
        a31 * b14 + a32 * b24 + a33 * b34 + a34 * b44,
        a41 * b11 + a42 * b21 + a43 * b31 + a44 * b41,
        a41 * b12 + a42 * b22 + a43 * b32 + a44 * b42,
        a41 * b13 + a42 * b23 + a43 * b33 + a44 * b43,
        a41 * b14 + a42 * b24 + a43 * b34 + a44 * b44
      }

  @doc """
  `multiply_transpose( a, b )` multiply two matrices a and b<sup>T</sup> together.

  `a` is the `mat44` multiplicand.

  `b` is the `mat44` multiplier.

  This returns the `mat44` product of the `a` and `b`<sup>T</sup>.
  """
  @spec multiply_transpose(mat44, mat44) :: mat44
  def multiply_transpose(
        {a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44},
        {b11, b21, b31, b41, b12, b22, b32, b42, b13, b23, b33, b43, b14, b24, b34, b44}
      )
      when is_float(a11) and is_float(a12) and is_float(a13) and is_float(a14) and
             is_float(a21) and is_float(a22) and is_float(a23) and is_float(a24) and
             is_float(a31) and is_float(a32) and is_float(a33) and is_float(a34) and
             is_float(a41) and is_float(a42) and is_float(a43) and is_float(a44) and
             is_float(b11) and is_float(b12) and is_float(b13) and is_float(b14) and
             is_float(b21) and is_float(b22) and is_float(b23) and is_float(b24) and
             is_float(b31) and is_float(b32) and is_float(b33) and is_float(b34) and
             is_float(b41) and is_float(b42) and is_float(b43) and is_float(b44),
      do: {
        a11 * b11 + a12 * b21 + a13 * b31 + a14 * b41,
        a11 * b12 + a12 * b22 + a13 * b32 + a14 * b42,
        a11 * b13 + a12 * b23 + a13 * b33 + a14 * b43,
        a11 * b14 + a12 * b24 + a13 * b34 + a14 * b44,
        a21 * b11 + a22 * b21 + a23 * b31 + a24 * b41,
        a21 * b12 + a22 * b22 + a23 * b32 + a24 * b42,
        a21 * b13 + a22 * b23 + a23 * b33 + a24 * b43,
        a21 * b14 + a22 * b24 + a23 * b34 + a24 * b44,
        a31 * b11 + a32 * b21 + a33 * b31 + a34 * b41,
        a31 * b12 + a32 * b22 + a33 * b32 + a34 * b42,
        a31 * b13 + a32 * b23 + a33 * b33 + a34 * b43,
        a31 * b14 + a32 * b24 + a33 * b34 + a34 * b44,
        a41 * b11 + a42 * b21 + a43 * b31 + a44 * b41,
        a41 * b12 + a42 * b22 + a43 * b32 + a44 * b42,
        a41 * b13 + a42 * b23 + a43 * b33 + a44 * b43,
        a41 * b14 + a42 * b24 + a43 * b34 + a44 * b44
      }

  def multiply_transpose(
        {a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44},
        {b11, b21, b31, b41, b12, b22, b32, b42, b13, b23, b33, b43, b14, b24, b34, b44}
      ),
      do: {
        a11 * b11 + a12 * b21 + a13 * b31 + a14 * b41,
        a11 * b12 + a12 * b22 + a13 * b32 + a14 * b42,
        a11 * b13 + a12 * b23 + a13 * b33 + a14 * b43,
        a11 * b14 + a12 * b24 + a13 * b34 + a14 * b44,
        a21 * b11 + a22 * b21 + a23 * b31 + a24 * b41,
        a21 * b12 + a22 * b22 + a23 * b32 + a24 * b42,
        a21 * b13 + a22 * b23 + a23 * b33 + a24 * b43,
        a21 * b14 + a22 * b24 + a23 * b34 + a24 * b44,
        a31 * b11 + a32 * b21 + a33 * b31 + a34 * b41,
        a31 * b12 + a32 * b22 + a33 * b32 + a34 * b42,
        a31 * b13 + a32 * b23 + a33 * b33 + a34 * b43,
        a31 * b14 + a32 * b24 + a33 * b34 + a34 * b44,
        a41 * b11 + a42 * b21 + a43 * b31 + a44 * b41,
        a41 * b12 + a42 * b22 + a43 * b32 + a44 * b42,
        a41 * b13 + a42 * b23 + a43 * b33 + a44 * b43,
        a41 * b14 + a42 * b24 + a43 * b34 + a44 * b44
      }

  @doc """
  `column0( a )` selects the first column of a `mat44`.

  `a` is the `mat44` to take the first column of.

  This returns a `vec4` representing the first column of `a`.
  """
  @spec column0(mat44) :: vec4
  def column0({a11, _, _, _, a21, _, _, _, a31, _, _, _, a41, _, _, _})
      when is_float(a11) and is_float(a21) and is_float(a31) and is_float(a41),
      do: {a11, a21, a31, a41}

  def column0({a11, _, _, _, a21, _, _, _, a31, _, _, _, a41, _, _, _}), do: {a11, a21, a31, a41}

  @doc """
  `column1( a )` selects the second column of a `mat44`.

  `a` is the `mat44` to take the second column of.

  This returns a `vec4` representing the second column of `a`.
  """
  @spec column1(mat44) :: vec4
  def column1({_, a12, _, _, _, a22, _, _, _, a32, _, _, _, a42, _, _})
      when is_float(a12) and is_float(a22) and is_float(a32) and is_float(a42),
      do: {a12, a22, a32, a42}

  def column1({_, a12, _, _, _, a22, _, _, _, a32, _, _, _, a42, _, _}), do: {a12, a22, a32, a42}

  @doc """
  `column2( a )` selects the third column of a `mat44`.

  `a` is the `mat44` to take the third column of.

  This returns a `vec4` representing the third column of `a`.
  """
  @spec column2(mat44) :: vec4
  def column2({_, _, a13, _, _, _, a23, _, _, _, a33, _, _, _, a43, _})
      when is_float(a13) and is_float(a23) and is_float(a33) and is_float(a43),
      do: {a13, a23, a33, a43}

  def column2({_, _, a13, _, _, _, a23, _, _, _, a33, _, _, _, a43, _}), do: {a13, a23, a33, a43}

  @doc """
  `column3( a )` selects the fourth column of a `mat44`.

  `a` is the `mat44` to take the fourth column of.

  This returns a `vec4` representing the fourth column of `a`.
  """
  @spec column3(mat44) :: vec4
  def column3({_, _, _, a14, _, _, _, a24, _, _, _, a34, _, _, _, a44})
      when is_float(a14) and is_float(a24) and is_float(a34) and is_float(a44),
      do: {a14, a24, a34, a44}

  def column3({_, _, _, a14, _, _, _, a24, _, _, _, a34, _, _, _, a44}), do: {a14, a24, a34, a44}

  @doc """
  `row0( a )` selects the first row of a `mat44`.

  `a` is the `mat44` to take the first row of.

  This returns a `vec4` representing the first row of `a`.
  """
  @spec row0(mat44) :: vec4
  def row0({a11, a12, a13, a14, _, _, _, _, _, _, _, _, _, _, _, _})
      when is_float(a11) and is_float(a12) and is_float(a13) and is_float(a14),
      do: {a11, a12, a13, a14}

  def row0({a11, a12, a13, a14, _, _, _, _, _, _, _, _, _, _, _, _}), do: {a11, a12, a13, a14}

  @doc """
  `row1( a )` selects the second row of a `mat44`.

  `a` is the `mat44` to take the second row of.

  This returns a `vec4` representing the second row of `a`.
  """
  @spec row1(mat44) :: vec4
  def row1({_, _, _, _, a21, a22, a23, a24, _, _, _, _, _, _, _, _})
      when is_float(a21) and is_float(a22) and is_float(a23) and is_float(a24),
      do: {a21, a22, a23, a24}

  def row1({_, _, _, _, a21, a22, a23, a24, _, _, _, _, _, _, _, _}), do: {a21, a22, a23, a24}

  @doc """
  `row2( a )` selects the third row of a `mat44`.

  `a` is the `mat44` to take the third row of.

  This returns a `vec4` representing the third row of `a`.
  """
  @spec row2(mat44) :: vec4
  def row2({_, _, _, _, _, _, _, _, a31, a32, a33, a34, _, _, _, _})
      when is_float(a31) and is_float(a32) and is_float(a33) and is_float(a34),
      do: {a31, a32, a33, a34}

  def row2({_, _, _, _, _, _, _, _, a31, a32, a33, a34, _, _, _, _}), do: {a31, a32, a33, a34}

  @doc """
  `row3( a )` selects the fourth row of a `mat44`.

  `a` is the `mat44` to take the fourth row of.

  This returns a `vec4` representing the fourth row of `a`.
  """
  @spec row3(mat44) :: vec4
  def row3({_, _, _, _, _, _, _, _, _, _, _, _, a41, a42, a43, a44})
      when is_float(a41) and is_float(a42) and is_float(a43) and is_float(a44),
      do: {a41, a42, a43, a44}

  def row3({_, _, _, _, _, _, _, _, _, _, _, _, a41, a42, a43, a44}),
    do: {a41, a42, a43, a44}

  @doc """
  `diag( a )` selects the diagonal of a `mat44`.

  `a` is the `mat44` to take the diagonal of.

  This returns a `vec4` representing the diagonal of `a`.
  """
  @spec diag(mat44) :: vec4
  def diag({a11, _, _, _, _, a22, _, _, _, _, a33, _, _, _, _, a44})
      when is_float(a11) and is_float(a22) and is_float(a33) and is_float(a44),
      do: {a11, a22, a33, a44}

  def diag({a11, _, _, _, _, a22, _, _, _, _, a33, _, _, _, _, a44}), do: {a11, a22, a33, a44}

  @doc """
  `at( a, i, j)` selects an element of a `mat44`.

  `a` is the `mat44` to index.

  `i` is the row integer index [0,3].

  `j` is the column integer index [0,3].

  This returns a float from the matrix at row `i` and column `j`.
  """
  @spec at(mat44, non_neg_integer, non_neg_integer) :: float
  def at(a, i, j), do: elem(a, 4 * i + j)

  @doc """
  `apply( a, v )` transforms a `vec4` by a `mat44`.

  `a` is the `mat44` to transform by.

  `v` is the `vec4` to be transformed.

  This returns a `vec4` representing **A****v**.

  This is the "full" application of a matrix, and uses all elements.
  """
  @spec apply(mat44, vec4) :: vec4
  def apply(
        {a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44},
        {x, y, z, w}
      )
      when is_float(a11) and is_float(a12) and is_float(a13) and is_float(a14) and
             is_float(a21) and is_float(a22) and is_float(a23) and is_float(a24) and
             is_float(a31) and is_float(a32) and is_float(a33) and is_float(a34) and
             is_float(a41) and is_float(a42) and is_float(a43) and is_float(a44) and
             is_float(x) and is_float(y) and is_float(z) and is_float(w),
      do: {
        a11 * x + a12 * y + a13 * z + a14 * w,
        a21 * x + a22 * y + a23 * z + a24 * w,
        a31 * x + a32 * y + a33 * z + a34 * w,
        a41 * x + a42 * y + a43 * z + a44 * w
      }

  def apply(
        {a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44},
        {x, y, z, w}
      ),
      do: {
        a11 * x + a12 * y + a13 * z + a14 * w,
        a21 * x + a22 * y + a23 * z + a24 * w,
        a31 * x + a32 * y + a33 * z + a34 * w,
        a41 * x + a42 * y + a43 * z + a44 * w
      }

  @doc """
  `apply_transpose( a, v )` transforms a `vec4` by a a transposed `mat44`.

  `a` is the `mat44` to transform by.

  `v` is the `vec4` to be transformed.

  This returns a `vec4` representing **A**<sup>T</sup>**v**.

  This is the "full" application of a matrix, and uses all elements.
  """
  @spec apply_transpose(mat44, vec4) :: vec4
  def apply_transpose(
        {a11, a21, a31, a41, a12, a22, a32, a42, a13, a23, a33, a43, a14, a24, a34, a44},
        {x, y, z, w}
      )
      when is_float(a11) and is_float(a12) and is_float(a13) and is_float(a14) and
             is_float(a21) and is_float(a22) and is_float(a23) and is_float(a24) and
             is_float(a31) and is_float(a32) and is_float(a33) and is_float(a34) and
             is_float(a41) and is_float(a42) and is_float(a43) and is_float(a44) and
             is_float(x) and is_float(y) and is_float(z) and is_float(w),
      do: {
        a11 * x + a12 * y + a13 * z + a14 * w,
        a21 * x + a22 * y + a23 * z + a24 * w,
        a31 * x + a32 * y + a33 * z + a34 * w,
        a41 * x + a42 * y + a43 * z + a44 * w
      }

  def apply_transpose(
        {a11, a21, a31, a41, a12, a22, a32, a42, a13, a23, a33, a43, a14, a24, a34, a44},
        {x, y, z, w}
      ),
      do: {
        a11 * x + a12 * y + a13 * z + a14 * w,
        a21 * x + a22 * y + a23 * z + a24 * w,
        a31 * x + a32 * y + a33 * z + a34 * w,
        a41 * x + a42 * y + a43 * z + a44 * w
      }

  @doc """
  `apply_left( v, a )` transforms a `vec4` by a `mat44`, applied on the left.

  `a` is the `mat44` to transform by.

  `v` is the `vec4` to be transformed.

  This returns a `vec4` representing **v****A**.

  This is the "full" application of a matrix, and uses all elements.
  """
  @spec apply_left(vec4, mat44) :: vec4
  def apply_left(
        {x, y, z, w},
        {a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44}
      )
      when is_float(a11) and is_float(a12) and is_float(a13) and is_float(a14) and
             is_float(a21) and is_float(a22) and is_float(a23) and is_float(a24) and
             is_float(a31) and is_float(a32) and is_float(a33) and is_float(a34) and
             is_float(a41) and is_float(a42) and is_float(a43) and is_float(a44) and
             is_float(x) and is_float(y) and is_float(z) and is_float(w),
      do: {
        a11 * x + a21 * y + a31 * z + a41 * w,
        a12 * x + a22 * y + a32 * z + a42 * w,
        a13 * x + a23 * y + a33 * z + a43 * w,
        a14 * x + a24 * y + a34 * z + a44 * w
      }

  def apply_left(
        {x, y, z, w},
        {a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44}
      ),
      do: {
        a11 * x + a21 * y + a31 * z + a41 * w,
        a12 * x + a22 * y + a32 * z + a42 * w,
        a13 * x + a23 * y + a33 * z + a43 * w,
        a14 * x + a24 * y + a34 * z + a44 * w
      }

  @doc """
  `apply_left_transpose( v, a )` transforms a `vec3` by a transposed `mat33`, applied on the left.

  `a` is the `mat44` to transform by.

  `v` is the `vec4` to be transformed.

  This returns a `vec4` representing **v****A**<sup>T</sup>.

  This is the "full" application of a matrix, and uses all elements.
  """
  @spec apply_left_transpose(vec4, mat44) :: vec4
  def apply_left_transpose(
        {x, y, z, w},
        {a11, a21, a31, a41, a12, a22, a32, a42, a13, a23, a33, a43, a14, a24, a34, a44}
      )
      when is_float(a11) and is_float(a12) and is_float(a13) and is_float(a14) and
             is_float(a21) and is_float(a22) and is_float(a23) and is_float(a24) and
             is_float(a31) and is_float(a32) and is_float(a33) and is_float(a34) and
             is_float(a41) and is_float(a42) and is_float(a43) and is_float(a44) and
             is_float(x) and is_float(y) and is_float(z) and is_float(w),
      do: {
        a11 * x + a21 * y + a31 * z + a41 * w,
        a12 * x + a22 * y + a32 * z + a42 * w,
        a13 * x + a23 * y + a33 * z + a43 * w,
        a14 * x + a24 * y + a34 * z + a44 * w
      }

  def apply_left_transpose(
        {x, y, z, w},
        {a11, a21, a31, a41, a12, a22, a32, a42, a13, a23, a33, a43, a14, a24, a34, a44}
      ),
      do: {
        a11 * x + a21 * y + a31 * z + a41 * w,
        a12 * x + a22 * y + a32 * z + a42 * w,
        a13 * x + a23 * y + a33 * z + a43 * w,
        a14 * x + a24 * y + a34 * z + a44 * w
      }

  @doc """
  Transforms a 3D point `{x, y, z}` using the row-vector product `{x, y, z, 1.0} a`.

  Returns the first three coordinates, including the effect of translation.
  Use with 3D affine matrices. No perspective division is performed.
  Use `apply_left/2` to supply and retain all four coordinates explicitly.
  """
  @spec transform_point(mat44, vec3) :: vec3
  def transform_point(
        {a11, a21, a31, _, a12, a22, a32, _, a13, a23, a33, _, a14, a24, a34, _},
        {x, y, z}
      )
      when is_float(a11) and is_float(a21) and is_float(a31) and
             is_float(a12) and is_float(a22) and is_float(a32) and
             is_float(a13) and is_float(a23) and is_float(a33) and
             is_float(a14) and is_float(a24) and is_float(a34) and is_float(x) and is_float(y) and
             is_float(z),
      do: {
        a11 * x + a12 * y + a13 * z + a14,
        a21 * x + a22 * y + a23 * z + a24,
        a31 * x + a32 * y + a33 * z + a34
      }

  def transform_point(
        {a11, a21, a31, _, a12, a22, a32, _, a13, a23, a33, _, a14, a24, a34, _},
        {x, y, z}
      ),
      do: {
        a11 * x + a12 * y + a13 * z + a14,
        a21 * x + a22 * y + a23 * z + a24,
        a31 * x + a32 * y + a33 * z + a34
      }

  @doc """
  Transforms a 3D direction `{x, y, z}` using the row-vector product `{x, y, z, 0.0} a`.

  Returns the first three coordinates. The zero homogeneous coordinate excludes
  translation; rotations, scales, reflections and shears still affect the vector.
  Use `apply_left/2` to supply and retain all four coordinates explicitly.
  """
  @spec transform_vector(mat44, vec3) :: vec3
  def transform_vector(
        {a11, a21, a31, _, a12, a22, a32, _, a13, a23, a33, _, _, _, _, _},
        {x, y, z}
      )
      when is_float(a11) and is_float(a21) and is_float(a31) and
             is_float(a12) and is_float(a22) and is_float(a32) and
             is_float(a13) and is_float(a23) and is_float(a33) and is_float(x) and is_float(y) and
             is_float(z),
      do: {
        a11 * x + a12 * y + a13 * z,
        a21 * x + a22 * y + a23 * z,
        a31 * x + a32 * y + a33 * z
      }

  def transform_vector(
        {a11, a21, a31, _, a12, a22, a32, _, a13, a23, a33, _, _, _, _, _},
        {x, y, z}
      ),
      do: {
        a11 * x + a12 * y + a13 * z,
        a21 * x + a22 * y + a23 * z,
        a31 * x + a32 * y + a33 * z
      }

  @doc """
  Returns the trace, the sum of the diagonal entries.
  """
  @spec trace(mat44) :: float
  def trace({a11, _, _, _, _, a22, _, _, _, _, a33, _, _, _, _, a44})
      when is_float(a11) and is_float(a22) and is_float(a33) and is_float(a44),
      do: a11 + a22 + a33 + a44

  def trace({a11, _, _, _, _, a22, _, _, _, _, a33, _, _, _, _, a44}),
    do: a11 + a22 + a33 + a44

  @doc """
  Returns the determinant of `a`.
  """
  @spec determinant(mat44) :: float
  # Float guards expose the arithmetic's types to the VM for optimization.
  def determinant(
        {a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44}
      )
      when is_float(a11) and is_float(a12) and is_float(a13) and is_float(a14) and is_float(a21) and
             is_float(a22) and is_float(a23) and is_float(a24) and is_float(a31) and is_float(a32) and
             is_float(a33) and is_float(a34) and is_float(a41) and is_float(a42) and is_float(a43) and
             is_float(a44) do
    v0 = a31 * a42 - a32 * a41
    v1 = a31 * a43 - a33 * a41
    v2 = a31 * a44 - a34 * a41
    v3 = a32 * a43 - a33 * a42
    v4 = a32 * a44 - a34 * a42
    v5 = a33 * a44 - a34 * a43

    a11 * (v5 * a22 - v4 * a23 + v3 * a24) -
      a12 * (v5 * a21 - v2 * a23 + v1 * a24) +
      a13 * (v4 * a21 - v2 * a22 + v0 * a24) -
      a14 * (v3 * a21 - v1 * a22 + v0 * a23)
  end

  def determinant(
        {a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44}
      ) do
    v0 = a31 * a42 - a32 * a41
    v1 = a31 * a43 - a33 * a41
    v2 = a31 * a44 - a34 * a41
    v3 = a32 * a43 - a33 * a42
    v4 = a32 * a44 - a34 * a42
    v5 = a33 * a44 - a34 * a43

    a11 * (v5 * a22 - v4 * a23 + v3 * a24) -
      a12 * (v5 * a21 - v2 * a23 + v1 * a24) +
      a13 * (v4 * a21 - v2 * a22 + v0 * a24) -
      a14 * (v3 * a21 - v1 * a22 + v0 * a23)
  end

  @doc """
  Returns the `Graphmath.Mat33` obtained by deleting row `i` and column `j`.

  The remaining entries retain their row-major order. Indices are zero-based
  integers from 0 through 3; invalid indices raise `FunctionClauseError`.

  This returns a matrix. Its determinant is the corresponding scalar minor.
  """
  @spec submatrix(mat44, 0..3, 0..3) :: Graphmath.Mat33.mat33()
  def submatrix({_, _, _, _, _, a22, a23, a24, _, a32, a33, a34, _, a42, a43, a44}, 0, 0)
      when is_float(a22) and is_float(a23) and is_float(a24) and is_float(a32) and is_float(a33) and
             is_float(a34) and is_float(a42) and is_float(a43) and is_float(a44),
      do: {a22, a23, a24, a32, a33, a34, a42, a43, a44}

  def submatrix({_, _, _, _, _, a22, a23, a24, _, a32, a33, a34, _, a42, a43, a44}, 0, 0),
    do: {a22, a23, a24, a32, a33, a34, a42, a43, a44}

  def submatrix({_, _, _, _, a21, _, a23, a24, a31, _, a33, a34, a41, _, a43, a44}, 0, 1)
      when is_float(a21) and is_float(a23) and is_float(a24) and is_float(a31) and is_float(a33) and
             is_float(a34) and is_float(a41) and is_float(a43) and is_float(a44),
      do: {a21, a23, a24, a31, a33, a34, a41, a43, a44}

  def submatrix({_, _, _, _, a21, _, a23, a24, a31, _, a33, a34, a41, _, a43, a44}, 0, 1),
    do: {a21, a23, a24, a31, a33, a34, a41, a43, a44}

  def submatrix({_, _, _, _, a21, a22, _, a24, a31, a32, _, a34, a41, a42, _, a44}, 0, 2)
      when is_float(a21) and is_float(a22) and is_float(a24) and is_float(a31) and is_float(a32) and
             is_float(a34) and is_float(a41) and is_float(a42) and is_float(a44),
      do: {a21, a22, a24, a31, a32, a34, a41, a42, a44}

  def submatrix({_, _, _, _, a21, a22, _, a24, a31, a32, _, a34, a41, a42, _, a44}, 0, 2),
    do: {a21, a22, a24, a31, a32, a34, a41, a42, a44}

  def submatrix({_, _, _, _, a21, a22, a23, _, a31, a32, a33, _, a41, a42, a43, _}, 0, 3)
      when is_float(a21) and is_float(a22) and is_float(a23) and is_float(a31) and is_float(a32) and
             is_float(a33) and is_float(a41) and is_float(a42) and is_float(a43),
      do: {a21, a22, a23, a31, a32, a33, a41, a42, a43}

  def submatrix({_, _, _, _, a21, a22, a23, _, a31, a32, a33, _, a41, a42, a43, _}, 0, 3),
    do: {a21, a22, a23, a31, a32, a33, a41, a42, a43}

  def submatrix({_, a12, a13, a14, _, _, _, _, _, a32, a33, a34, _, a42, a43, a44}, 1, 0)
      when is_float(a12) and is_float(a13) and is_float(a14) and is_float(a32) and is_float(a33) and
             is_float(a34) and is_float(a42) and is_float(a43) and is_float(a44),
      do: {a12, a13, a14, a32, a33, a34, a42, a43, a44}

  def submatrix({_, a12, a13, a14, _, _, _, _, _, a32, a33, a34, _, a42, a43, a44}, 1, 0),
    do: {a12, a13, a14, a32, a33, a34, a42, a43, a44}

  def submatrix({a11, _, a13, a14, _, _, _, _, a31, _, a33, a34, a41, _, a43, a44}, 1, 1)
      when is_float(a11) and is_float(a13) and is_float(a14) and is_float(a31) and is_float(a33) and
             is_float(a34) and is_float(a41) and is_float(a43) and is_float(a44),
      do: {a11, a13, a14, a31, a33, a34, a41, a43, a44}

  def submatrix({a11, _, a13, a14, _, _, _, _, a31, _, a33, a34, a41, _, a43, a44}, 1, 1),
    do: {a11, a13, a14, a31, a33, a34, a41, a43, a44}

  def submatrix({a11, a12, _, a14, _, _, _, _, a31, a32, _, a34, a41, a42, _, a44}, 1, 2)
      when is_float(a11) and is_float(a12) and is_float(a14) and is_float(a31) and is_float(a32) and
             is_float(a34) and is_float(a41) and is_float(a42) and is_float(a44),
      do: {a11, a12, a14, a31, a32, a34, a41, a42, a44}

  def submatrix({a11, a12, _, a14, _, _, _, _, a31, a32, _, a34, a41, a42, _, a44}, 1, 2),
    do: {a11, a12, a14, a31, a32, a34, a41, a42, a44}

  def submatrix({a11, a12, a13, _, _, _, _, _, a31, a32, a33, _, a41, a42, a43, _}, 1, 3)
      when is_float(a11) and is_float(a12) and is_float(a13) and is_float(a31) and is_float(a32) and
             is_float(a33) and is_float(a41) and is_float(a42) and is_float(a43),
      do: {a11, a12, a13, a31, a32, a33, a41, a42, a43}

  def submatrix({a11, a12, a13, _, _, _, _, _, a31, a32, a33, _, a41, a42, a43, _}, 1, 3),
    do: {a11, a12, a13, a31, a32, a33, a41, a42, a43}

  def submatrix({_, a12, a13, a14, _, a22, a23, a24, _, _, _, _, _, a42, a43, a44}, 2, 0)
      when is_float(a12) and is_float(a13) and is_float(a14) and is_float(a22) and is_float(a23) and
             is_float(a24) and is_float(a42) and is_float(a43) and is_float(a44),
      do: {a12, a13, a14, a22, a23, a24, a42, a43, a44}

  def submatrix({_, a12, a13, a14, _, a22, a23, a24, _, _, _, _, _, a42, a43, a44}, 2, 0),
    do: {a12, a13, a14, a22, a23, a24, a42, a43, a44}

  def submatrix({a11, _, a13, a14, a21, _, a23, a24, _, _, _, _, a41, _, a43, a44}, 2, 1)
      when is_float(a11) and is_float(a13) and is_float(a14) and is_float(a21) and is_float(a23) and
             is_float(a24) and is_float(a41) and is_float(a43) and is_float(a44),
      do: {a11, a13, a14, a21, a23, a24, a41, a43, a44}

  def submatrix({a11, _, a13, a14, a21, _, a23, a24, _, _, _, _, a41, _, a43, a44}, 2, 1),
    do: {a11, a13, a14, a21, a23, a24, a41, a43, a44}

  def submatrix({a11, a12, _, a14, a21, a22, _, a24, _, _, _, _, a41, a42, _, a44}, 2, 2)
      when is_float(a11) and is_float(a12) and is_float(a14) and is_float(a21) and is_float(a22) and
             is_float(a24) and is_float(a41) and is_float(a42) and is_float(a44),
      do: {a11, a12, a14, a21, a22, a24, a41, a42, a44}

  def submatrix({a11, a12, _, a14, a21, a22, _, a24, _, _, _, _, a41, a42, _, a44}, 2, 2),
    do: {a11, a12, a14, a21, a22, a24, a41, a42, a44}

  def submatrix({a11, a12, a13, _, a21, a22, a23, _, _, _, _, _, a41, a42, a43, _}, 2, 3)
      when is_float(a11) and is_float(a12) and is_float(a13) and is_float(a21) and is_float(a22) and
             is_float(a23) and is_float(a41) and is_float(a42) and is_float(a43),
      do: {a11, a12, a13, a21, a22, a23, a41, a42, a43}

  def submatrix({a11, a12, a13, _, a21, a22, a23, _, _, _, _, _, a41, a42, a43, _}, 2, 3),
    do: {a11, a12, a13, a21, a22, a23, a41, a42, a43}

  def submatrix({_, a12, a13, a14, _, a22, a23, a24, _, a32, a33, a34, _, _, _, _}, 3, 0)
      when is_float(a12) and is_float(a13) and is_float(a14) and is_float(a22) and is_float(a23) and
             is_float(a24) and is_float(a32) and is_float(a33) and is_float(a34),
      do: {a12, a13, a14, a22, a23, a24, a32, a33, a34}

  def submatrix({_, a12, a13, a14, _, a22, a23, a24, _, a32, a33, a34, _, _, _, _}, 3, 0),
    do: {a12, a13, a14, a22, a23, a24, a32, a33, a34}

  def submatrix({a11, _, a13, a14, a21, _, a23, a24, a31, _, a33, a34, _, _, _, _}, 3, 1)
      when is_float(a11) and is_float(a13) and is_float(a14) and is_float(a21) and is_float(a23) and
             is_float(a24) and is_float(a31) and is_float(a33) and is_float(a34),
      do: {a11, a13, a14, a21, a23, a24, a31, a33, a34}

  def submatrix({a11, _, a13, a14, a21, _, a23, a24, a31, _, a33, a34, _, _, _, _}, 3, 1),
    do: {a11, a13, a14, a21, a23, a24, a31, a33, a34}

  def submatrix({a11, a12, _, a14, a21, a22, _, a24, a31, a32, _, a34, _, _, _, _}, 3, 2)
      when is_float(a11) and is_float(a12) and is_float(a14) and is_float(a21) and is_float(a22) and
             is_float(a24) and is_float(a31) and is_float(a32) and is_float(a34),
      do: {a11, a12, a14, a21, a22, a24, a31, a32, a34}

  def submatrix({a11, a12, _, a14, a21, a22, _, a24, a31, a32, _, a34, _, _, _, _}, 3, 2),
    do: {a11, a12, a14, a21, a22, a24, a31, a32, a34}

  def submatrix({a11, a12, a13, _, a21, a22, a23, _, a31, a32, a33, _, _, _, _, _}, 3, 3)
      when is_float(a11) and is_float(a12) and is_float(a13) and is_float(a21) and is_float(a22) and
             is_float(a23) and is_float(a31) and is_float(a32) and is_float(a33),
      do: {a11, a12, a13, a21, a22, a23, a31, a32, a33}

  def submatrix({a11, a12, a13, _, a21, a22, a23, _, a31, a32, a33, _, _, _, _, _}, 3, 3),
    do: {a11, a12, a13, a21, a22, a23, a31, a32, a33}

  @doc """
  Returns the signed minor at zero-based row `i` and column `j`.

  This is the determinant of `submatrix(a, i, j)`, negated when `i + j`
  is odd. Indices must be integers from 0 through 3; invalid indices raise
  `FunctionClauseError`.
  """
  @spec cofactor(mat44, 0..3, 0..3) :: float
  def cofactor(
        {a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44} = a,
        i,
        j
      )
      when is_float(a11) and is_float(a12) and is_float(a13) and is_float(a14) and is_float(a21) and
             is_float(a22) and is_float(a23) and is_float(a24) and is_float(a31) and is_float(a32) and
             is_float(a33) and is_float(a34) and is_float(a41) and is_float(a42) and is_float(a43) and
             is_float(a44) and i in 0..3 and j in 0..3,
      do: (1.0 - 2.0 * rem(i + j, 2)) * Graphmath.Mat33.determinant(submatrix(a, i, j))

  def cofactor(a, i, j) when i in 0..3 and j in 0..3,
    do: (1 - 2 * rem(i + j, 2)) * Graphmath.Mat33.determinant(submatrix(a, i, j))

  @doc """
  `inverse(a)` calculates the inverse matrix

  `a` is a `mat44` to be inverted

  Returs a `mat44` representing `a`<sup>-1</sup>

  Raises an error when you try to calculate inverse of a matrix whose determinant is `zero`
  """
  @spec inverse(mat44) :: mat44
  def inverse({m00, m01, m02, m03, m10, m11, m12, m13, m20, m21, m22, m23, m30, m31, m32, m33})
      when is_float(m00) and is_float(m01) and is_float(m02) and is_float(m03) and
             is_float(m10) and is_float(m11) and is_float(m12) and is_float(m13) and
             is_float(m20) and is_float(m21) and is_float(m22) and is_float(m23) and
             is_float(m30) and is_float(m31) and is_float(m32) and is_float(m33) do
    v0 = m20 * m31 - m21 * m30
    v1 = m20 * m32 - m22 * m30
    v2 = m20 * m33 - m23 * m30
    v3 = m21 * m32 - m22 * m31
    v4 = m21 * m33 - m23 * m31
    v5 = m22 * m33 - m23 * m32

    t00 = +(v5 * m11 - v4 * m12 + v3 * m13)
    t10 = -(v5 * m10 - v2 * m12 + v1 * m13)
    t20 = +(v4 * m10 - v2 * m11 + v0 * m13)
    t30 = -(v3 * m10 - v1 * m11 + v0 * m12)

    f_det = t00 * m00 + t10 * m01 + t20 * m02 + t30 * m03

    if f_det == 0.0, do: raise("Matrices with determinant equal to zero does not have inverse")

    inv_det = 1.0 / f_det

    d00 = t00 * inv_det
    d10 = t10 * inv_det
    d20 = t20 * inv_det
    d30 = t30 * inv_det

    d01 = -(v5 * m01 - v4 * m02 + v3 * m03) * inv_det
    d11 = +(v5 * m00 - v2 * m02 + v1 * m03) * inv_det
    d21 = -(v4 * m00 - v2 * m01 + v0 * m03) * inv_det
    d31 = +(v3 * m00 - v1 * m01 + v0 * m02) * inv_det

    v0 = m10 * m31 - m11 * m30
    v1 = m10 * m32 - m12 * m30
    v2 = m10 * m33 - m13 * m30
    v3 = m11 * m32 - m12 * m31
    v4 = m11 * m33 - m13 * m31
    v5 = m12 * m33 - m13 * m32

    d02 = +(v5 * m01 - v4 * m02 + v3 * m03) * inv_det
    d12 = -(v5 * m00 - v2 * m02 + v1 * m03) * inv_det
    d22 = +(v4 * m00 - v2 * m01 + v0 * m03) * inv_det
    d32 = -(v3 * m00 - v1 * m01 + v0 * m02) * inv_det

    v0 = m21 * m10 - m20 * m11
    v1 = m22 * m10 - m20 * m12
    v2 = m23 * m10 - m20 * m13
    v3 = m22 * m11 - m21 * m12
    v4 = m23 * m11 - m21 * m13
    v5 = m23 * m12 - m22 * m13

    d03 = -(v5 * m01 - v4 * m02 + v3 * m03) * inv_det
    d13 = +(v5 * m00 - v2 * m02 + v1 * m03) * inv_det
    d23 = -(v4 * m00 - v2 * m01 + v0 * m03) * inv_det
    d33 = +(v3 * m00 - v1 * m01 + v0 * m02) * inv_det

    {d00, d01, d02, d03, d10, d11, d12, d13, d20, d21, d22, d23, d30, d31, d32, d33}
  end

  def inverse({m00, m01, m02, m03, m10, m11, m12, m13, m20, m21, m22, m23, m30, m31, m32, m33}) do
    v0 = m20 * m31 - m21 * m30
    v1 = m20 * m32 - m22 * m30
    v2 = m20 * m33 - m23 * m30
    v3 = m21 * m32 - m22 * m31
    v4 = m21 * m33 - m23 * m31
    v5 = m22 * m33 - m23 * m32

    t00 = +(v5 * m11 - v4 * m12 + v3 * m13)
    t10 = -(v5 * m10 - v2 * m12 + v1 * m13)
    t20 = +(v4 * m10 - v2 * m11 + v0 * m13)
    t30 = -(v3 * m10 - v1 * m11 + v0 * m12)

    f_det = t00 * m00 + t10 * m01 + t20 * m02 + t30 * m03

    if f_det == 0.0, do: raise("Matrices with determinant equal to zero does not have inverse")

    inv_det = 1.0 / f_det

    d00 = t00 * inv_det
    d10 = t10 * inv_det
    d20 = t20 * inv_det
    d30 = t30 * inv_det

    d01 = -(v5 * m01 - v4 * m02 + v3 * m03) * inv_det
    d11 = +(v5 * m00 - v2 * m02 + v1 * m03) * inv_det
    d21 = -(v4 * m00 - v2 * m01 + v0 * m03) * inv_det
    d31 = +(v3 * m00 - v1 * m01 + v0 * m02) * inv_det

    v0 = m10 * m31 - m11 * m30
    v1 = m10 * m32 - m12 * m30
    v2 = m10 * m33 - m13 * m30
    v3 = m11 * m32 - m12 * m31
    v4 = m11 * m33 - m13 * m31
    v5 = m12 * m33 - m13 * m32

    d02 = +(v5 * m01 - v4 * m02 + v3 * m03) * inv_det
    d12 = -(v5 * m00 - v2 * m02 + v1 * m03) * inv_det
    d22 = +(v4 * m00 - v2 * m01 + v0 * m03) * inv_det
    d32 = -(v3 * m00 - v1 * m01 + v0 * m02) * inv_det

    v0 = m21 * m10 - m20 * m11
    v1 = m22 * m10 - m20 * m12
    v2 = m23 * m10 - m20 * m13
    v3 = m22 * m11 - m21 * m12
    v4 = m23 * m11 - m21 * m13
    v5 = m23 * m12 - m22 * m13

    d03 = -(v5 * m01 - v4 * m02 + v3 * m03) * inv_det
    d13 = +(v5 * m00 - v2 * m02 + v1 * m03) * inv_det
    d23 = -(v4 * m00 - v2 * m01 + v0 * m03) * inv_det
    d33 = +(v3 * m00 - v1 * m01 + v0 * m02) * inv_det

    {d00, d01, d02, d03, d10, d11, d12, d13, d20, d21, d22, d23, d30, d31, d32, d33}
  end
end
