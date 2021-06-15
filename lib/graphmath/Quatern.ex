defmodule Graphmath.Quatern do
  @moduledoc """
  This is the 3D mathematics library for graphmath.

  This submodule handles Quaternion using tuples of floats.

  Quaternions represent an angle of theta around a unit axis vector {nx, ny, nz} as `{ cos(theta/2), nx * sin(theta/2), ny * sin(theta/2), nz * sin(theta/2) }`.

  """

  alias Graphmath.Mat33, as: Mat33

  @type quatern :: {float, float, float, float}
  @type vec3 :: {float, float, float}
  @type mat33 :: {float, float, float, float, float, float, float, float, float}
  @type mat44 ::
          {float, float, float, float, float, float, float, float, float, float, float, float,
           float, float, float, float}

  # https://en.wikipedia.org/wiki/Machine_epsilon
  # note that BEAM uses doubles internally, so this is a bit of a cludge
  @machine_small_float 5.96e-08

  @doc """
  `identity()` creates the identity `quatern`.

  It takes no arguments.

  It returns a `quatern` of the form `{1.0, 0.0, 0.0, 0.0}`.
  """
  @spec identity() :: quatern
  def identity(), do: {1.0, 0.0, 0.0, 0.0}

  @doc """
  `zero()` creates a zero `quatern`.

  It takes no arguments.

  It returns a `quatern` of the form `{0.0, 0.0, 0.0, 0.0}`.

  Note that the zero quaternion is almost definetely not something you ever use.
  """
  @spec zero() :: quatern
  def zero(), do: {0.0, 0.0, 0.0, 0.0}

  @doc """
  `equal_elements(a,b)` checks to see if two quaternions a and b are element-wise equal.

  `a` is the first quaternion.

  `b` is the second quaternion.

  It returns true if the quaternions have the same elements, false otherwise.

  **This function does not require normalized quaternions.**

  Note that orientation quaternions exist where a == -b...that is, where the axes are equivalent but the angle is opposite in sign.

  In such cases, prefer the `equal/2` function.
  """
  @spec equal_elements(quatern, quatern) :: boolean()
  def equal_elements({aw, ax, ay, az} = _a, {bw, bx, by, bz} = _b) do
    aw == bw and ax == bx and ay == by and az == bz
  end

  @doc """
  `equal_elements(a,b, eps)` checks to see if two quaternions a and b are element-wise equal to some epsilon

  `a` is the first quaternion.

  `b` is the second quaternion.

  `eps` is the float of the epsilon for comparison.

  It returns true if the quaternions have the same element-wise values up to and including some epsilon.

  **This function does not require normalized quaternions.**

  Note that orientation quaternions exist where a == -b...that is, where the axes are equivalent but the angle is opposite in sign.

  In such cases, prefer the `equal/3` function.
  """
  @spec equal_elements(quatern, quatern, float) :: boolean()
  def equal_elements({aw, ax, ay, az} = _a, {bw, bx, by, bz} = _b, eps) do
    abs(aw - bw) <= eps and
      abs(ax - bx) <= eps and
      abs(ay - by) <= eps and
      abs(az - bz) <= eps
  end

  @doc """
  `equal(a,b)` checks to see if two orientation quaternions a and b are equivalent.

  `a` is the first quaternion.

  `b` is the second quaternion.

  It returns true if the quaternions represent the same orientation.

  **This function expects normalized quaternions.**

  Note that orientation quaternions exist where a == -b...that is, where the axes are equivalent but the angle is opposite in sign.
  """
  @spec equal(quatern, quatern) :: boolean()
  def equal(a, b) do
    abs(dot(a, b)) >= 1.0
  end

  @doc """
  `equal(a,b,eps)` checks to see if two orientation quaternions a and b are equivalent up to some epsilon

  `a` is the first quaternion.

  `b` is the second quaternion.

  `eps` is the epsilon, on the interval [0,1].

  It returns true if the quaternions represent the same orientation.

  **This function expects normalized quaternions.**

  Note that orientation quaternions exist where a == -b...that is, where the axes are equivalent but the angle is opposite in sign.
  """
  @spec equal(quatern, quatern, float) :: boolean()
  def equal(a, b, eps) do
    abs(dot(a, b)) >= 1.0 - eps
  end

  @doc """
  `create(w,x,y,z)` creates a `quatern` of value (w,x,y,z).

  `w` is the rotation around the axis in radians.

  `x` is the first element of the `vec3` representing the axis to be created.

  `y` is the second element of the `vec3` representing the axis to be created.

  `z` is the third element of the `vec3` representing the axis to be created.

  It returns a `quatern` of the form `{w,x,y,z}`.
  """
  @spec create(float, float, float, float) :: quatern
  def create(w, x, y, z) do
    {w, x, y, z}
  end

  @doc """
  `create(quatern)` creates a `quatern` from a list of 4 or more floats.

  `quatern` is a list of 4 or more floats.

  It returns a `quatern` of the form `{w,x,y,z}`, where `w`, `x`, `y`, and `z` are the first four elements in `quatern`.
  """
  @spec from_list([float]) :: quatern
  def from_list([w, x, y, z]), do: {w, x, y, z}

  @doc """
  `create(w, vec)` creates a `quatern` from an angle and an axis.

  `w` is the angle in radians.

  `vec` is the axis `vec3` of the form {x,y,z}.

  It returns a `quatern` of the form `{w,x,y,z}`.
  """
  @spec from_axis_angle(float, vec3) :: quatern
  def from_axis_angle(theta, {x, y, z}) do
    half_theta = theta / 2.0
    ct = :math.cos(half_theta)
    st = :math.sin(half_theta)
    {ct, st * x, st * y, st * z}
  end

  @doc """
  `add(lhs, rhs)` add two quaternions.

  `lhs` is the first `quatern`

  `rhs` is the second `quatern`

  It returns a `quatern` of the form { lhs<sub>w</sub> + rhs<sub>w</sub>, lhs<sub>x</sub> + rhs<sub>x</sub>, lhs<sub>y</sub> + rhs<sub>y</sub>, lhs<sub>z</sub> + rhs<sub>z</sub> }.
  """
  @spec add(quatern, quatern) :: quatern
  def add(lhs, rhs) do
    {w, x, y, z} = lhs
    {a, b, c, d} = rhs

    {w + a, x + b, y + c, z + d}
  end

  @doc """
  `subtract(lhs, rhs)` subtract two quaternions.

   `lhs` is the first `quatern`

   `rhs` is the second `quatern`

   It returns a `quatern` of the form { lhs<sub>w</sub> - rhs<sub>w</sub>, lhs<sub>x</sub> - rhs<sub>x</sub>, lhs<sub>y</sub> - rhs<sub>y</sub>, lhs<sub>z</sub> - rhs<sub>z</sub> }.
  """
  @spec subtract(quatern, quatern) :: quatern
  def subtract(lhs, rhs) do
    {w, x, y, z} = lhs
    {a, b, c, d} = rhs

    {w - a, x - b, y - c, z - d}
  end

  @doc """
  `multiply(lhs, rhs)` multiply two quaternions.

   `lhs` is the first `quatern`

   `rhs` is the second `quatern`

   It returns a `quatern` resultant of the multiplication
   NOTE: Multiplication is not generally commutative, so in most cases p*q != q*p.
  """
  @spec multiply(quatern, quatern) :: quatern
  def multiply(lhs, rhs) do
    {w, x, y, z} = lhs
    {a, b, c, d} = rhs

    {w * a - x * b - y * c - z * d, w * b + x * a + y * d - z * c, w * c + y * a + z * b - x * d,
     w * d + z * a + x * c - y * b}
  end

  @doc """
  `scale(quat, scalar)` multiply a `quatern` for a scalar.

   `quat` is the `quatern`

   `scalar` is the scalar

   It returns a `quatern` of the form
      { a<sub>w</sub> * scalar, a<sub>x</sub> * scalar, a<sub>y</sub> * scalar, a<sub>z</sub> * scalar}.
  """
  @spec scale(quatern, float) :: quatern
  def scale(quat, scalar) do
    {w, x, y, z} = quat

    {w * scalar, x * scalar, y * scalar, z * scalar}
  end

  @doc """
  `roll(quat)` Calculate the local roll element of a quaternion.

  `quat` is the quatern

  It returns a `float` representing the roll of the quaternion in Radians.
  """
  @spec get_roll(quatern) :: float
  def get_roll(quat) do
    {w, x, y, z} = quat

    f_t_y = 2.0 * y
    f_t_z = 2.0 * z
    f_t_wz = f_t_z * w
    f_t_xy = f_t_y * x
    f_t_yy = f_t_y * y
    f_t_zz = f_t_z * z

    :math.atan2(f_t_xy + f_t_wz, 1.0 - (f_t_yy + f_t_zz))
  end

  @doc """
  `pitch(quat)` Calculate the local pitch element of a quaternion.

  `quat` is the quatern

  It returns a `float` representing the pitch of the quaternion in Radians.
  """
  @spec get_pitch(quatern) :: float
  def get_pitch(quat) do
    {w, x, y, z} = quat

    f_t_x = 2.0 * x
    f_t_z = 2.0 * z
    f_t_wx = f_t_x * w
    f_t_xx = f_t_x * x
    f_t_yz = f_t_z * y
    f_t_zz = f_t_z * z

    :math.atan2(f_t_yz + f_t_wx, 1.0 - (f_t_xx + f_t_zz))
  end

  @doc """
  `yaw(quat)` Calculate the local yaw element of a quaternion.

  `quat` is the quatern

  It returns a `float` representing the yaw of the quaternion in Radians.
  """
  @spec get_yaw(quatern) :: float
  def get_yaw(quat) do
    {w, x, y, z} = quat

    f_t_x = 2.0 * x
    f_t_y = 2.0 * y
    f_t_z = 2.0 * z
    f_t_wy = f_t_y * w
    f_t_xx = f_t_x * x
    f_t_xz = f_t_z * x
    f_t_yy = f_t_y * y

    :math.atan2(f_t_xz + f_t_wy, 1.0 - (f_t_xx + f_t_yy))
  end

  @doc """
  `from_rotation_matrix(mat)` creates a `quatern` from a rotation matrix.

  `mat` is the matrix

  It returns a `quatern` of the form `{w,x,y,z}`.
  """
  @spec from_rotation_matrix(mat33) :: quatern
  def from_rotation_matrix(mat) do
    {a11, a12, a13, a21, a22, a23, a31, a32, a33} = mat

    # Why does the trace matter? Consult here:
    # http://www.euclideanspace.com/maths/geometry/rotations/conversions/matrixToQuaternion/
    f_trace = a11 + a22 + a33

    if f_trace > 0.0 do
      f_root = :math.sqrt(f_trace + 1.0)
      w = 0.5 * f_root
      f_root = 0.5 / f_root
      {w, (a32 - a23) * f_root, (a13 - a31) * f_root, (a21 - a12) * f_root}
    else
      i_next = {1, 2, 0}

      i =
        cond do
          a22 > a11 and a33 > Mat33.at(mat, 1, 1) -> 2
          a33 > Mat33.at(mat, 0, 0) -> 2
          true -> 0
        end

      j = elem(i_next, i)
      k = elem(i_next, j)

      f_root = :math.sqrt(Mat33.at(mat, i, i) - Mat33.at(mat, j, j) - Mat33.at(mat, k, k) + 1.0)
      apk_quat = {0.0, 0.0, 0.0}
      apk_quat = put_elem(apk_quat, i, 0.5 * f_root)
      f_root = 0.5 / f_root
      apk_quat = put_elem(apk_quat, j, (Mat33.at(mat, j, i) + Mat33.at(mat, i, j)) * f_root)
      apk_quat = put_elem(apk_quat, k, (Mat33.at(mat, k, i) + Mat33.at(mat, i, k)) * f_root)

      {x, y, z} = apk_quat

      {x, y, z, (Mat33.at(mat, k, j) - Mat33.at(mat, j, k)) * f_root}
    end
  end

  @doc """
  `to_rotation_matrix_33(quat)` creates a `mat33` from a quatern.

  `quat` is the quatern

  It returns a `mat33` representing a rotation.
  """
  @spec to_rotation_matrix_33(quatern) :: mat33
  def to_rotation_matrix_33(quat) do
    {w, x, y, z} = quat
    f_tx = x + x
    f_ty = y + y
    f_tz = z + z
    f_t_wx = f_tx * w
    f_t_wy = f_ty * w
    f_t_wz = f_tz * w
    f_t_xx = f_tx * x
    f_t_xy = f_ty * x
    f_t_xz = f_tz * x
    f_t_yy = f_ty * y
    f_t_yz = f_tz * y
    f_t_zz = f_tz * z

    a11 = 1.0 - (f_t_yy + f_t_zz)
    a12 = f_t_xy - f_t_wz
    a13 = f_t_xz + f_t_wy
    a21 = f_t_xy + f_t_wz
    a22 = 1.0 - (f_t_xx + f_t_zz)
    a23 = f_t_yz - f_t_wx
    a31 = f_t_xz - f_t_wy
    a32 = f_t_yz + f_t_wx
    a33 = 1.0 - (f_t_xx + f_t_yy)

    {a11, a12, a13, a21, a22, a23, a31, a32, a33}
  end

  @doc """
  `to_rotation_matrix_44(quat)` creates a `mat44` from a quatern.

  `quat` is the quatern

  It returns a `mat44` representing a rotation.
  """
  @spec to_rotation_matrix_44(quatern) :: mat44
  def to_rotation_matrix_44(quat) do
    {w, x, y, z} = quat
    f_tx = x + x
    f_ty = y + y
    f_tz = z + z
    f_t_wx = f_tx * w
    f_t_wy = f_ty * w
    f_t_wz = f_tz * w
    f_t_xx = f_tx * x
    f_t_xy = f_ty * x
    f_t_xz = f_tz * x
    f_t_yy = f_ty * y
    f_t_yz = f_tz * y
    f_t_zz = f_tz * z

    a11 = 1.0 - (f_t_yy + f_t_zz)
    a12 = f_t_xy - f_t_wz
    a13 = f_t_xz + f_t_wy
    a21 = f_t_xy + f_t_wz
    a22 = 1.0 - (f_t_xx + f_t_zz)
    a23 = f_t_yz - f_t_wx
    a31 = f_t_xz - f_t_wy
    a32 = f_t_yz + f_t_wx
    a33 = 1.0 - (f_t_xx + f_t_yy)

    {a11, a12, a13, 0.0, a21, a22, a23, 0.0, a31, a32, a33, 0.0, 0.0, 0.0, 0.0, 1.0}
  end

  @doc """
  `dot(lhs, rhs)` returns a `float` resultant of the dot product bectween two quaterns.

  `lhs` is a quatern

  `rhs` is a quatern

  It returns a `float` representing the dot product.
  """
  @spec dot(quatern, quatern) :: float
  def dot(lhs, rhs) do
    {w, x, y, z} = lhs
    {a, b, c, d} = rhs

    w * a + x * b + y * c + z * d
  end

  @doc """
  `norm(quat)` Returns the L2 norm of a quaternion.

  `quat` is a `quatern` to find the norm of.

  It returns a `float` representing the L2 norm.
  """
  @spec norm(quatern) :: float
  def norm(quat) do
    {w, x, y, z} = quat
    :math.sqrt(w * w + x * x + y * y + z * z)
  end

  @doc """
  `normalize_strict(q)` returns a normalized verison of a quaternion.

  `q` is the `quatern` to be normalized.

  This returns a `quatern` of unit length in the same direction as `q`.

  If the magnitude of the quaternion is 0, it will explode.
  """
  @spec normalize_strict(quatern) :: quatern
  def normalize_strict({w, x, y, z} = _q) do
    inv_mag = 1.0 / :math.sqrt(w * w + x * x + y * y + z * z)
    {w * inv_mag, x * inv_mag, y * inv_mag, z * inv_mag}
  end

  @doc """
  `normalize(q)` returns a normalized verison of a quaternion.

  `q` is the `quatern` to be normalized.

  This returns a `quatern` of unit length in the same direction as `q`.

  If the magnitude of the quaternion is 0, it will return the zero quaternion.
  """
  @spec normalize(quatern) :: quatern
  def normalize({w, x, y, z} = _q) do
    mag = :math.sqrt(w * w + x * x + y * y + z * z)

    if mag > 0 do
      inv_mag = 1.0 / :math.sqrt(w * w + x * x + y * y + z * z)
      {w * inv_mag, x * inv_mag, y * inv_mag, z * inv_mag}
    else
      {0.0, 0.0, 0.0, 0.0}
    end
  end

  @doc """
  `inverse(quat)` returns the inverse of a quaternion.

  `quat` is the quaternion

  It returns a `quatern` representing the inverse of the parameter quaternion.

  If the `quat` is less than or equal to zero, the quaternion returned is a zero quaternion.
  """
  @spec inverse(quatern) :: quatern
  def inverse(quat) do
    {w, x, y, z} = quat

    f_norm = w * w + x * x + y * y + z * z

    if f_norm > 0.0 do
      f_inv_norm = 1.0 / f_norm
      {w * f_inv_norm, -x * f_inv_norm, -y * f_inv_norm, -z * f_inv_norm}
    else
      {0.0, 0.0, 0.0, 0.0}
    end
  end

  @doc """
  `conjugate(quat)` returns the conjugate of a quaternion.

  `quat` is the quaternion to get the conjugate of.

  It returns a `quatern` representing the inverse of the unit quatern.

  Note that the conjugate of a unit quaternion is its inverse.
  """
  @spec conjugate(quatern) :: quatern
  def conjugate(quat) do
    {w, x, y, z} = quat
    {w, -x, -y, -z}
  end

  @doc """
  `slerp(lhs, rhs, t)` Performs Spherical linear interpolation between two quaternions, and returns the result.

  `lhs` is the first `quatern`

  `rhs` is the second `quatern`

  `t` is the interpolation parameter that will interpolate to `lhs` when `t = 0` and to `rhs` when `t = 1`.

  It returns a `quatern` representing the normalized interpolation point.

  Note: `slerp` has the proprieties of performing the interpolation at constant velocity However, it's NOT commutative, which means
  `slerp( A, B, 0.75 ) != slerp( B, A, 0.25 )`
  therefore be careful if your code relies in the order of the operands.
  This is specially important in IK animation.
  """
  @spec slerp(quatern, quatern, float) :: quatern
  def slerp(lhs, rhs, t) do
    f_cos = dot(lhs, rhs)

    # There are two situations:
    # 1. "rhs" and "lhs" are very close (fCos ~= +1), so we can do a linear
    #    interpolation safely.
    # 2. "rhs" and "lhs" are almost inverse of each other (fCos ~= -1), there
    #    are an infinite number of possibilities interpolation. but we haven't
    #    have method to fix this case, so just use linear interpolation here.

    if abs(f_cos) < 1 - 1.0e-03 do
      f_sin = :math.sqrt(1 - f_cos * f_cos)
      f_angle = :math.atan2(f_sin, f_cos)
      f_inv_sin = 1.0 / f_sin
      f_coeff0 = :math.sin((1.0 - t) * f_angle) * f_inv_sin
      f_coeff1 = :math.sin(t * f_angle) * f_inv_sin
      normalize(add(scale(lhs, f_coeff0), scale(rhs, f_coeff1)))
    else
      r = add(scale(lhs, 1.0 - t), scale(rhs, t))
      # taking the complement requires renormalisation
      normalize(r)
    end
  end

  @doc """
  `transform_vector(q,v)` transforms a vector v by an orientation quaternion q.

  `q` is an orientation quaternion.

  `v` is a Vec3 to transform--it need not be normalized.

  It returns a `Vec3` of `v` having undergone the rotation represented by `q`.
  """
  @spec transform_vector(quatern, vec3) :: vec3
  def transform_vector({qw, qx, qy, qz}, {vx, vy, vz}) do
    # v' = qvq', but we'll use the rediscovered formula of rodrigues answer from SO ( https://gamedev.stackexchange.com/a/50545 )

    dot_uv = qx * vx + qy * vy + qz * vz
    two_dot_uv = 2.0 * dot_uv
    dot_uu = qx * qx + qy * qy + qz * qz
    v_scalar = qw * qw - dot_uu
    two_qw = 2.0 * qw

    {
      two_dot_uv * qx + v_scalar * vx + two_qw * (qy * vz - qz * vy),
      two_dot_uv * qy + v_scalar * vy + two_qw * (qz * vx - qx * vz),
      two_dot_uv * qz + v_scalar * vz + two_qw * (qx * vy - qy * vx)
    }
  end

  @doc """
  `integrate(q, omega, dt)` integrates the angular velocty omega over a timestep dt with intial orientation q.

  `q` is an orientation quaternion to use as the initial orientation.

  `omega` is a `vec3` whose direction is the axis of rotation and whose magnitude is the velocity about that axis.

  `dt` is the timestep over which to apply the angular velocity.

  It returns an orientation `quatern`.
  """
  @spec integrate(quatern, vec3, number) :: quatern
  def integrate(q, omega, dt) do
    # this routine inspired and adapted from http://physicsforgames.blogspot.com/2010/02/quaternions.html
    # this explains a similar routine in cannon.js

    # get convert angular velocity vector to actual angular displacement by integrating time
    {theta_x, theta_y, theta_z} = theta = Graphmath.Vec3.scale(omega, 0.5 * dt)
    theta_magnitude_squared = Graphmath.Vec3.length_squared(theta)

    # use small-angle approximation for sin/cos if the magnitude is too small
    {delta_q_w, s} =
      if theta_magnitude_squared * theta_magnitude_squared / 24.0 < @machine_small_float do
        # use the more stable Taylor series for low-angle appromixations to sin/cos
        {1.0 - theta_magnitude_squared / 2.0, 1.0 - theta_magnitude_squared / 6.0}
      else
        # we're not too small! use real sin/cos
        theta_magnitude = :math.sqrt(theta_magnitude_squared)
        {:math.cos(theta_magnitude), :math.sin(theta_magnitude) / theta_magnitude}
      end

    multiply({delta_q_w, theta_x * s, theta_y * s, theta_z * s}, q)
    |> normalize()
  end

  @doc """
  Genrate a random quatenrion (rotation on SO3), using the algorithm given [here](http://planning.cs.uiuc.edu/node198.html).

  It returns an orientation `quatern`.
  """
  @spec random() :: quatern
  def random() do
    u1 = :rand.uniform()
    u2 = :rand.uniform()
    u3 = :rand.uniform()

    sqrtomu1 = :math.sqrt(1.0 - u1)
    sqrtu1 = :math.sqrt(u1)
    pi = :math.pi()
    s2pu2 = :math.sin(2.0 * pi * u2)
    c2pu2 = :math.cos(2.0 * pi * u2)
    s2pu3 = :math.sin(2.0 * pi * u3)
    c2pu3 = :math.cos(2.0 * pi * u3)

    {sqrtomu1 * s2pu2, sqrtomu1 * c2pu2, sqrtu1 * s2pu3, sqrtu1 * c2pu3}
  end
end
