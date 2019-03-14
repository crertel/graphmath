defmodule Graphmath.Mat33 do
  @moduledoc """
  This is the 3D mathematics library for graphmath.

  This submodule handles 3x3 matrices using tuples of floats.
  """

  @type mat33 :: {float, float, float, float, float, float, float, float, float}
  @type vec3 :: {float, float, float}
  @type vec2 :: {float, float}

  @doc """
  `identity()` creates an identity `mat33`.

  This returns an identity `mat33`.
  """
  @spec identity() :: mat33
  def identity() do
    {1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0}
  end

  @doc """
  `zero()` creates a zeroed `mat33`.

  This returns a zeroed `mat33`.
  """
  @spec zero() :: mat33
  def zero() do
    {0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0}
  end

  @doc """
  `add(a,b)` adds one `mat33` to another `mat33`.

  `a` is the first `mat33`.

  `b` is the second `mat33`.

  This returns a `mat33` which is the element-wise sum of `a` and `b`.
  """
  @spec add(mat33, mat33) :: mat33
  def add(a, b) do
    {a11, a12, a13, a21, a22, a23, a31, a32, a33} = a

    {b11, b12, b13, b21, b22, b23, b31, b32, b33} = b

    {a11 + b11, a12 + b12, a13 + b13, a21 + b21, a22 + b22, a23 + b23, a31 + b31, a32 + b32,
     a33 + b33}
  end

  @doc """
  `subtract(a,b)` subtracts one `mat33` from another `mat33`.

  `a` is the minuend.

  `b` is the subtraherd.

  This returns a `mat33` formed by the element-wise subtraction of `b` from `a`.
  """
  @spec subtract(mat33, mat33) :: mat33
  def subtract(a, b) do
    {a11, a12, a13, a21, a22, a23, a31, a32, a33} = a

    {b11, b12, b13, b21, b22, b23, b31, b32, b33} = b

    {a11 - b11, a12 - b12, a13 - b13, a21 - b21, a22 - b22, a23 - b23, a31 - b31, a32 - b32,
     a33 - b33}
  end

  @doc """
  `scale( a, k )` scales every element in a `mat33` by a coefficient k.

  `a` is the `mat33` to scale.

  `k` is the float to scale by.

  This returns a `mat33` `a` scaled element-wise by `k`.
  """
  @spec scale(mat33, float) :: mat33
  def scale(a, k) do
    {a11, a12, a13, a21, a22, a23, a31, a32, a33} = a

    {a11 * k, a12 * k, a13 * k, a21 * k, a22 * k, a23 * k, a31 * k, a32 * k, a33 * k}
  end

  @doc """
  `make_scale( k )` creates a `mat33` that uniformly scales.

  `k` is the float value to scale by.

  This returns a `mat33` whose diagonal is all `k`s.
  """
  @spec make_scale(float) :: mat33
  def make_scale(k) do
    {k, 0.0, 0.0, 0.0, k, 0.0, 0.0, 0.0, k}
  end

  @doc """
  `make_scale( sx, sy, sz )` creates a `mat33` that scales each axis independently.

  `sx` is a float for scaling the x-axis.

  `sy` is a float for scaling the y-axis.

  `sz` is a float for scaling the z-axis.

  This returns a `mat33` whose diagonal is `{ sx, sy, sz }`.

  Note that, when used with `vec2`s via the *transform* methods, `sz` will have no effect.
  """
  @spec make_scale(float, float, float) :: mat33
  def make_scale(sx, sy, sz) do
    {sx, 0.0, 0.0, 0.0, sy, 0.0, 0.0, 0.0, sz}
  end

  @doc """
  `make_translate( tx, ty )` creates a mat33 that translates a vec2 by (tx, ty).

  `tx` is a float for translating along the x-axis.

  `ty` is a float for translating along the y-axis.

  This returns a `mat33` which translates by a `vec2` `{ tx, ty }`.
  """
  @spec make_translate(float, float) :: mat33
  def make_translate(tx, ty) do
    {1.0, 0.0, 0.0, 0.0, 1.0, 0.0, tx, ty, 1.0}
  end

  @doc """
  `make_rotate( theta )` creates a mat33 that rotates a vec2 by `theta` radians about the +Z axis.

  `theta` is the float of the number of radians of rotation the matrix will provide.

  This returns a `mat33` which rotates by `theta` radians about the +Z axis.
  """
  @spec make_rotate(float) :: mat33
  def make_rotate(theta) do
    st = :math.sin(theta)
    ct = :math.cos(theta)

    {ct, st, 0.0, -st, ct, 0.0, 0.0, 0.0, 1.0}
  end

  @doc """
  `round( a, sigfigs )` rounds every element of a `mat33` to some number of decimal places.

  `a` is the `mat33` to round.

  `sigfigs` is an integer on [0,15] of the number of decimal places to round to.

  This returns a `mat33` which is the result of rounding `a`.
  """
  @spec round(mat33, 0..15) :: mat33
  def round(a, sigfigs) do
    {a11, a12, a13, a21, a22, a23, a31, a32, a33} = a

    {
      Float.round(1.0 * a11, sigfigs),
      Float.round(1.0 * a12, sigfigs),
      Float.round(1.0 * a13, sigfigs),
      Float.round(1.0 * a21, sigfigs),
      Float.round(1.0 * a22, sigfigs),
      Float.round(1.0 * a23, sigfigs),
      Float.round(1.0 * a31, sigfigs),
      Float.round(1.0 * a32, sigfigs),
      Float.round(1.0 * a33, sigfigs)
    }
  end

  @doc """
  `multiply( a, b )` multiply two matrices a and b together.

  `a` is the `mat33` multiplicand.

  `b` is the `mat33` multiplier.

  This returns the `mat33` product of the `a` and `b`.
  """
  @spec multiply(mat33, mat33) :: mat33
  def multiply(a, b) do
    {a11, a12, a13, a21, a22, a23, a31, a32, a33} = a

    {b11, b12, b13, b21, b22, b23, b31, b32, b33} = b

    {
      a11 * b11 + a12 * b21 + a13 * b31,
      a11 * b12 + a12 * b22 + a13 * b32,
      a11 * b13 + a12 * b23 + a13 * b33,
      a21 * b11 + a22 * b21 + a23 * b31,
      a21 * b12 + a22 * b22 + a23 * b32,
      a21 * b13 + a22 * b23 + a23 * b33,
      a31 * b11 + a32 * b21 + a33 * b31,
      a31 * b12 + a32 * b22 + a33 * b32,
      a31 * b13 + a32 * b23 + a33 * b33
    }
  end

  @doc """
  `multiply_transpose( a, b )` multiply two matrices a and b<sup>T</sup> together.

  `a` is the `mat33` multiplicand.

  `b` is the `mat33` multiplier.

  This returns the `mat33` product of the `a` and `b`<sup>T</sup>.
  """
  @spec multiply_transpose(mat33, mat33) :: mat33
  def multiply_transpose(a, b) do
    {a11, a12, a13, a21, a22, a23, a31, a32, a33} = a

    {b11, b21, b31, b12, b22, b32, b13, b23, b33} = b

    {
      a11 * b11 + a12 * b21 + a13 * b31,
      a11 * b12 + a12 * b22 + a13 * b32,
      a11 * b13 + a12 * b23 + a13 * b33,
      a21 * b11 + a22 * b21 + a23 * b31,
      a21 * b12 + a22 * b22 + a23 * b32,
      a21 * b13 + a22 * b23 + a23 * b33,
      a31 * b11 + a32 * b21 + a33 * b31,
      a31 * b12 + a32 * b22 + a33 * b32,
      a31 * b13 + a32 * b23 + a33 * b33
    }
  end

  @doc """
  `column0( a )` selects the first column of a `mat33`.

  `a` is the `mat33` to take the first column of.

  This returns a `vec3` representing the first column of `a`.
  """
  @spec column0(mat33) :: vec3
  def column0(a) do
    {a11, _, _, a21, _, _, a31, _, _} = a

    {a11, a21, a31}
  end

  @doc """
  `column1( a )` selects the second column of a `mat33`.

  `a` is the `mat33` to take the second column of.

  This returns a `vec3` representing the second column of `a`.
  """
  @spec column1(mat33) :: vec3
  def column1(a) do
    {_, a12, _, _, a22, _, _, a32, _} = a

    {a12, a22, a32}
  end

  @doc """
  `column2( a )` selects the third column of a `mat33`.

  `a` is the `mat33` to take the third column of.

  This returns a `vec3` representing the third column of `a`.
  """
  @spec column2(mat33) :: vec3
  def column2(a) do
    {_, _, a13, _, _, a23, _, _, a33} = a

    {a13, a23, a33}
  end

  @doc """
  `row0( a )` selects the first row of a `mat33`.

  `a` is the `mat33` to take the first row of.

  This returns a `vec3` representing the first row of `a`.
  """
  @spec row0(mat33) :: vec3
  def row0(a) do
    {a11, a12, a13, _, _, _, _, _, _} = a

    {a11, a12, a13}
  end

  @doc """
  `row1( a )` selects the second row of a `mat33`.

  `a` is the `mat33` to take the second row of.

  This returns a `vec3` representing the second row of `a`.
  """
  @spec row1(mat33) :: vec3
  def row1(a) do
    {_, _, _, a21, a22, a23, _, _, _} = a

    {a21, a22, a23}
  end

  @doc """
  `row2( a )` selects the third row of a `mat33`.

  `a` is the `mat33` to take the third row of.

  This returns a `vec3` representing the third row of `a`.
  """
  @spec row2(mat33) :: vec3
  def row2(a) do
    {_, _, _, _, _, _, a31, a32, a33} = a

    {a31, a32, a33}
  end

  @doc """
  `diag( a )` selects the diagonal of a `mat33`.

  `a` is the `mat33` to take the diagonal of.

  This returns a `vec3` representing the diagonal of `a`.
  """
  @spec diag(mat33) :: vec3
  def diag(a) do
    {a11, _, _, _, a22, _, _, _, a33} = a

    {a11, a22, a33}
  end

  @doc """
  `at( a, i, j)` selects an element of a `mat33`.

  `a` is the `mat33` to index.

  `i` is the row integer index [0,2].

  `j` is the column integer index [0,2].

  This returns a float from the matrix at row `i` and column `j`.
  """
  @spec at(mat33, non_neg_integer, non_neg_integer) :: float
  def at(a, i, j) do
    elem(a, 3 * i + j)
  end

  @doc """
  `apply( a, v )` transforms a `vec3` by a `mat33`.

  `a` is the `mat33` to transform by.

  `v` is the `vec3` to be transformed.

  This returns a `vec3` representing **A****v**.

  This is the "full" application of a matrix, and uses all elements.
  """
  @spec apply(mat33, vec3) :: vec3
  def apply(a, v) do
    {a11, a12, a13, a21, a22, a23, a31, a32, a33} = a

    {x, y, z} = v

    {
      a11 * x + a12 * y + a13 * z,
      a21 * x + a22 * y + a23 * z,
      a31 * x + a32 * y + a33 * z
    }
  end

  @doc """
  `apply_transpose( a, v )` transforms a `vec3` by a a transposed `mat33`.

  `a` is the `mat33` to transform by.

  `v` is the `vec3` to be transformed.

  This returns a `vec3` representing **A**<sup>T</sup>**v**.

  This is the "full" application of a matrix, and uses all elements.
  """
  @spec apply_transpose(mat33, vec3) :: vec3
  def apply_transpose(a, v) do
    {a11, a21, a31, a12, a22, a32, a13, a23, a33} = a

    {x, y, z} = v

    {
      a11 * x + a12 * y + a13 * z,
      a21 * x + a22 * y + a23 * z,
      a31 * x + a32 * y + a33 * z
    }
  end

  @doc """
  `apply_left( v, a )` transforms a `vec3` by a `mat33`, applied on the left.

  `a` is the `mat33` to transform by.

  `v` is the `vec3` to be transformed.

  This returns a `vec3` representing **v****A**.

  This is the "full" application of a matrix, and uses all elements.
  """
  @spec apply_left(vec3, mat33) :: vec3
  def apply_left(v, a) do
    {a11, a12, a13, a21, a22, a23, a31, a32, a33} = a

    {x, y, z} = v

    {
      a11 * x + a21 * y + a31 * z,
      a12 * x + a22 * y + a32 * z,
      a13 * x + a23 * y + a33 * z
    }
  end

  @doc """
  `apply_left_transpose( v, a )` transforms a `vec3` by a transposed `mat33`, applied on the left.

  `a` is the `mat33` to transform by.

  `v` is the `vec3` to be transformed.

  This returns a `vec3` representing **v****A**<sup>T</sup>.

  This is the "full" application of a matrix, and uses all elements.
  """
  @spec apply_left_transpose(vec3, mat33) :: vec3
  def apply_left_transpose(v, a) do
    {a11, a21, a31, a12, a22, a32, a13, a23, a33} = a

    {x, y, z} = v

    {
      a11 * x + a21 * y + a31 * z,
      a12 * x + a22 * y + a32 * z,
      a13 * x + a23 * y + a33 * z
    }
  end

  @doc """
  `transform_point( a, v )` transforms a `vec2` point by a `mat33`.

  `a` is a `mat33` used to transform the point.

  `v` is a `vec2` to be transformed.

  This returns a `vec2` representing the application of `a` to `v`.

  The point `a` is internally treated as having a third coordinate equal to 1.0.

  Note that transforming a point will work for all transforms.
  """
  @spec transform_point(mat33, vec2) :: vec2
  def transform_point(a, v) do
    {a11, a21, _, a12, a22, _, a13, a23, _} = a

    {x, y} = v

    {
      a11 * x + a12 * y + a13,
      a21 * x + a22 * y + a23
    }
  end

  @doc """
  `transform_vector( a, v )` transforms a `vec2` vector by a `mat33`.

  `a` is a `mat33` used to transform the point.

  `v` is a `vec2` to be transformed.

  This returns a `vec2` representing the application of `a` to `v`.

  The point `a` is internally treated as having a third coordinate equal to 0.0.

  Note that transforming a vector will work for only rotations, scales, and shears.
  """
  @spec transform_vector(mat33, vec2) :: vec2
  def transform_vector(a, v) do
    {a11, a21, _, a12, a22, _, _, _, _} = a

    {x, y} = v

    {
      a11 * x + a12 * y,
      a21 * x + a22 * y
    }
  end

  @doc """
  `inverse(a)` calculates the inverse matrix

  `a` is a `mat33` to be inverted

  Returs a `mat33` representing `a`<sup>-1</sup>

  Raises an error when you try to calculate inverse of a matrix whose determinant is `zero`
  """
  @spec inverse(mat33) :: mat33
  def inverse(a) do
    {a00, a01, a02, a10, a11, a12, a20, a21, a22} = a

    v00 = a11 * a22 - a12 * a21
    v01 = a02 * a21 - a01 * a22
    v02 = a01 * a12 - a02 * a11
    v10 = a12 * a20 - a10 * a22
    v11 = a00 * a22 - a02 * a20
    v12 = a02 * a10 - a00 * a12
    v20 = a10 * a21 - a11 * a20
    v21 = a01 * a20 - a00 * a21
    v22 = a00 * a11 - a01 * a10

    f_det = a00 * v00 + a01 * v10 + a02 * v20

    #        if fDet == 0, do: raise "Matrices with determinant equal to zero does not have inverse"

    f_inv_det = 1.0 / f_det

    {v00 * f_inv_det, v01 * f_inv_det, v02 * f_inv_det, v10 * f_inv_det, v11 * f_inv_det,
     v12 * f_inv_det, v20 * f_inv_det, v21 * f_inv_det, v22 * f_inv_det}
  end
end
