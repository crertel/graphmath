defmodule Graphmath.Mat44 do

    @moduledoc """
    This is the 3D mathematics library for graphmath.

    This submodule handles 4x4 matrices using tuples of floats.
    """

    @type mat44 :: { float, float, float, float,
                     float, float, float, float,
                     float, float, float, float,
                     float, float, float, float}
    @type vec4 :: { float, float, float, float }

    @doc"""
    `identity()` creates a 4x4 identity matrix.
    """
    @spec identity() :: mat44
    def identity() do
        { 1, 0, 0, 0,
          0, 1, 0, 0,
          0, 0, 1, 0,
          0, 0, 0, 1}
    end

    @doc"""
    `zero()` creates a 4x4 zero matrix.
    """
    @spec zero() :: mat44
    def zero() do
        { 0, 0, 0, 0,
          0, 0, 0, 0,
          0, 0, 0, 0,
          0, 0, 0, 0}
    end

    @doc"""
    `add(a,b)` adds one 4x4 matrix to another.
    """
    @spec add( mat44, mat44) :: mat44
    def add( a, b ) do
        { a11, a12, a13, a14,
          a21, a22, a23, a24,
          a31, a32, a33, a34,
          a41, a42, a43, a44 } = a

        { b11, b12, b13, b14,
          b21, b22, b23, b24,
          b31, b32, b33, b34,
          b41, b42, b43, b44} = b

        { a11 + b11, a12 + b12, a13 + b13, a14 + b14,
          a21 + b21, a22 + b22, a23 + b23, a24 + b24,
          a31 + b31, a32 + b32, a33 + b33, a34 + b34,
          a41 + b41, a42 + b42, a43 + b43, a44 + b44 }
    end
    
    @doc"""
    `subtract(a,b)` subtracts one 4x4 matrix from another..
    """
    @spec subtract( mat44, mat44) :: mat44
    def subtract( a, b ) do
        { a11, a12, a13, a14,
          a21, a22, a23, a24,
          a31, a32, a33, a34,
          a41, a42, a43, a44 } = a

        { b11, b12, b13, b14,
          b21, b22, b23, b24,
          b31, b32, b33, b34,
          b41, b42, b43, b44} = b
        
        { a11 - b11, a12 - b12, a13 - b13, a14 - b14,
          a21 - b21, a22 - b22, a23 - b23, a24 - b24,
          a31 - b31, a32 - b32, a33 - b33, a34 - b34,
          a41 - b41, a42 - b42, a43 - b43, a44 - b44 }
    end

    @doc"""
    `scale( a, k )` scales every element in a matrix a by coefficient k.
    """
    @spec scale( mat44, float) :: mat44
    def scale( a, k) do
        { a11, a12, a13, a14,
          a21, a22, a23, a24,
          a31, a32, a33, a34,
          a41, a42, a43, a44 } = a

        { a11 * k, a12 * k, a13 * k, a14 * k,
          a21 * k, a22 * k, a23 * k, a24 * k,
          a31 * k, a32 * k, a33 * k, a34 * k,
          a41 * k, a42 * k, a43 * k, a44 * k }
    end
    
    @doc"""
    `make_scale( k )` creates a mat44 that uniformly scales by a value k.
    """
    @spec make_scale( float ) :: mat44
    def make_scale( k ) do
        { k, 0, 0, 0,
          0, k, 0, 0,
          0, 0, k, 0,
          0, 0, 0, k }
    end
    
    @doc"""
    `make_scale( sx, sy, sz, sw )` creates a mat44 that scales by sx, sy, sz, and sz.
    """
    @spec make_scale( float, float, float, float ) :: mat44
    def make_scale( sx, sy, sz, sw ) do
        { sx, 0, 0, 0,
          0, sy, 0, 0,
          0, 0, sz, 0,
          0, 0, 0, sw}
    end

    @doc"""
    `make_translate( tx, ty, tz )` creates a mat44 that translates a point by tx, ty, and tz.
    """
    @spec make_translate( float, float, float ) :: mat44
    def make_translate( tx, ty, tz ) do
        { 1, 0, 0, 0,
          0, 1, 0, 0,
          0, 0, 1, 0,
          tx, ty, tz, 1 }
    end


    @doc"""
    `make_rotate_x( theta )` creates a mat44 that rotates a vec3 by `theta` radians about the X axis.
    """
    @spec make_rotate_x( float ) :: mat44
    def make_rotate_x( theta ) do
        st = :math.sin(theta)
        ct = :math.cos(theta)

        { 1, 0,   0,  0,
          0, ct,  st, 0,
          0, -st, ct, 0,
          0,   0, 0,  1 }
    end
    
    @doc"""
    `make_rotate_y( theta )` creates a mat44 that rotates a vec3 by `theta` radians about the Y axis.
    """
    @spec make_rotate_y( float ) :: mat44
    def make_rotate_y( theta ) do
        st = :math.sin(theta)
        ct = :math.cos(theta)

        { ct,  0, st, 0,
          0,   1, 0,  0,
          -st, 0, ct, 0,
          0,   0, 0,  1 }
    end
    
    @doc"""
    `make_rotate_z( theta )` creates a mat44 that rotates a vec3 by `theta` radians about the Z axis.
    """
    @spec make_rotate_z( float ) :: mat44
    def make_rotate_z( theta ) do
        st = :math.sin(theta)
        ct = :math.cos(theta)
        
        { ct,  st, 0, 0,
          -st, ct, 0, 0,
          0,   0,  1, 0,
          0,   0,  0, 1 }
    end
    
    @doc"""
    `round( a, sigfigs )` rounds every element of a supplied mat44 `a` to number of digits `sigfigs`.
    """
    @spec round( mat44, 0..15 ) :: mat44
    def round( a, sigfigs ) do
        { a11, a12, a13, a14,
          a21, a22, a23, a24,
          a31, a32, a33, a34,
          a41, a42, a43, a44 } = a

        {
            Float.round( 1.0*a11, sigfigs),
            Float.round( 1.0*a12, sigfigs),
            Float.round( 1.0*a13, sigfigs),
            Float.round( 1.0*a14, sigfigs),
            
            Float.round( 1.0*a21, sigfigs),
            Float.round( 1.0*a22, sigfigs),
            Float.round( 1.0*a23, sigfigs),
            Float.round( 1.0*a24, sigfigs),
            
            Float.round( 1.0*a31, sigfigs),
            Float.round( 1.0*a32, sigfigs),
            Float.round( 1.0*a33, sigfigs),
            Float.round( 1.0*a34, sigfigs),
            
            Float.round( 1.0*a41, sigfigs),
            Float.round( 1.0*a42, sigfigs),
            Float.round( 1.0*a43, sigfigs),
            Float.round( 1.0*a44, sigfigs)
        }

    end

    @doc"""
    `multiply( a, b )` multiply two matrices a and b together.
    """
    @spec multiply( mat44, mat44 ) :: mat44
    def multiply( a, b ) do
        { a11, a12, a13, a14,
          a21, a22, a23, a24,
          a31, a32, a33, a34,
          a41, a42, a43, a44 } = a

        { b11, b12, b13, b14,
          b21, b22, b23, b24,
          b31, b32, b33, b34,
          b41, b42, b43, b44} = b

        {
            (a11*b11) + (a12*b21) + (a13*b31) + (a14*b41),
            (a11*b12) + (a12*b22) + (a13*b32) + (a14*b42),
            (a11*b13) + (a12*b23) + (a13*b33) + (a14*b43),
            (a11*b14) + (a12*b24) + (a13*b34) + (a14*b44),

            (a21*b11) + (a22*b21) + (a23*b31) + (a24*b41),
            (a21*b12) + (a22*b22) + (a23*b32) + (a24*b42),
            (a21*b13) + (a22*b23) + (a23*b33) + (a24*b43),
            (a21*b14) + (a22*b24) + (a23*b34) + (a24*b44),

            (a31*b11) + (a32*b21) + (a33*b31) + (a34*b41),
            (a31*b12) + (a32*b22) + (a33*b32) + (a34*b42),
            (a31*b13) + (a32*b23) + (a33*b33) + (a34*b43),
            (a31*b14) + (a32*b24) + (a33*b34) + (a34*b44),
            
            (a41*b11) + (a42*b21) + (a43*b31) + (a44*b41),
            (a41*b12) + (a42*b22) + (a43*b32) + (a44*b42),
            (a41*b13) + (a42*b23) + (a43*b33) + (a44*b43),
            (a41*b14) + (a42*b24) + (a43*b34) + (a44*b44),
        }
    end

    @doc"""
    `multiply_transpose( a, b )` multiply two matrices a and b transpose together.
    """
    @spec multiply_transpose( mat44, mat44 ) :: mat44
    def multiply_transpose( a, b ) do
        { a11, a12, a13, a14,
          a21, a22, a23, a24,
          a31, a32, a33, a34,
          a41, a42, a43, a44 } = a

        { b11, b21, b31, b41,
          b12, b22, b32, b42,
          b13, b23, b33, b43,
          b14, b24, b34, b44} = b
        
        {
            (a11*b11) + (a12*b21) + (a13*b31) + (a14*b41),
            (a11*b12) + (a12*b22) + (a13*b32) + (a14*b42),
            (a11*b13) + (a12*b23) + (a13*b33) + (a14*b43),
            (a11*b14) + (a12*b24) + (a13*b34) + (a14*b44),

            (a21*b11) + (a22*b21) + (a23*b31) + (a24*b41),
            (a21*b12) + (a22*b22) + (a23*b32) + (a24*b42),
            (a21*b13) + (a22*b23) + (a23*b33) + (a24*b43),
            (a21*b14) + (a22*b24) + (a23*b34) + (a24*b44),

            (a31*b11) + (a32*b21) + (a33*b31) + (a34*b41),
            (a31*b12) + (a32*b22) + (a33*b32) + (a34*b42),
            (a31*b13) + (a32*b23) + (a33*b33) + (a34*b43),
            (a31*b14) + (a32*b24) + (a33*b34) + (a34*b44),
            
            (a41*b11) + (a42*b21) + (a43*b31) + (a44*b41),
            (a41*b12) + (a42*b22) + (a43*b32) + (a44*b42),
            (a41*b13) + (a42*b23) + (a43*b33) + (a44*b43),
            (a41*b14) + (a42*b24) + (a43*b34) + (a44*b44),
        }
    end
    
    @doc"""
    `column0( a )` selects the first column from a matrix 4x4 as a vec4.
    """
    @spec column0( mat44 ) :: vec4
    def column0( a ) do
        { a11, _, _, _,
          a21, _, _, _,
          a31, _, _, _,
          a41, _, _, _} = a
        
        {a11,a21,a31,a41}
    end
    
    @doc"""
    `column1( a )` selects the second column from a matrix 4x4 as a vec4.
    """
    @spec column1( mat44 ) :: vec4
    def column1( a ) do
        { _, a12, _, _,
          _, a22, _, _,
          _, a32, _, _,
          _, a42, _, _} = a
        
        {a12,a22,a32,a42}
    end
    
    @doc"""
    `column2( a )` selects the third column from a matrix 4x4 as a vec4.
    """
    @spec column2( mat44 ) :: vec4
    def column2( a ) do
        { _, _, a13, _,
          _, _, a23, _,
          _, _, a33, _,
          _, _, a43, _} = a
        
        {a13,a23,a33,a43}
    end
    
    @doc"""
    `column3( a )` selects the fourth column from a matrix 4x4 as a vec4.
    """
    @spec column3( mat44 ) :: vec4
    def column3( a ) do
        { _, _, _, a14,
          _, _, _, a24,
          _, _, _, a34,
          _, _, _, a44} = a
        
        {a14,a24,a34,a44}
    end
    
    @doc"""
    `row0( a )` selects the first row from a matrix 4x4 as a vec4.
    """
    @spec row0( mat44 ) :: vec4
    def row0( a ) do
        { a11, a12, a13, a14,
          _, _, _, _,
          _, _, _, _,
          _, _, _, _} = a
        
        {a11,a12,a13,a14}
    end
    @doc"""
    `row1( a )` selects the second row from a matrix 4x4 as a vec4.
    """
    @spec row1( mat44 ) :: vec4
    def row1( a ) do
        { _, _, _, _,
          a21, a22, a23, a24,
          _, _, _, _,
          _, _, _, _} = a
        
        {a21,a22,a23,a24}
    end
    
    @doc"""
    `row2( a )` selects the third row from a matrix 4x4 as a vec4.
    """
    @spec row2( mat44 ) :: vec4
    def row2( a ) do
        { _, _, _, _,
          _, _, _, _,
          a31, a32, a33, a34,
          _, _, _, _} = a
        
        {a31,a32,a33,a34}
    end
    
    @doc"""
    `row3( a )` selects the fourth row from a matrix 4x4 as a vec4.
    """
    @spec row3( mat44 ) :: vec4
    def row3( a ) do
        { _, _, _, _,
          _, _, _, _,
          _, _, _, _,
          a41, a42, a43, a44} = a
        
        {a41,a42,a43,a44}
    end
    
    @doc"""
    `diag( a )` selects the diagonal from a matrix 4x4 as a vec4.
    """
    @spec diag( mat44 ) :: vec4
    def diag( a ) do
        { a11, _, _, _,
          _, a22, _, _,
          _, _, a33, _,
          _, _, _, a44} = a
        
        {a11,a22,a33,a44}
    end

    @doc"""
    `at( a, i, j)` selects the element of a 4x4 matrix at row i and column j.
    """
    @spec at( mat44, Integer, Integer ) :: float
    def at( a, i, j ) do
        elem( a, 4*i + j )
    end

    @doc"""
    `apply( a, v )` transforms a vector `v` by a 4x4 matrix `a`.
    """
    @spec apply( mat44, vec4 ) :: vec4
    def apply( a, v ) do
        { a11, a12, a13, a14,
          a21, a22, a23, a24,
          a31, a32, a33, a34,
          a41, a42, a43, a44} = a

        { x, y, z, w } = v

        {
            (a11*x)+(a12*y)+(a13*z)+(a14*w),
            (a21*x)+(a22*y)+(a23*z)+(a24*w),
            (a31*x)+(a32*y)+(a33*z)+(a34*w),
            (a41*x)+(a42*y)+(a43*z)+(a44*w)
        }
    end
    
    @doc"""
    `apply_transpose( a, v )` transforms a vector `v` by a 4x4 matrix `a` transposed.
    """
    @spec apply_transpose( mat44, vec4 ) :: vec4
    def apply_transpose( a, v ) do
        { a11, a21, a31, a41,
          a12, a22, a32, a42,
          a13, a23, a33, a43,
          a14, a24, a34, a44} = a

        { x, y, z, w } = v

        {
            (a11*x)+(a12*y)+(a13*z)+(a14*w),
            (a21*x)+(a22*y)+(a23*z)+(a24*w),
            (a31*x)+(a32*y)+(a33*z)+(a34*w),
            (a41*x)+(a42*y)+(a43*z)+(a44*w)
        }
    end
    
    @doc"""
    `apply_left( v, a )` transforms a vector `v` by a 4x4 matrix `a`.
    """
    @spec apply_left( vec4, mat44 ) :: vec4
    def apply_left( v, a ) do
        { a11, a12, a13, a14,
          a21, a22, a23, a24,
          a31, a32, a33, a34,
          a41, a42, a43, a44} = a

        { x, y, z, w } = v

        {
            (a11*x)+(a21*y)+(a31*z)+(a41*w),
            (a12*x)+(a22*y)+(a32*z)+(a42*w),
            (a13*x)+(a23*y)+(a33*z)+(a43*w),
            (a14*x)+(a24*y)+(a34*z)+(a44*w)
        }
    end

    @doc"""
    `apply_left_transpose( v, a )` transforms a vector `v` by a 4x4 matrix `a` transposed.
    """
    @spec apply_left_transpose( vec4, mat44 ) :: vec4
    def apply_left_transpose( v, a ) do
        { a11, a21, a31, a41,
          a12, a22, a32, a42,
          a13, a23, a33, a43,
          a14, a24, a34, a44} = a

        { x, y, z, w } = v

        {
            (a11*x)+(a21*y)+(a31*z)+(a41*w),
            (a12*x)+(a22*y)+(a32*z)+(a42*w),
            (a13*x)+(a23*y)+(a33*z)+(a43*w),
            (a14*x)+(a24*y)+(a34*z)+(a44*w)
        }
    end
end
