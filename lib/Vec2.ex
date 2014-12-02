defmodule Graphmath.Vec2 do

    @moduledoc """
    This is the 2D mathematics library for graphmath.
    """

    @doc"""
    `create` is used to create a 2d vector.

    It takes a list of numbers and converts it into an array of form [x,y].
    """
    @spec create() :: [float]
    def create() do
        [0,0]
    end
    @spec create(float,float) :: [float]
    def create(x,y) do
        [x,y]
    end
    @spec create([float]) :: [float]
    def create( vec ) do
        [x,y | _] = vec
        [x,y]
    end

    @doc """
    `add` is used to add a vec2 to another vec2.
    It takes two vec2s and returns a vec2 which is the element-wise sum of those lists.
    """
    @spec add( [float], [float]) :: [float]
    def add( a, b) do
        [ x,y | _] = a
        [ u,v | _] = b
        [ x+u, y+v ]
    end

    @doc """
    `subtract` is used to subtract a vec2 from another vec2.
    It takes two vec2s and returns the difference of the two.
    """
    @spec subtract( [float], [float] ) :: [float]
    def subtract( [x1, y1 | _], [x2,y2| _]) do
        [x1-x2,y1-y2]
    end

    @doc """
    `scale` is used to perform a scaling on a vec2.

    Passing it a single number will cause all elements of the vec2 to be multipled by that number.
    Passing it a vec2 will cause each element of to be multiplied by the corresponding element of the scale vec2.
    """
    @spec scale( [float], [float] ) :: [float]
    def scale( vec, [s1, s2 | _ ] ) do
        [ x,y | _ ] = vec
        [ x*s1, y * s2]
    end
    @spec scale( [float], float ) :: [float]
    def scale( vec, scale ) do
        [ x,y | _ ] = vec
        [ x*scale, y*scale ]
    end

    @doc """
    `dot` is used to find the inner product (dot product) of one vec2 and another.

    Passing it two vec2s will cause it to return the inner product of those two vec2s.
    """
    @spec dot( [float], [float] ) :: float
    def dot( [x1,y1 |_ ], [x2,y2|_]) do
        (x1*x2)+(y1*y2)
    end

    @doc """
    `perp_prod` is used to find the perpindicular product of two vec2s.

    The perpindicular product is the magnitude of the cross-product between the two vectors.
    """
    @spec perp_prod( [float], [float] ) :: float
    def perp_prod( [x1, y1 | _ ], [ x2,y2 | _ ] ) do
        (x1*y2) -( x2*y1)
    end


    @doc """
    `length` is used to find the length (L2 norm) of a vector.

    The length is the square root of the sum of the squares.
    """
    @spec length( [float] ) :: float
    def length( [x1, y1 | _ ] ) do
        :math.sqrt( (x1*x1) + (y1*y1) )
    end

    @doc """
    `length_squared` is used to find the square of the length of a vector.

    In many cases, this is sufficient for comparisions and avaoids a sqrt.
    """
    @spec length_squared( [float] ) :: float
    def length_squared( [ x1, y1 | _ ] ) do
        (x1*x1) + (y1*y1)
    end

    @doc """
    `length_manhatten` is used to find the Manhattan (L1 norm) length of a vector.

    The Manhattan length is simply the sum of the components.
    """
    @spec length_manhattan( [float] ) :: float
    def length_manhattan( [x1, y1| _ ]) do
        x1 + y1
    end

    @doc """
    `normalize` is used to find the unit vector with the same direction as the supplied vector.

    This is done by dividing each component by the vector's magnitude.
    """
    @spec normalize( [float] ) :: [float]
    def normalize( [x1, y1 | _ ] ) do
        imag = 1 / :math.sqrt( (x1*x1) + (y1*y1) )
        [x1 * imag, y1 * imag]
    end
    
    @doc """
    `lerp` is used to linearly interpolate between two given vectors.

    The interpolant is on the domain [0,1]. Behavior outside of that is undefined.
    """
    @spec lerp( [float], [float], float) :: [float]
    def lerp( [x1, y1 | _ ], [x2,y2| _], t ) do
        [ ( t * x2) + ( (1-t) *x1 ), (t * y2) + ( (1-t) *y1)]
    end

    @doc """
    `rotate` is used to rotate a vec CCW about the +Z axis a given number of radians.
    """
    @spec rotate( [float], float) :: [float]
    def rotate( [ x1, y1 | _ ], theta) do
        ct = :math.cos(theta)
        st = :math.sin(theta)
        [ x1*ct + y1*st, x1*st - y1*ct]
    end

    @doc """
    `compare` is used to check whether or not two vectors are within a length of each other.
    """
    @spec compare( [float], [float], float) :: boolean
    def compare( [x1,y1|_], [x2, y2 | _ ], l) do
        dx = x2-x1
        dy = y2-y1
        l > :math.sqrt( dx*dx + dy*dy )
    end

    @doc """
    `project` projects one vector onto another, and returns the resulting image.
    """
    @spec project( [float], [float]) :: [float]
    def project( [x1,y1|_], [x2,y2|_] ) do
        coeff = ((x1*x2) +(y1*y2)) / (x2*x2 + y2*y2)
        [x2*coeff, y2*coeff]
    end
end
