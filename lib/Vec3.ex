defmodule Graphmath.Vec3 do

    @moduledoc """
    This is the 3D mathematics library for graphmath.
    """

    @doc"""
    `create()` is used to create a 3d vector.

    It takes a list of numbers and converts it into an array of form [x,y,z].
    """
    @spec create() :: [float]
    def create() do
        [0,0,0]
    end
    
    @doc"""
    `create(x,y,z)` creates a vec3 of value (x,y,z).

    It will return a list of the form [x,y,z].
    """
    @spec create(float,float,float) :: [float]
    def create( x, y, z) do
        [x,y,z]
    end
        
    @doc"""
    `create(vec)` creates a vec3 of value (x,y,z) out of a list of 3 or more numbers.

    It will return a list of the form [x,y,z].
    """
    @spec create([float]) :: [float]
    def create( vec ) do
        [x,y,z | _] = vec
        [x,y,z]
    end

    @doc """
    `add( a, b)` adds a vec3 (a) to a vec3 (b).

    It returns a list of the form [ ax + bx, ay + by, az + bz ].
    """
    @spec add( [float], [float]) :: [float]
    def add( a, b ) do
        [ x, y, z | _ ] = a
        [ u, v, w | _ ] = b
        [ x+u, y+v, z+w ]
    end

    @doc """
    `subtract(a, b)` subtracts a vec3 (b) from a vec3 (a).

    It returns a list of the form [ ax - bx, ay - by, az - bz ].
    """
    @spec subtract( [float], [float] ) :: [float]
    def subtract( a, b ) do
        [ x, y, z | _ ] = a
        [ u, v, w | _ ] = b
        [ x-u, y-v, z-w ]
    end

    @doc """
    `multiply( a, b)` mulitplies element-wise a vec3 (a) by a vec3 (b).

    It returns a list of the form [ ax*bx, ay*by ].
    """
    @spec multiply( [float], [float] ) :: [float]
    def multiply( a, b ) do
        [ x, y, z | _ ] = a
        [ u, v, w | _ ] = b
        [ x*u, y*v, z*w ]
    end

    @doc """
    `scale( a, scale)` uniformly scales a vec3 (a) by an amount (x).

    It returns a list of the form [ ax*scale, ay*scale, az*scale ].
    """
    @spec scale( [float], float ) :: [float]
    def scale( a, scale ) do
        [ x,y,z | _ ] = a
        [ x*scale, y*scale, z*scale ]
    end

    @doc """
    `dot( a, b)` finds the dot (inner) product of a vec3 (a)  with another vec3 (b).

    It returns a float of the value (ax*bx + ay*by + az*bz).
    """
    @spec dot( [float], [float] ) :: float
    def dot( a, b ) do
        [ x, y, z | _ ] = a
        [ u, v, w | _ ] = b
        (x*u)+(y*v)+(z*w)
    end

    @doc """
    `cross( a, b)` finds the cross productof a vec3 (a) with another vec3 (b).

    The cross product of two vectors is a vector perpendicular to the two soure vectors.
    Its magnitude will be the area of the parallelogram made by the two souce vectors.
    
    It returns a float of the value ( y1*z2 - z1*y2, z1*x2 - x1*z2, x1*y2 - y1*x2 ).
    """
    @spec cross( [float], [float] ) :: [float]
    def cross( a, b ) do
        [ x, y, z | _ ] = a
        [ u, v, w | _ ] = b
        [ y*w - z*v, z*u - x*w, x*v - y*u ]
    end

    
    @doc """
    `length(a)` finds the length (L2 norm) of a vec3 (a).

    The length is the square root of the sum of the squares of the components.

    It returns a float of the value ( sqrt(ax*ax + ay*ay + az*az).
    """
    @spec length( [float] ) :: float
    def length( a ) do
        [ x, y, z | _ ] = a
        :math.sqrt( (x*x) + (y*y) + (z*z) )
    end

    @doc """
    `length_squared(a)` finds the square of the length of a vec3 (a).

    In many cases, this is sufficient for comparisions and avaoids a sqrt.

    It returns a float of the value (ax*ax + ay*ay + az*az).
    """
    @spec length_squared( [float] ) :: float
    def length_squared( a ) do
        [ x, y, z | _ ] = a
        (x*x) + (y*y) + (z*z)
    end

    @doc """
    `length_manhattan(a)` finds the Manhattan (L1 norm) length of a vec3 (a).

    The Manhattan length is the sum of the components.
    
    It returns a float of the value (ax + ay + az).
    """
    @spec length_manhattan( [float] ) :: float
    def length_manhattan( a ) do
        [ x, y, z | _ ] = a
        x + y + z
    end

    @doc """
    `normalize(a)` finds the unit vector with the same direction as a vec3 (a).

    This is done by dividing each component by the vector's magnitude.

    It returns a list of the form [ normx, normy, normz ].
    """
    @spec normalize( [float] ) :: [float]
    def normalize( a ) do
        [ x, y, z | _ ] = a
        imag = 1 / :math.sqrt( (x*x) + (y*y) + (z*z) )
        [x * imag, y * imag, z * imag]
    end
    
    @doc """
    `lerp(a,b,t)` linearly interpolates between one vec3 (a) and another vec3 (b) along an interpolant t.

    The interpolant `t`  is on the domain [0,1]. Behavior outside of that is undefined.
    """
    @spec lerp( [float], [float], float) :: [float]
    def lerp( a, b, t ) do
        [ x, y, z | _ ] = a
        [ u, v, w | _ ] = b
        [ ( t * u) + ( (1-t) *x ), (t * v) + ( (1-t) *y), (t * w) + ( (1-t) * z)]
    end

    @doc """
    `near(a,b, distance)` checks whether two vectors are within a length of each other.
    """
    @spec near( [float], [float], float) :: boolean
    def near( a, b, distance) do
        [ x, y, z | _ ] = a
        [ u, v, w | _ ] = b
        dx = u - x
        dy = v - y
        dz = w - z
        distance > :math.sqrt( dx*dx + dy*dy + dz*dz)
    end

    @doc """
    `rotate( v, k, theta)` rotates a vector (v) about a unit vector (k) by theta radians.

    This uses the [Formula of Rodriguez](http://en.wikipedia.org/wiki/Rodrigues%27_rotation_formula):

    Vrot = V*cos(theta) + (K x V)*sin(theta) + K(K*V)(1-cos(theta))
    """
    def rotate( v, k, theta) do
        [ vx, vy, vz | _ ] = v
        [ kx, ky, kz | _ ] = k
        ct = :math.cos(theta)
        st = :math.sin(theta)
        k_dot_v = ( (vx*kx) + (vy*ky) + (vz*kz) )
        coeff = (1.0-ct) * k_dot_v

        scale( v, ct)
        |> add( scale( cross( k, v), st) )
        |> add( scale(k, coeff) )
    end
end
