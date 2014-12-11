defmodule Graphmath.Mat33.Tuple do

    @moduledoc """
    This is the 3D mathematics library for graphmath.

    This submodule handles 3x3 matrices using tuples of floats.
    """

    @doc"""
    `identity()` is used to create a 3x3 identity matrix.
    """
    @spec identity() :: {float, float, float, float, float, float, float, float, float }
    def identity() do
        { 1, 0, 0,
          0, 1, 0,
          0, 0, 1 }
    end

    @doc"""
    `zero()` is used to create a 3x3 zero matrix.
    """
    @spec zero() :: {float, float, float, float, float, float, float, float, float }
    def zero() do
        { 0, 0, 0,
          0, 0, 0,
          0, 0, 0 }
    end
    
end
