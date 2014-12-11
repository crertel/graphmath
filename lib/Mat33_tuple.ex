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
    `add(A,B)` adds one 3x3 matrix to another.
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
    `subtract(A,B)` subtracts one 3x3 matrix from another..
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

end
