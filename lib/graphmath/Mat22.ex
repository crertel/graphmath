defmodule Graphmath.Mat22 do
  @moduledoc """
  2x2 matrices and linear transformations of 2D vectors.

  Matrices store rows in a flat tuple `{a11, a12, a21, a22}`:

  ```text
  a11  a12
  a21  a22
  ```

  The matrix and vector types use floating-point entries. Integer and mixed
  numeric inputs are also accepted, following Elixir's numeric promotion rules;
  `round/2` and `inverse/1` return floats.

  As in `Graphmath.Mat33`, `apply(a, v)` computes the column-vector product
  **A****v**. Graphics constructors use row vectors: `transform_vector(a, v)`
  and `apply_left(v, a)` compute **v****A**, as does `apply_transpose(a, v)`.
  For row vectors, `multiply(a, b)` applies `a` first, then `b`.

  These matrices support scale, rotation, reflection, and shear. Use
  `Graphmath.Mat33` for 2D transformations that also include translation.
  """

  @type mat22 :: {float, float, float, float}
  @type vec2 :: {float, float}

  @doc """
  Returns the identity matrix `{1.0, 0.0, 0.0, 1.0}`.
  """
  @spec identity() :: mat22
  def identity(), do: {1.0, 0.0, 0.0, 1.0}

  @doc """
  Returns the zero matrix `{0.0, 0.0, 0.0, 0.0}`.
  """
  @spec zero() :: mat22
  def zero(), do: {0.0, 0.0, 0.0, 0.0}

  @doc """
  Adds corresponding entries of `a` and `b`.
  """
  @spec add(mat22, mat22) :: mat22
  def add({a11, a12, a21, a22}, {b11, b12, b21, b22})
      when is_float(a11) and is_float(a12) and is_float(a21) and is_float(a22) and
             is_float(b11) and is_float(b12) and is_float(b21) and is_float(b22),
      do: {a11 + b11, a12 + b12, a21 + b21, a22 + b22}

  def add({a11, a12, a21, a22}, {b11, b12, b21, b22}),
    do: {a11 + b11, a12 + b12, a21 + b21, a22 + b22}

  @doc """
  Subtracts each entry of `b` from the corresponding entry of `a`.
  """
  @spec subtract(mat22, mat22) :: mat22
  def subtract({a11, a12, a21, a22}, {b11, b12, b21, b22})
      when is_float(a11) and is_float(a12) and is_float(a21) and is_float(a22) and
             is_float(b11) and is_float(b12) and is_float(b21) and is_float(b22),
      do: {a11 - b11, a12 - b12, a21 - b21, a22 - b22}

  def subtract({a11, a12, a21, a22}, {b11, b12, b21, b22}),
    do: {a11 - b11, a12 - b12, a21 - b21, a22 - b22}

  @doc """
  Multiplies every entry of `a` by the scalar `k`.
  """
  @spec scale(mat22, float) :: mat22
  def scale({a11, a12, a21, a22}, k)
      when is_float(a11) and is_float(a12) and is_float(a21) and is_float(a22) and is_float(k),
      do: {a11 * k, a12 * k, a21 * k, a22 * k}

  def scale({a11, a12, a21, a22}, k), do: {a11 * k, a12 * k, a21 * k, a22 * k}

  @doc """
  Returns a matrix that uniformly scales both vector coordinates by `k`.
  """
  @spec make_scale(float) :: mat22
  def make_scale(k) when is_float(k), do: {k, 0.0, 0.0, k}
  def make_scale(k), do: {k, 0.0, 0.0, k}

  @doc """
  Returns a matrix that scales X by `sx` and Y by `sy`.
  """
  @spec make_scale(float, float) :: mat22
  def make_scale(sx, sy) when is_float(sx) and is_float(sy), do: {sx, 0.0, 0.0, sy}
  def make_scale(sx, sy), do: {sx, 0.0, 0.0, sy}

  @doc """
  Returns a matrix that rotates row vectors counterclockwise by `theta` radians
  about +Z. Apply it with `transform_vector/2` or `apply_left/2`.
  """
  @spec make_rotate(float) :: mat22
  def make_rotate(theta) when is_float(theta) do
    ct = :math.cos(theta)
    st = :math.sin(theta)
    {ct, st, -st, ct}
  end

  def make_rotate(theta) do
    ct = :math.cos(theta)
    st = :math.sin(theta)
    {ct, st, -st, ct}
  end

  @doc """
  Creates a 2D linear reflection across the line through the origin
  with normal `{nx, ny}`.

  The normal may have any nonzero length; a zero normal raises `ArithmeticError`.
  Apply using `transform_vector/2` with a full 2-component vector.
  """
  @spec make_reflect(vec2) :: mat22
  def make_reflect({nx, ny})
      when is_float(nx) and is_float(ny) do
    scale = max(abs(nx), abs(ny))
    ux = nx / scale
    uy = ny / scale
    factor = 2.0 / (ux * ux + uy * uy)
    {1.0 - factor * ux * ux, -factor * ux * uy, -factor * uy * ux, 1.0 - factor * uy * uy}
  end

  def make_reflect({nx, ny}) do
    scale = max(abs(nx), abs(ny))
    ux = nx / scale
    uy = ny / scale
    factor = 2.0 / (ux * ux + uy * uy)
    {1.0 - factor * ux * ux, -factor * ux * uy, -factor * uy * ux, 1.0 - factor * uy * uy}
  end

  @doc """
  Creates a 2D linear X shear: `x' = x + k*y`.

  The other spatial coordinates are unchanged.
  Apply using `transform_vector/2` with a full 2-component vector.
  """
  @spec make_shear_x(float) :: mat22
  def make_shear_x(k)
      when is_float(k) do
    {1.0, 0.0, k, 1.0}
  end

  def make_shear_x(k) do
    {1.0, 0.0, 1.0 * k, 1.0}
  end

  @doc """
  Creates a 2D linear Y shear: `y' = y + k*x`.

  The other spatial coordinates are unchanged.
  Apply using `transform_vector/2` with a full 2-component vector.
  """
  @spec make_shear_y(float) :: mat22
  def make_shear_y(k)
      when is_float(k) do
    {1.0, k, 0.0, 1.0}
  end

  def make_shear_y(k) do
    {1.0, 1.0 * k, 0.0, 1.0}
  end

  @doc """
  Rounds every entry to `sigfigs` decimal places, returning floats.

  `sigfigs` must be an integer from 0 through 15, as required by `Float.round/2`.
  """
  @spec round(mat22, 0..15) :: mat22
  def round({a11, a12, a21, a22}, sigfigs)
      when is_float(a11) and is_float(a12) and is_float(a21) and is_float(a22) and
             is_integer(sigfigs) and sigfigs >= 0 and sigfigs <= 15,
      do: {
        Float.round(a11, sigfigs),
        Float.round(a12, sigfigs),
        Float.round(a21, sigfigs),
        Float.round(a22, sigfigs)
      }

  def round({a11, a12, a21, a22}, sigfigs),
    do: {
      Float.round(1.0 * a11, sigfigs),
      Float.round(1.0 * a12, sigfigs),
      Float.round(1.0 * a21, sigfigs),
      Float.round(1.0 * a22, sigfigs)
    }

  @doc """
  Returns the matrix product **A****B**.
  """
  @spec multiply(mat22, mat22) :: mat22
  def multiply({a11, a12, a21, a22}, {b11, b12, b21, b22})
      when is_float(a11) and is_float(a12) and is_float(a21) and is_float(a22) and
             is_float(b11) and is_float(b12) and is_float(b21) and is_float(b22),
      do: {
        a11 * b11 + a12 * b21,
        a11 * b12 + a12 * b22,
        a21 * b11 + a22 * b21,
        a21 * b12 + a22 * b22
      }

  def multiply({a11, a12, a21, a22}, {b11, b12, b21, b22}),
    do: {
      a11 * b11 + a12 * b21,
      a11 * b12 + a12 * b22,
      a21 * b11 + a22 * b21,
      a21 * b12 + a22 * b22
    }

  @doc """
  Returns **A****B**<sup>T</sup>, multiplying `a` by the transpose of `b`.
  """
  @spec multiply_transpose(mat22, mat22) :: mat22
  def multiply_transpose({a11, a12, a21, a22}, {b11, b12, b21, b22})
      when is_float(a11) and is_float(a12) and is_float(a21) and is_float(a22) and
             is_float(b11) and is_float(b12) and is_float(b21) and is_float(b22),
      do: {
        a11 * b11 + a12 * b12,
        a11 * b21 + a12 * b22,
        a21 * b11 + a22 * b12,
        a21 * b21 + a22 * b22
      }

  def multiply_transpose({a11, a12, a21, a22}, {b11, b12, b21, b22}),
    do: {
      a11 * b11 + a12 * b12,
      a11 * b21 + a12 * b22,
      a21 * b11 + a22 * b12,
      a21 * b21 + a22 * b22
    }

  @doc """
  Returns the first column, `{a11, a21}`.
  """
  @spec column0(mat22) :: vec2
  def column0({a11, _, a21, _}) when is_float(a11) and is_float(a21), do: {a11, a21}
  def column0({a11, _, a21, _}), do: {a11, a21}

  @doc """
  Returns the second column, `{a12, a22}`.
  """
  @spec column1(mat22) :: vec2
  def column1({_, a12, _, a22}) when is_float(a12) and is_float(a22), do: {a12, a22}
  def column1({_, a12, _, a22}), do: {a12, a22}

  @doc """
  Returns the first row, `{a11, a12}`.
  """
  @spec row0(mat22) :: vec2
  def row0({a11, a12, _, _}) when is_float(a11) and is_float(a12), do: {a11, a12}
  def row0({a11, a12, _, _}), do: {a11, a12}

  @doc """
  Returns the second row, `{a21, a22}`.
  """
  @spec row1(mat22) :: vec2
  def row1({_, _, a21, a22}) when is_float(a21) and is_float(a22), do: {a21, a22}
  def row1({_, _, a21, a22}), do: {a21, a22}

  @doc """
  Returns the diagonal entries, `{a11, a22}`.
  """
  @spec diag(mat22) :: vec2
  def diag({a11, _, _, a22}) when is_float(a11) and is_float(a22), do: {a11, a22}
  def diag({a11, _, _, a22}), do: {a11, a22}

  @doc """
  Returns the entry at zero-based row `i` and column `j`.

  Both indices must be 0 or 1; invalid indices raise `FunctionClauseError`.
  """
  @spec at(mat22, 0..1, 0..1) :: float
  def at({_, _, _, _} = a, i, j) when i in 0..1 and j in 0..1,
    do: elem(a, 2 * i + j)

  @doc """
  Returns the column-vector product **A****v**.
  """
  @spec apply(mat22, vec2) :: vec2
  def apply({a11, a12, a21, a22}, {x, y})
      when is_float(a11) and is_float(a12) and is_float(a21) and is_float(a22) and
             is_float(x) and is_float(y),
      do: {a11 * x + a12 * y, a21 * x + a22 * y}

  def apply({a11, a12, a21, a22}, {x, y}),
    do: {a11 * x + a12 * y, a21 * x + a22 * y}

  @doc """
  Returns **A**<sup>T</sup>**v**, equivalent to `apply_left(v, a)`.
  """
  @spec apply_transpose(mat22, vec2) :: vec2
  def apply_transpose({a11, a12, a21, a22}, {x, y})
      when is_float(a11) and is_float(a12) and is_float(a21) and is_float(a22) and
             is_float(x) and is_float(y),
      do: {a11 * x + a21 * y, a12 * x + a22 * y}

  def apply_transpose({a11, a12, a21, a22}, {x, y}),
    do: {a11 * x + a21 * y, a12 * x + a22 * y}

  @doc """
  Returns the row-vector product **v****A**.
  """
  @spec apply_left(vec2, mat22) :: vec2
  def apply_left({x, y}, {a11, a12, a21, a22})
      when is_float(a11) and is_float(a12) and is_float(a21) and is_float(a22) and
             is_float(x) and is_float(y),
      do: {a11 * x + a21 * y, a12 * x + a22 * y}

  def apply_left({x, y}, {a11, a12, a21, a22}),
    do: {a11 * x + a21 * y, a12 * x + a22 * y}

  @doc """
  Returns **v****A**<sup>T</sup>, equivalent to `apply(a, v)`.
  """
  @spec apply_left_transpose(vec2, mat22) :: vec2
  def apply_left_transpose({x, y}, {a11, a12, a21, a22})
      when is_float(a11) and is_float(a12) and is_float(a21) and is_float(a22) and
             is_float(x) and is_float(y),
      do: {a11 * x + a12 * y, a21 * x + a22 * y}

  def apply_left_transpose({x, y}, {a11, a12, a21, a22}),
    do: {a11 * x + a12 * y, a21 * x + a22 * y}

  @doc """
  Transforms a 2D vector using the row-vector convention, computing **v****A**.

  This agrees with the scale and rotation constructors and is equivalent to
  `apply_left(v, a)`.
  """
  @spec transform_vector(mat22, vec2) :: vec2
  def transform_vector({a11, a12, a21, a22}, {x, y})
      when is_float(a11) and is_float(a12) and is_float(a21) and is_float(a22) and
             is_float(x) and is_float(y),
      do: {a11 * x + a21 * y, a12 * x + a22 * y}

  def transform_vector({a11, a12, a21, a22}, {x, y}),
    do: {a11 * x + a21 * y, a12 * x + a22 * y}

  @doc """
  Returns the trace, the sum of the diagonal entries `a11 + a22`.
  """
  @spec trace(mat22) :: float
  def trace({a11, _, _, a22}) when is_float(a11) and is_float(a22), do: a11 + a22
  def trace({a11, _, _, a22}), do: a11 + a22

  @doc """
  Returns the determinant, `a11 * a22 - a12 * a21`.
  """
  @spec determinant(mat22) :: float
  def determinant({a11, a12, a21, a22})
      when is_float(a11) and is_float(a12) and is_float(a21) and is_float(a22),
      do: a11 * a22 - a12 * a21

  def determinant({a11, a12, a21, a22}), do: a11 * a22 - a12 * a21

  @doc """
  Returns the inverse matrix, with floating-point entries.

  Raises `ArithmeticError` when the determinant is zero.
  """
  @spec inverse(mat22) :: mat22
  def inverse({a11, a12, a21, a22})
      when is_float(a11) and is_float(a12) and is_float(a21) and is_float(a22) do
    inv_det = 1.0 / (a11 * a22 - a12 * a21)
    {a22 * inv_det, -a12 * inv_det, -a21 * inv_det, a11 * inv_det}
  end

  def inverse({a11, a12, a21, a22}) do
    inv_det = 1.0 / (a11 * a22 - a12 * a21)
    {a22 * inv_det, -a12 * inv_det, -a21 * inv_det, a11 * inv_det}
  end
end
