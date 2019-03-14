defmodule Graphmath.Mat44 do
  @moduledoc """
  This is the 3D mathematics library for graphmath.

  This submodule handles 4x4 matrices using tuples of floats.
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
  def identity() do
    {1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0}
  end

  @doc """
  `zero()` creates a zeroed `mat44`.

  This returns a zeroed `mat44`.
  """
  @spec zero() :: mat44
  def zero() do
    {0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0}
  end

  @doc """
  `add(a,b)` adds one `mat44` to another `mat44`.

  `a` is the first `mat44`.

  `b` is the second `mat44`.

  This returns a `mat44` which is the element-wise sum of `a` and `b`.
  """
  @spec add(mat44, mat44) :: mat44
  def add(a, b) do
    {a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44} = a

    {b11, b12, b13, b14, b21, b22, b23, b24, b31, b32, b33, b34, b41, b42, b43, b44} = b

    {a11 + b11, a12 + b12, a13 + b13, a14 + b14, a21 + b21, a22 + b22, a23 + b23, a24 + b24,
     a31 + b31, a32 + b32, a33 + b33, a34 + b34, a41 + b41, a42 + b42, a43 + b43, a44 + b44}
  end

  @doc """
  `subtract(a,b)` subtracts one `mat44` from another `mat44`.

  `a` is the minuend.

  `b` is the subtraherd.

  This returns a `mat44` formed by the element-wise subtraction of `b` from `a`.
  """
  @spec subtract(mat44, mat44) :: mat44
  def subtract(a, b) do
    {a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44} = a

    {b11, b12, b13, b14, b21, b22, b23, b24, b31, b32, b33, b34, b41, b42, b43, b44} = b

    {a11 - b11, a12 - b12, a13 - b13, a14 - b14, a21 - b21, a22 - b22, a23 - b23, a24 - b24,
     a31 - b31, a32 - b32, a33 - b33, a34 - b34, a41 - b41, a42 - b42, a43 - b43, a44 - b44}
  end

  @doc """
  `scale( a, k )` scales every element in a `mat44` by a coefficient k.

  `a` is the `mat44` to scale.

  `k` is the float to scale by.

  This returns a `mat44` `a` scaled element-wise by `k`.
  """
  @spec scale(mat44, float) :: mat44
  def scale(a, k) do
    {a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44} = a

    {a11 * k, a12 * k, a13 * k, a14 * k, a21 * k, a22 * k, a23 * k, a24 * k, a31 * k, a32 * k,
     a33 * k, a34 * k, a41 * k, a42 * k, a43 * k, a44 * k}
  end

  @doc """
  `make_scale( k )` creates a `mat44` that uniformly scales.

  `k` is the float value to scale by.

  This returns a `mat44` whose diagonal is all `k`s.
  """
  @spec make_scale(float) :: mat44
  def make_scale(k) do
    {k, 0.0, 0.0, 0.0, 0.0, k, 0.0, 0.0, 0.0, 0.0, k, 0.0, 0.0, 0.0, 0.0, k}
  end

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
  def make_scale(sx, sy, sz, sw) do
    {sx, 0.0, 0.0, 0.0, 0.0, sy, 0.0, 0.0, 0.0, 0.0, sz, 0.0, 0.0, 0.0, 0.0, sw}
  end

  @doc """
  `make_translate( tx, ty, tz )` creates a mat44 that translates a point by tx, ty, and tz.

  `make_translate( tx, ty, tz )` creates a mat44 that translates a vec3 by (tx, ty, tz).

  `tx` is a float for translating along the x-axis.

  `ty` is a float for translating along the y-axis.

  `tz` is a float for translating along the z-axis.

  This returns a `mat44` which translates by a `vec3` `{ tx, ty, tz }`.
  """
  @spec make_translate(float, float, float) :: mat44
  def make_translate(tx, ty, tz) do
    {1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, tx, ty, tz, 1.0}
  end

  @doc """
  `make_rotate_x( theta )` creates a `mat44` that rotates a `vec3` by `theta` radians about the +X axis.

  `theta` is the float of the number of radians of rotation the matrix will provide.

  This returns a `mat44` which rotates by `theta` radians about the +X axis.
  """
  @spec make_rotate_x(float) :: mat44
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
  def make_rotate_y(theta) do
    st = :math.sin(theta)
    ct = :math.cos(theta)

    {ct, 0.0, st, 0.0, 0.0, 1.0, 0.0, 0.0, -st, 0.0, ct, 0.0, 0.0, 0.0, 0.0, 1.0}
  end

  @doc """
  `make_rotate_Z( theta )` creates a `mat44` that rotates a `vec3` by `theta` radians about the +Z axis.

  `theta` is the float of the number of radians of rotation the matrix will provide.

  This returns a `mat44` which rotates by `theta` radians about the +Z axis.
  """
  @spec make_rotate_z(float) :: mat44
  def make_rotate_z(theta) do
    st = :math.sin(theta)
    ct = :math.cos(theta)

    {ct, st, 0.0, 0.0, -st, ct, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0}
  end

  @doc """
  `round( a, sigfigs )` rounds every element of a `mat44` to some number of decimal places.

  `a` is the `mat44` to round.

  `sigfigs` is an integer on [0,15] of the number of decimal places to round to.

  This returns a `mat44` which is the result of rounding `a`.
  """
  @spec round(mat44, 0..15) :: mat44
  def round(a, sigfigs) do
    {a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44} = a

    {
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
  end

  @doc """
  `multiply( a, b )` multiply two matrices a and b together.

  `a` is the `mat44` multiplicand.

  `b` is the `mat44` multiplier.

  This returns the `mat44` product of the `a` and `b`.
  """
  @spec multiply(mat44, mat44) :: mat44
  def multiply(a, b) do
    {a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44} = a

    {b11, b12, b13, b14, b21, b22, b23, b24, b31, b32, b33, b34, b41, b42, b43, b44} = b

    {
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
  end

  @doc """
  `multiply_transpose( a, b )` multiply two matrices a and b<sup>T</sup> together.

  `a` is the `mat44` multiplicand.

  `b` is the `mat44` multiplier.

  This returns the `mat44` product of the `a` and `b`<sup>T</sup>.
  """
  @spec multiply_transpose(mat44, mat44) :: mat44
  def multiply_transpose(a, b) do
    {a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44} = a

    {b11, b21, b31, b41, b12, b22, b32, b42, b13, b23, b33, b43, b14, b24, b34, b44} = b

    {
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
  end

  @doc """
  `column0( a )` selects the first column of a `mat44`.

  `a` is the `mat44` to take the first column of.

  This returns a `vec4` representing the first column of `a`.
  """
  @spec column0(mat44) :: vec4
  def column0(a) do
    {a11, _, _, _, a21, _, _, _, a31, _, _, _, a41, _, _, _} = a

    {a11, a21, a31, a41}
  end

  @doc """
  `column1( a )` selects the second column of a `mat44`.

  `a` is the `mat44` to take the second column of.

  This returns a `vec4` representing the second column of `a`.
  """
  @spec column1(mat44) :: vec4
  def column1(a) do
    {_, a12, _, _, _, a22, _, _, _, a32, _, _, _, a42, _, _} = a

    {a12, a22, a32, a42}
  end

  @doc """
  `column2( a )` selects the third column of a `mat44`.

  `a` is the `mat44` to take the third column of.

  This returns a `vec4` representing the third column of `a`.
  """
  @spec column2(mat44) :: vec4
  def column2(a) do
    {_, _, a13, _, _, _, a23, _, _, _, a33, _, _, _, a43, _} = a

    {a13, a23, a33, a43}
  end

  @doc """
  `column3( a )` selects the fourth column of a `mat44`.

  `a` is the `mat44` to take the fourth column of.

  This returns a `vec4` representing the fourth column of `a`.
  """
  @spec column3(mat44) :: vec4
  def column3(a) do
    {_, _, _, a14, _, _, _, a24, _, _, _, a34, _, _, _, a44} = a

    {a14, a24, a34, a44}
  end

  @doc """
  `row0( a )` selects the first row of a `mat44`.

  `a` is the `mat44` to take the first row of.

  This returns a `vec4` representing the first row of `a`.
  """
  @spec row0(mat44) :: vec4
  def row0(a) do
    {a11, a12, a13, a14, _, _, _, _, _, _, _, _, _, _, _, _} = a

    {a11, a12, a13, a14}
  end

  @doc """
  `row1( a )` selects the second row of a `mat44`.

  `a` is the `mat44` to take the second row of.

  This returns a `vec4` representing the second row of `a`.
  """
  @spec row1(mat44) :: vec4
  def row1(a) do
    {_, _, _, _, a21, a22, a23, a24, _, _, _, _, _, _, _, _} = a

    {a21, a22, a23, a24}
  end

  @doc """
  `row2( a )` selects the third row of a `mat44`.

  `a` is the `mat44` to take the third row of.

  This returns a `vec4` representing the third row of `a`.
  """
  @spec row2(mat44) :: vec4
  def row2(a) do
    {_, _, _, _, _, _, _, _, a31, a32, a33, a34, _, _, _, _} = a

    {a31, a32, a33, a34}
  end

  @doc """
  `row3( a )` selects the fourth row of a `mat44`.

  `a` is the `mat44` to take the fourth row of.

  This returns a `vec4` representing the fourth row of `a`.
  """
  @spec row3(mat44) :: vec4
  def row3(a) do
    {_, _, _, _, _, _, _, _, _, _, _, _, a41, a42, a43, a44} = a

    {a41, a42, a43, a44}
  end

  @doc """
  `diag( a )` selects the diagonal of a `mat44`.

  `a` is the `mat44` to take the diagonal of.

  This returns a `vec4` representing the diagonal of `a`.
  """
  @spec diag(mat44) :: vec4
  def diag(a) do
    {a11, _, _, _, _, a22, _, _, _, _, a33, _, _, _, _, a44} = a

    {a11, a22, a33, a44}
  end

  @doc """
  `at( a, i, j)` selects an element of a `mat44`.

  `a` is the `mat44` to index.

  `i` is the row integer index [0,3].

  `j` is the column integer index [0,3].

  This returns a float from the matrix at row `i` and column `j`.
  """
  @spec at(mat44, non_neg_integer, non_neg_integer) :: float
  def at(a, i, j) do
    elem(a, 4 * i + j)
  end

  @doc """
  `apply( a, v )` transforms a `vec4` by a `mat44`.

  `a` is the `mat44` to transform by.

  `v` is the `vec4` to be transformed.

  This returns a `vec4` representing **A****v**.

  This is the "full" application of a matrix, and uses all elements.
  """
  @spec apply(mat44, vec4) :: vec4
  def apply(a, v) do
    {a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44} = a

    {x, y, z, w} = v

    {
      a11 * x + a12 * y + a13 * z + a14 * w,
      a21 * x + a22 * y + a23 * z + a24 * w,
      a31 * x + a32 * y + a33 * z + a34 * w,
      a41 * x + a42 * y + a43 * z + a44 * w
    }
  end

  @doc """
  `apply_transpose( a, v )` transforms a `vec4` by a a transposed `mat44`.

  `a` is the `mat44` to transform by.

  `v` is the `vec4` to be transformed.

  This returns a `vec4` representing **A**<sup>T</sup>**v**.

  This is the "full" application of a matrix, and uses all elements.
  """
  @spec apply_transpose(mat44, vec4) :: vec4
  def apply_transpose(a, v) do
    {a11, a21, a31, a41, a12, a22, a32, a42, a13, a23, a33, a43, a14, a24, a34, a44} = a

    {x, y, z, w} = v

    {
      a11 * x + a12 * y + a13 * z + a14 * w,
      a21 * x + a22 * y + a23 * z + a24 * w,
      a31 * x + a32 * y + a33 * z + a34 * w,
      a41 * x + a42 * y + a43 * z + a44 * w
    }
  end

  @doc """
  `apply_left( v, a )` transforms a `vec4` by a `mat44`, applied on the left.

  `a` is the `mat44` to transform by.

  `v` is the `vec4` to be transformed.

  This returns a `vec4` representing **v****A**.

  This is the "full" application of a matrix, and uses all elements.
  """
  @spec apply_left(vec4, mat44) :: vec4
  def apply_left(v, a) do
    {a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44} = a

    {x, y, z, w} = v

    {
      a11 * x + a21 * y + a31 * z + a41 * w,
      a12 * x + a22 * y + a32 * z + a42 * w,
      a13 * x + a23 * y + a33 * z + a43 * w,
      a14 * x + a24 * y + a34 * z + a44 * w
    }
  end

  @doc """
  `apply_left_transpose( v, a )` transforms a `vec3` by a transposed `mat33`, applied on the left.

  `a` is the `mat44` to transform by.

  `v` is the `vec4` to be transformed.

  This returns a `vec4` representing **v****A**<sup>T</sup>.

  This is the "full" application of a matrix, and uses all elements.
  """
  @spec apply_left_transpose(vec4, mat44) :: vec4
  def apply_left_transpose(v, a) do
    {a11, a21, a31, a41, a12, a22, a32, a42, a13, a23, a33, a43, a14, a24, a34, a44} = a

    {x, y, z, w} = v

    {
      a11 * x + a21 * y + a31 * z + a41 * w,
      a12 * x + a22 * y + a32 * z + a42 * w,
      a13 * x + a23 * y + a33 * z + a43 * w,
      a14 * x + a24 * y + a34 * z + a44 * w
    }
  end

  @doc """
  `transform_point( a, v )` transforms a `vec3` point by a `mat44`.

  `a` is a `mat44` used to transform the point.

  `v` is a `vec3` to be transformed.

  This returns a `vec3` representing the application of `a` to `v`.

  The point `a` is internally treated as having a fourth coordinate equal to 1.0.

  Note that transforming a point will work for all transforms.
  """
  @spec transform_point(mat44, vec3) :: vec3
  def transform_point(a, v) do
    {a11, a21, a31, _, a12, a22, a32, _, a13, a23, a33, _, a14, a24, a34, _} = a

    {x, y, z} = v

    {
      a11 * x + a12 * y + a13 * z + a14,
      a21 * x + a22 * y + a23 * z + a24,
      a31 * x + a32 * y + a33 * z + a34
    }
  end

  @doc """
  `transform_vector( a, v )` transforms a `vec3` vector by a `mat44`.

  `a` is a `mat44` used to transform the point.

  `v` is a `vec3` to be transformed.

  This returns a `vec3` representing the application of `a` to `v`.

  The point `a` is internally treated as having a fourth coordinate equal to 0.0.

  Note that transforming a vector will work for only rotations, scales, and shears.
  """
  @spec transform_vector(mat44, vec3) :: vec3
  def transform_vector(a, v) do
    {a11, a21, a31, _, a12, a22, a32, _, a13, a23, a33, _, _, _, _, _} = a

    {x, y, z} = v

    {
      a11 * x + a12 * y + a13 * z,
      a21 * x + a22 * y + a23 * z,
      a31 * x + a32 * y + a33 * z
    }
  end

  @doc """
  `inverse(a)` calculates the inverse matrix

  `a` is a `mat44` to be inverted

  Returs a `mat44` representing `a`<sup>-1</sup>

  Raises an error when you try to calculate inverse of a matrix whose determinant is `zero`
  """
  @spec inverse(mat44) :: mat44
  def inverse(a) do
    {m00, m01, m02, m03, m10, m11, m12, m13, m20, m21, m22, m23, m30, m31, m32, m33} = a

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
