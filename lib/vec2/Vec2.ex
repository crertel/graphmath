defmodule Graphmath.Vec2 do

    @moduledoc """
    This is the 2D mathematics library for graphmath.
    """

    @doc"""
        `create_vec2` is used to create a 2d vector.

        It takes a list of numbers and converts it into an array of form [x,y].
    """
    def create_vec2() do
        [0,0]
    end
    def create_vec2 ( vec ) do
        [x,y | _] = vec
        [x,y]
    end

    @doc """
        `add_vec2` is used to add a vec2 to another vec2.
        It takes two vec2s and returns a vec2 which is the element-wise sum of those lists.
    """
    def add_vec2( a, b) do
        [ x,y | _] = a
        [ u,v | _] = b
        [ x+u, y+v ]
    end

    @doc """
        `scale_vec2` is used to perform a scaling on a vec2.

        Passing it a single number will cause all elements of the vec2 to be multipled by that number.
        Passing it a vec2 will cause each element of to be multiplied by the corresponding element of the scale vec2.
    """
    def scale_vec2( vec, [s1, s2 | _ ] ) do
        [ x,y | _ ] = vec
        [ x*s1, y * s2]
    end
    def scale_vec2( vec, scale ) do
        [ x,y | _ ] = vec
        [ x*scale, y*scale ]
    end

end
