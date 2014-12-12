defmodule Graphmath.Mat33.Tuple do

    @moduledoc """
    This is the 3D mathematics library for graphmath.

    This submodule handles 3x3 matrices using tuples of floats.
    """

    @type mat33 :: { float, float, float,
                     float, float, float,
                     float, float, float }

    @doc"""
    `identity()` creates a 3x3 identity matrix.
    """
    @spec identity() :: mat33
    def identity() do
        { 1, 0, 0,
          0, 1, 0,
          0, 0, 1 }
    end

    @doc"""
    `zero()` creates a 3x3 zero matrix.
    """
    @spec zero() :: mat33
    def zero() do
        { 0, 0, 0,
          0, 0, 0,
          0, 0, 0 }
    end

    @doc"""
    `add(a,b)` adds one 3x3 matrix to another.
    """
    @spec add( mat33, mat33) :: mat33
    def add( a, b ) do
        { a11, a12, a13,
          a21, a22, a23,
          a31, a32, a33 } = a

        { b11, b12, b13,
          b21, b22, b23,
          b31, b32, b33 } = b

        { a11 + b11, a12 + b12, a13 + b13,
          a21 + b21, a22 + b22, a23 + b23,
          a31 + b31, a32 + b32, a33 + b33 }
    end
    
    @doc"""
    `subtract(a,b)` subtracts one 3x3 matrix from another..
    """
    @spec subtract( mat33, mat33) :: mat33
    def subtract( a, b ) do
        { a11, a12, a13,
          a21, a22, a23,
          a31, a32, a33 } = a

        { b11, b12, b13,
          b21, b22, b23,
          b31, b32, b33 } = b

        { a11 - b11, a12 - b12, a13 - b13,
          a21 - b21, a22 - b22, a23 - b23,
          a31 - b31, a32 - b32, a33 - b33 }
    end

    @doc"""
    `scale( a, k )` scales every element in a matrix a by coefficient k.
    """
    @spec scale( mat33, float) :: mat33
    def scale( a, k) do
        { a11, a12, a13,
          a21, a22, a23,
          a31, a32, a33 } = a

        { a11 * k, a12 * k, a13 * k,
          a21 * k, a22 * k, a23 * k,
          a31 * k, a32 * k, a33 * k }
    end

    @doc"""
    `multiply( a, b )` multiply two matrices a and b together.
    """
    @spec multiply( mat33, mat33 ) :: mat33
    def multiply( a, b ) do
        { a11, a12, a13,
          a21, a22, a23,
          a31, a32, a33 } = a

        { b11, b12, b13,
          b21, b22, b23,
          b31, b32, b33 } = b

        {
            (a11*b11) + (a12*b21) + (a13*b31),
            (a11*b12) + (a12*b22) + (a13*b32),
            (a11*b13) + (a12*b23) + (a13*b33),

            (a21*b11) + (a22*b21) + (a23*b31),
            (a21*b12) + (a22*b22) + (a23*b32),
            (a21*b13) + (a22*b23) + (a23*b33),

            (a31*b11) + (a32*b21) + (a33*b31),
            (a31*b12) + (a32*b22) + (a33*b32),
            (a31*b13) + (a32*b23) + (a33*b33)
        }
    end

end
