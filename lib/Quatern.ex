defmodule Graphmath.Quatern do
    alias Graphmath.Mat33, as: Mat33

    @moduledoc """
    This is the 3D mathematics library for graphmath.

    This submodule handles  Quaternion using tuples of floats.
    i.e. a rotation around an axis.
    
    Consider the `quatern` format: `{ w, x, y, z }` where `w` is the angle in Radians, 
    and `x` `y` `z` are the axis coordinates
    """
    
    @type quatern :: {float, float, float, float}
    @type vec3 :: { float, float, float }
    @type mat33 :: { float, float, float,
                     float, float, float,
                     float, float, float }
    
    @doc"""
    `create()` creates a zeroed `quatern`.

    It takes no arguments.

    It returns a `quatern` of the form `{ 0.0, 0.0, 0.0, 0.0  }`.
    """
    @spec create() :: quatern
    def create() do
        {0.0, 0.0, 0.0, 0.0}
    end
    
    @doc"""
    `create(w,x,y,z)` creates a `quatern` of value (w,x,y,z).
    
    `w` is the rotation arround the axis in Radians.

    `x` is the first element of the `vec3` representing the axis to be created.
    
    `y` is the second element of the `vec3` representing the axis to be created.
    
    `z` is the third element of the `vec3` representing the axis to be created.

    It returns a `quatern` of the form `{w,x,y,z}`.
    """
    @spec create(float,float,float,float) :: quatern
    def create( w, x, y, z) do
        {w,x,y,z}
    end
    
    @doc"""
    `create(quatern)` creates a `quatern` from a list of 4 or more floats.

    `quatern` is a list of 4 or more floats.

    It returns a `quatern` of the form `{w,x,y,z}`, where `w`, `x`, `y`, and `z` are the first four elements in `quatern`.
    """
    @spec create([float]) :: quatern
    def create( quatern ) do
        [w,x,y,z | _] = quatern
        {w,x,y,z}
    end
    
    @doc"""
    `create(w,vec3)` creates a `quatern` from a angle and a axis.
    
    `w` is the angle in Radians
    
    `vec3` is the axis, a tuple {x,y,z}
    
    It returns a `quatern` of the form `{w,x,y,z}`.
    """
    @spec create(float, vec3) :: quatern
    def create( w, vec ) do
        {x,y,z} = vec
        {w,x,y,z}
    end

    @doc"""
    `roll(quat)` Calculate the local roll element of a quaternion.
    
    `quat` is the quatern
    
    It returns a `float` representing the roll of the quaternion in Radians.
    """
    @spec get_roll(quatern) :: float
    def get_roll(quat) do
        {w,x,y,z} = quat

        fTy  = 2.0*y
        fTz  = 2.0*z
        fTwz = fTz*w
        fTxy = fTy*x
        fTyy = fTy*y
        fTzz = fTz*z

        :math.atan2(fTxy+fTwz, 1.0-(fTyy+fTzz))
    end 

    @doc"""
    `add(lhs, rhs)` add two quaternions.
    
    `lhs` is the first `quatern`

    `rhs` is the second `quatern`
    
    It returns a `quatern` of the form 
        { lhs<sub>w</sub> + rhs<sub>w</sub>, lhs<sub>x</sub> + rhs<sub>x</sub>, lhs<sub>y</sub> + rhs<sub>y</sub>, lhs<sub>z</sub> + rhs<sub>z</sub> }.
    """
    @spec add(quatern, quatern) :: quatern
    def add(lhs, rhs) do
        {w,x,y,z} = lhs
        {a,b,c,d} = rhs

        {w+a, x+b, y+c, z+d}
    end

    @doc"""
    `subtract(lhs, rhs)` subtract two quaternions.
    
     `lhs` is the first `quatern`

     `rhs` is the second `quatern`
    
     It returns a `quatern` of the form 
        { lhs<sub>w</sub> - rhs<sub>w</sub>, lhs<sub>x</sub> - rhs<sub>x</sub>, lhs<sub>y</sub> - rhs<sub>y</sub>, lhs<sub>z</sub> - rhs<sub>z</sub> }.
    """
    @spec subtract(quatern, quatern) :: quatern
    def subtract(lhs, rhs) do
        {w,x,y,z} = lhs
        {a,b,c,d} = rhs

        {w-a, x-b, y-c, z-d}
    end

    @doc"""
    `multiply(lhs, rhs)` multiply two quaternions.
    
     `lhs` is the first `quatern`

     `rhs` is the second `quatern`
    
     It returns a `quatern` resultant of the multiplication
     NOTE: Multiplication is not generally commutative, so in most cases p*q != q*p.
    """
    @spec multiply(quatern, quatern) :: quatern
    def multiply(lhs, rhs) do
        {w,x,y,z} = lhs
        {a,b,c,d} = rhs

        { w * a - x * b - y * c - z * d,
          w * b + x * a + y * d - z * c,
          w * c + y * a + z * b - x * d,
          w * d + z * a + x * c - y * b }
    end

   @doc"""
    `scale(quat, scalar)` multiply a `quatern` for a scalar.
    
     `quat` is the `quatern`

     `scalar` is the scalar
    
     It returns a `quatern` of the form 
        { a<sub>w</sub> * scalar, a<sub>x</sub> * scalar, a<sub>y</sub> * scalar, a<sub>z</sub> * scalar}.
    """
    @spec scale(quatern, float) :: quatern
    def scale(quat, scalar) do
        {w,x,y,z} = quat

        {w*scalar,x*scalar,y*scalar,z*scalar}
    end

    @doc"""
    `pitch(quat)` Calculate the local pitch element of a quaternion.
    
    `quat` is the quatern
    
    It returns a `float` representing the pitch of the quaternion in Radians.
    """
    @spec get_pitch(quatern) :: float
    def get_pitch(quat) do
        {w,x,y,z} = quat

        fTx  = 2.0*x
        fTz  = 2.0*z
        fTwx = fTx*w
        fTxx = fTx*x
        fTyz = fTz*y
        fTzz = fTz*z

        :math.atan2(fTyz+fTwx, 1.0-(fTxx+fTzz))
    end 

    @doc"""
    `yaw(quat)` Calculate the local yaw element of a quaternion.
    
    `quat` is the quatern
    
    It returns a `float` representing the yaw of the quaternion in Radians.
    """
    @spec get_yaw(quatern) :: float
    def get_yaw(quat) do
        {w,x,y,z} = quat

        fTx  = 2.0*x
        fTy  = 2.0*y
        fTz  = 2.0*z
        fTwy = fTy*w
        fTxx = fTx*x
        fTxz = fTz*x
        fTyy = fTy*y


        :math.atan2(fTxz+fTwy, 1.0-(fTxx+fTyy))
    end 
    
    @doc"""
    `from_rotation_matrix(mat)` creates a `quatern` from a rotation matrix.
    
    `mat` is the matrix
    
    It returns a `quatern` of the form `{w,x,y,z}`.
    """
    @spec from_rotation_matrix(mat33) :: quatern
    def from_rotation_matrix(mat) do
        { a11, a12, a13,
          a21, a22, a23,
          a31, a32, a33 } = mat
          
        fTrace = a11 + a22 + a33;

        if ( fTrace > 0.0 ) do
            fRoot = :math.sqrt(fTrace + 1.0)
            w = 0.5 * fRoot
            fRoot = 0.5/fRoot
            { w, (a32-a23)*fRoot, (a13-a31)*fRoot, (a21-a12)*fRoot }
        else
            iNext = { 1, 2, 0 }
            i = 0
            if a22 > a11 do i = 1 end
            if a33 > Mat33.at(mat,i,i) do i = 2 end
                
            j = elem(iNext,i)
            k = elem(iNext,j)

            fRoot = :math.sqrt(Mat33.at(mat,i,i) - Mat33.at(mat,j,j) - Mat33.at(mat,k,k) + 1.0)
            apkQuat = { 0.0, 0.0, 0.0 }
            apkQuat = put_elem(apkQuat, i, 0.5*fRoot)
            fRoot = 0.5/fRoot;
            apkQuat = put_elem(apkQuat, j, (Mat33.at(mat,j,i)+Mat33.at(mat,i,j)) * fRoot)
            apkQuat = put_elem(apkQuat, k, (Mat33.at(mat,k,i)+Mat33.at(mat,i,k)) * fRoot)
            
            {x,y,z} = apkQuat
            
            {(Mat33.at(mat,k,j)-Mat33.at(mat,j,k))*fRoot , x, y, z}
        end
    end
    
    
    @doc"""
    `to_rotation_matrix(quat)` creates a `mat33` from a quatern.
    
    `quat` is the quatern
    
    It returns a `mat33` representing a rotation.
    """
    @spec to_rotation_matrix(quatern) :: mat33
    def to_rotation_matrix(quat) do
        {w,x,y,z} = quat
        fTx  = x+x
        fTy  = y+y
        fTz  = z+z
        fTwx = fTx*w
        fTwy = fTy*w
        fTwz = fTz*w
        fTxx = fTx*x
        fTxy = fTy*x
        fTxz = fTz*x
        fTyy = fTy*y
        fTyz = fTz*y
        fTzz = fTz*z

        a11 = 1.0-(fTyy+fTzz)
        a12 = fTxy-fTwz
        a13 = fTxz+fTwy
        a21 = fTxy+fTwz
        a22 = 1.0-(fTxx+fTzz)
        a23 = fTyz-fTwx
        a31 = fTxz-fTwy
        a32 = fTyz+fTwx
        a33 = 1.0-(fTxx+fTyy)
        
        { a11, a12, a13,
          a21, a22, a23,
          a31, a32, a33 }
    end
    
    @doc"""
    `dot(lhs, rhs)` returns a `float` resultant of the dot product bectween two quaterns.
    
    `lhs` is a quatern
    
    `rhs` is a quatern
    
    It returns a `float` representing the dot product.
    """
    @spec dot(quatern, quatern) :: float
    def dot(lhs, rhs) do
        {w,x,y,z} = lhs
        {a,b,c,d} = rhs
        
        w*a + x*b + y*c + z*d
    end
    
    @doc"""
    `norm(quat)` Returns the normal length of the quaternion.
    
    `quat` is the quatern
    
    It returns a `float` representing the normal.
    """
    @spec norm(quatern) :: float
    def norm(quat) do
        {w,x,y,z} = quat
        w*w + x*x + y*y + z*z
    end
    
    @doc"""
    `inverse(quat)` Returns the inverse of the quaternion.
    
    `quat` is the quatern
    
    It returns a `quatern` representing the inverse of the parameter quatern.
    
    If the `quat`is less than zero, the quatern retorned is a zero quatern.
    """
    @spec inverse(quatern) :: quatern
    def inverse(quat) do
        {w,x,y,z} = quat
        
        fNorm = w*w+x*x+y*y+z*z
        if ( fNorm > 0.0 ) do
            fInvNorm = 1.0/fNorm
            {w*fInvNorm,-x*fInvNorm,-y*fInvNorm,-z*fInvNorm}
        else
            #return an invalid result to flag the error
            create
        end
    end
    
    @doc"""
    `unit_inverse(quat)` Returns the inverse of a unit quaternion.
    
    `quat` is the unit quatern
    
    It returns a `quatern` representing the inverse of the unit quatern.
    """
    @spec unit_inverse(quatern) :: quatern
    def unit_inverse(quat) do
        {w,x,y,z} = quat
        {w,-x,-y,-z}
    end
end
