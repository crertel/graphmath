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

end
