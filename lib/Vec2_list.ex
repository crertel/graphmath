defmodule Graphmath.Vec2.List do

    @moduledoc """
    This is the 2D mathematics library for graphmath.

    This submodule handles vectors stored as a list.
    """

    @doc"""
    `create()` creates a zero vec2.

    It will return a list of the form [0.0,0.0].
    """
    @spec create() :: [float]
    def create() do
        [0.0,0.0]
    end

    @doc"""
    `create(x,y)` creates a vec2 of value (x,y).

    It will return a list of the form [x,y].
    """
    @spec create(float,float) :: [float]
    def create(x,y) do
        [x,y]
    end

    @doc"""
    `create(vec)` creates a vec2 of value (x,y) out of a list of 2 or more numbers.

    It will return a list of the form [x,y].
    """
    @spec create([float]) :: [float]
    def create( vec ) do
        [x,y | _] = vec
        [x,y]
    end

    @doc """
    `add( a, b)` adds a vec2 (a) to a vec2 (b).

    It returns a list of the form [ ax + bx, ay + by ].
    """
    @spec add( [float], [float]) :: [float]
    def add( a, b ) do
        [ x,y | _] = a
        [ u,v | _] = b
        [ x+u, y+v ]
    end

    @doc """
    `subtract(a, b)` subtracts a vec2 (b) from a vec2 (a).

    It returns a list of the form [ ax - bx, ay - by ].
    """
    @spec subtract( [float], [float] ) :: [float]
    def subtract( a, b) do
        [ x,y | _] = a
        [ u,v | _] = b
        [x-u,y-v]
    end

    @doc """
    `multiply( a, b)` mulitplies element-wise a vec2 (a) by a vec2 (b).

    It returns a list of the form [ ax*bx, ay*by ].
    """
    @spec multiply( [float], [float] ) :: [float]
    def multiply( a, b ) do
        [ x,y | _ ] = a
        [ u,v | _ ] = b
        [ x*u, y*v ]
    end
    
    @doc """
    `scale( a, scale)` uniformly scales a vec2 (a) by an amount (x).

    It returns a list of the form [ ax*scale, ay*scale ].
    """
    @spec scale( [float], float ) :: [float]
    def scale( a, scale ) do
        [ x,y | _ ] = a
        [ x*scale, y*scale ]
    end

    @doc """
    `dot( a, b)` finds the dot (inner) product of a vec2 (a)  with another vec2 (b).

    It returns a float of the value (ax*bx + ay*by).
    """
    @spec dot( [float], [float] ) :: float
    def dot( a, b) do
        [ x,y | _ ] = a
        [ u,v | _ ] = b
        (x*u)+(y*v)
    end

    @doc """
    `perp_prod( a, b)` finds the perpindicular product of a vec2 (a) with another vec2 (b).

    The perpindicular product is the magnitude of the cross-product between the two vectors.
    
    It returns a float of the value (ax*by - bx*ay).
    """
    @spec perp_prod( [float], [float] ) :: float
    def perp_prod( a, b ) do
        [ x,y | _ ] = a
        [ u,v | _ ] = b
        (x*v) -( u*y)
    end

    @doc """
    `length(a)` finds the length (L2 norm) of a vec2 (a).

    The length is the square root of the sum of the squares of the components.

    It returns a float of the value ( sqrt(ax*ax + ay*ay).
    """
    @spec length( [float] ) :: float
    def length( a ) do
        [ x,y | _ ] = a
        :math.sqrt( (x*x) + (y*y) )
    end

    @doc """
    `length_squared(a)` finds the square of the length of a vec2 (a).

    In many cases, this is sufficient for comparisions and avaoids a sqrt.

    It returns a float of the value (ax*ax + ay*ay).
    """
    @spec length_squared( [float] ) :: float
    def length_squared( a ) do
        [ x,y | _ ] = a
        (x*x) + (y*y)
    end

    @doc """
    `length_manhattan(a)` finds the Manhattan (L1 norm) length of a vec2 (a).

    The Manhattan length is the sum of the components.
    
    It returns a float of the value (ax + ay).
    """
    @spec length_manhattan( [float] ) :: float
    def length_manhattan( a ) do
        [ x,y | _ ] = a
        x + y
    end

    @doc """
    `normalize(a)` finds the unit vector with the same direction as a vec2 (a).

    This is done by dividing each component by the vector's magnitude.

    It returns a list of the form [ normx, normy ].
    """
    @spec normalize( [float] ) :: [float]
    def normalize( a ) do
        [ x,y | _ ] = a
        invmag = 1 / :math.sqrt( (x*x) + (y*y) )
        [x * invmag, y * invmag]
    end
    
    @doc """
    `lerp(a,b,t)` is used to linearly interpolate between two given vectors a and b along an interpolant t.

    The interpolant `t`  is on the domain [0,1]. Behavior outside of that is undefined.
    """
    @spec lerp( [float], [float], float) :: [float]
    def lerp( a, b, t ) do
        [ x,y | _ ] = a
        [ u,v | _ ] = b
        [ ( t*u) + ((1-t)*x), (t*v) + ((1-t)*y)]
    end

    @doc """
    `rotate(a,theta)` rotates a vec2 (a) CCW about the +Z axis `theta` radians.
    """
    @spec rotate( [float], float) :: [float]
    def rotate( a, theta) do
        [ x,y | _ ] = a
        ct = :math.cos(theta)
        st = :math.sin(theta)
        [ x*ct + y*st, x*st - y*ct]
    end

    @doc """
    `near(a,b, distance)` checks whether two vectors are within a length of each other.
    """
    @spec near( [float], [float], float) :: boolean
    def near( a, b, distance) do
        [ x,y | _ ] = a
        [ u,v | _ ] = b
        dx = x-u
        dy = y-v
        distance > :math.sqrt( dx*dx + dy*dy )
    end

    @doc """
    `project(a,b)` projects one vector onto another, and returns the resulting image.
    """
    @spec project( [float], [float]) :: [float]
    def project( a,b ) do
        [ x,y | _ ] = a
        [ u,v | _ ] = b
        coeff = ((x*u) +(y*v)) / (u*u + v*v)
        [u*coeff, v*coeff]
    end
end
