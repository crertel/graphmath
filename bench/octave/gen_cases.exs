# Usage: mix run bench/octave/gen_cases.exs /tmp/cases.m  (then run check.m on it)
# Drives every public graphmath function with seeded random inputs and writes
# an Octave data file: C{k} = struct(name, args{...}, out, err)
alias Graphmath.{Vec2, Vec3, Vec4, Mat22, Mat33, Mat44, Quatern}

defmodule Gen do
  def start(path) do
    :rand.seed(:exsss, {20_260_916, 1, 2})
    {:ok, io} = File.open(path, [:write])
    Process.put(:io, io)
    Process.put(:k, 0)
    IO.write(io, "C = {};\n")
  end

  def finish, do: File.close(Process.get(:io))

  def r(), do: :rand.uniform() * 10.0 - 5.0
  def rp(), do: :rand.uniform() * 4.0 + 0.5
  def ang(), do: :rand.uniform() * 2 * :math.pi() - :math.pi()
  def v2(), do: {r(), r()}
  def v3(), do: {r(), r(), r()}
  def v4(), do: {r(), r(), r(), r()}
  def m2(), do: List.to_tuple(for _ <- 1..4, do: r())
  def m3(), do: List.to_tuple(for _ <- 1..9, do: r())
  def m4(), do: List.to_tuple(for _ <- 1..16, do: r())
  def unit3(), do: Vec3.normalize(v3())
  def uq(), do: Quatern.normalize(v4())

  def fmt(x) when is_float(x), do: Float.to_string(x)
  def fmt(x) when is_integer(x), do: Integer.to_string(x)
  def fmt(true), do: "1"
  def fmt(false), do: "0"
  def fmt(x) when is_tuple(x), do: "[" <> Enum.map_join(Tuple.to_list(x), " ", &fmt/1) <> "]"
  def fmt(x) when is_list(x), do: "[" <> Enum.map_join(x, " ", &fmt/1) <> "]"

  def emit(name, args, fun) do
    k = Process.get(:k) + 1
    Process.put(:k, k)
    io = Process.get(:io)

    {out, err} =
      try do
        {apply(fun, args), 0}
      rescue
        e -> {[], "#{inspect(e.__struct__)}"}
      end

    a = Enum.map_join(args, ", ", &fmt/1)
    IO.write(io, "C{#{k}} = struct('name','#{name}','a',{{#{a}}},'out',#{fmt(out)},'err'")
    if err == 0, do: IO.write(io, ",0);\n"), else: IO.write(io, ",'#{err}');\n")
  end

  def times(n, f), do: for(_ <- 1..n, do: f.())
end

defmodule Main do
  import Gen

  def run() do
    start(System.argv() |> hd())
    n = 6

    # ---------------- Vec2
    times(n, fn -> emit("v2.add", [v2(), v2()], &Vec2.add/2) end)
    times(n, fn -> emit("v2.subtract", [v2(), v2()], &Vec2.subtract/2) end)
    times(n, fn -> emit("v2.multiply", [v2(), v2()], &Vec2.multiply/2) end)
    times(n, fn -> emit("v2.scale", [v2(), r()], &Vec2.scale/2) end)
    times(n, fn -> emit("v2.dot", [v2(), v2()], &Vec2.dot/2) end)
    times(n, fn -> emit("v2.length", [v2()], &Vec2.length/1) end)
    times(n, fn -> emit("v2.length_squared", [v2()], &Vec2.length_squared/1) end)
    times(n, fn -> emit("v2.length_manhattan", [v2()], &Vec2.length_manhattan/1) end)
    times(n, fn -> emit("v2.chebyshev_distance", [v2(), v2()], &Vec2.chebyshev_distance/2) end)

    times(n, fn ->
      emit("v2.minkowski_distance", [v2(), v2(), rp()], &Vec2.minkowski_distance/3)
    end)

    times(n, fn -> emit("v2.p_norm", [v2(), rp()], &Vec2.p_norm/2) end)
    times(n, fn -> emit("v2.lerp", [v2(), v2(), :rand.uniform()], &Vec2.lerp/3) end)
    times(n, fn -> emit("v2.negate", [v2()], &Vec2.negate/1) end)
    times(n, fn -> emit("v2.normalize", [v2()], &Vec2.normalize/1) end)
    times(n, fn -> emit("v2.project", [v2(), v2()], &Vec2.project/2) end)
    times(n, fn -> emit("v2.perp", [v2()], &Vec2.perp/1) end)
    times(n, fn -> emit("v2.perp_prod", [v2(), v2()], &Vec2.perp_prod/2) end)
    times(n, fn -> emit("v2.rotate", [v2(), ang()], &Vec2.rotate/2) end)
    times(n, fn -> emit("v2.weighted_sum", [r(), v2(), r(), v2()], &Vec2.weighted_sum/4) end)
    times(n, fn -> emit("v2.near", [v2(), v2(), rp()], &Vec2.near/3) end)
    times(n, fn -> emit("v2.equal3", [v2(), v2(), rp()], &Vec2.equal/3) end)

    times(n, fn ->
      a = v2()
      emit("v2.equal", [a, a], &Vec2.equal/2)
    end)

    times(n, fn -> emit("v2.equal", [v2(), v2()], &Vec2.equal/2) end)
    times(n, fn -> emit("v2.create2", [r(), r()], &Vec2.create/2) end)
    times(n, fn -> emit("v2.create1", [[r(), r()]], &Vec2.create/1) end)
    times(n, fn -> emit("v2.random_circle", [], &Vec2.random_circle/0) end)
    times(n, fn -> emit("v2.random_disc", [], &Vec2.random_disc/0) end)
    times(n, fn -> emit("v2.random_box", [], &Vec2.random_box/0) end)

    # ---------------- Vec3
    times(n, fn -> emit("v3.add", [v3(), v3()], &Vec3.add/2) end)
    times(n, fn -> emit("v3.subtract", [v3(), v3()], &Vec3.subtract/2) end)
    times(n, fn -> emit("v3.multiply", [v3(), v3()], &Vec3.multiply/2) end)
    times(n, fn -> emit("v3.scale", [v3(), r()], &Vec3.scale/2) end)
    times(n, fn -> emit("v3.dot", [v3(), v3()], &Vec3.dot/2) end)
    times(n, fn -> emit("v3.cross", [v3(), v3()], &Vec3.cross/2) end)
    times(n, fn -> emit("v3.length", [v3()], &Vec3.length/1) end)
    times(n, fn -> emit("v3.length_squared", [v3()], &Vec3.length_squared/1) end)
    times(n, fn -> emit("v3.length_manhattan", [v3()], &Vec3.length_manhattan/1) end)
    times(n, fn -> emit("v3.chebyshev_distance", [v3(), v3()], &Vec3.chebyshev_distance/2) end)

    times(n, fn ->
      emit("v3.minkowski_distance", [v3(), v3(), rp()], &Vec3.minkowski_distance/3)
    end)

    times(n, fn -> emit("v3.p_norm", [v3(), rp()], &Vec3.p_norm/2) end)
    times(n, fn -> emit("v3.lerp", [v3(), v3(), :rand.uniform()], &Vec3.lerp/3) end)
    times(n, fn -> emit("v3.negate", [v3()], &Vec3.negate/1) end)
    times(n, fn -> emit("v3.normalize", [v3()], &Vec3.normalize/1) end)
    times(n, fn -> emit("v3.rotate", [v3(), unit3(), ang()], &Vec3.rotate/3) end)
    times(n, fn -> emit("v3.scalar_triple", [v3(), v3(), v3()], &Vec3.scalar_triple/3) end)
    times(n, fn -> emit("v3.weighted_sum", [r(), v3(), r(), v3()], &Vec3.weighted_sum/4) end)
    times(n, fn -> emit("v3.near", [v3(), v3(), rp()], &Vec3.near/3) end)
    times(n, fn -> emit("v3.equal3", [v3(), v3(), rp()], &Vec3.equal/3) end)
    times(n, fn -> emit("v3.create3", [r(), r(), r()], &Vec3.create/3) end)
    times(n, fn -> emit("v3.create1", [[r(), r(), r()]], &Vec3.create/1) end)
    times(n, fn -> emit("v3.random_sphere", [], &Vec3.random_sphere/0) end)
    times(n, fn -> emit("v3.random_ball", [], &Vec3.random_ball/0) end)
    times(n, fn -> emit("v3.random_box", [], &Vec3.random_box/0) end)

    # ---------------- Vec4
    times(n, fn -> emit("v4.add", [v4(), v4()], &Vec4.add/2) end)
    times(n, fn -> emit("v4.subtract", [v4(), v4()], &Vec4.subtract/2) end)
    times(n, fn -> emit("v4.multiply", [v4(), v4()], &Vec4.multiply/2) end)
    times(n, fn -> emit("v4.scale", [v4(), r()], &Vec4.scale/2) end)
    times(n, fn -> emit("v4.dot", [v4(), v4()], &Vec4.dot/2) end)
    times(n, fn -> emit("v4.length", [v4()], &Vec4.length/1) end)
    times(n, fn -> emit("v4.length_squared", [v4()], &Vec4.length_squared/1) end)
    times(n, fn -> emit("v4.length_manhattan", [v4()], &Vec4.length_manhattan/1) end)
    times(n, fn -> emit("v4.chebyshev_distance", [v4(), v4()], &Vec4.chebyshev_distance/2) end)

    times(n, fn ->
      emit("v4.minkowski_distance", [v4(), v4(), rp()], &Vec4.minkowski_distance/3)
    end)

    times(n, fn -> emit("v4.p_norm", [v4(), rp()], &Vec4.p_norm/2) end)
    times(n, fn -> emit("v4.lerp", [v4(), v4(), :rand.uniform()], &Vec4.lerp/3) end)
    times(n, fn -> emit("v4.negate", [v4()], &Vec4.negate/1) end)
    times(n, fn -> emit("v4.normalize", [v4()], &Vec4.normalize/1) end)
    times(n, fn -> emit("v4.project", [v4(), v4()], &Vec4.project/2) end)
    times(n, fn -> emit("v4.weighted_sum", [r(), v4(), r(), v4()], &Vec4.weighted_sum/4) end)
    times(n, fn -> emit("v4.near", [v4(), v4(), rp()], &Vec4.near/3) end)
    times(n, fn -> emit("v4.equal3", [v4(), v4(), rp()], &Vec4.equal/3) end)
    times(n, fn -> emit("v4.create4", [r(), r(), r(), r()], &Vec4.create/4) end)
    times(n, fn -> emit("v4.create1", [[r(), r(), r(), r()]], &Vec4.create/1) end)
    times(n, fn -> emit("v4.from_point3", [v3()], &Vec4.from_point3/1) end)
    times(n, fn -> emit("v4.from_direction3", [v3()], &Vec4.from_direction3/1) end)

    # ---------------- Mat22
    emit("m22.identity", [], &Mat22.identity/0)
    emit("m22.zero", [], &Mat22.zero/0)
    times(n, fn -> emit("m22.add", [m2(), m2()], &Mat22.add/2) end)
    times(n, fn -> emit("m22.subtract", [m2(), m2()], &Mat22.subtract/2) end)
    times(n, fn -> emit("m22.scale", [m2(), r()], &Mat22.scale/2) end)
    times(n, fn -> emit("m22.multiply", [m2(), m2()], &Mat22.multiply/2) end)
    times(n, fn -> emit("m22.multiply_transpose", [m2(), m2()], &Mat22.multiply_transpose/2) end)
    times(n, fn -> emit("m22.apply", [m2(), v2()], &Mat22.apply/2) end)
    times(n, fn -> emit("m22.apply_left", [v2(), m2()], &Mat22.apply_left/2) end)
    times(n, fn -> emit("m22.apply_transpose", [m2(), v2()], &Mat22.apply_transpose/2) end)

    times(n, fn ->
      emit("m22.apply_left_transpose", [v2(), m2()], &Mat22.apply_left_transpose/2)
    end)

    times(n, fn -> emit("m22.transform_vector", [m2(), v2()], &Mat22.transform_vector/2) end)
    for i <- 0..1, j <- 0..1, do: emit("m22.at", [m2(), i, j], &Mat22.at/3)
    times(n, fn -> emit("m22.row0", [m2()], &Mat22.row0/1) end)
    times(n, fn -> emit("m22.row1", [m2()], &Mat22.row1/1) end)
    times(n, fn -> emit("m22.column0", [m2()], &Mat22.column0/1) end)
    times(n, fn -> emit("m22.column1", [m2()], &Mat22.column1/1) end)
    times(n, fn -> emit("m22.diag", [m2()], &Mat22.diag/1) end)
    times(n, fn -> emit("m22.determinant", [m2()], &Mat22.determinant/1) end)
    times(n, fn -> emit("m22.trace", [m2()], &Mat22.trace/1) end)
    times(n, fn -> emit("m22.inverse", [m2()], &Mat22.inverse/1) end)
    times(n, fn -> emit("m22.round", [m2(), 2], &Mat22.round/2) end)
    times(n, fn -> emit("m22.make_rotate", [ang()], &Mat22.make_rotate/1) end)
    times(n, fn -> emit("m22.make_scale1", [r()], &Mat22.make_scale/1) end)
    times(n, fn -> emit("m22.make_scale2", [r(), r()], &Mat22.make_scale/2) end)
    times(n, fn -> emit("m22.make_reflect", [v2()], &Mat22.make_reflect/1) end)
    times(n, fn -> emit("m22.make_shear_x", [r()], &Mat22.make_shear_x/1) end)
    times(n, fn -> emit("m22.make_shear_y", [r()], &Mat22.make_shear_y/1) end)

    # ---------------- Mat33
    emit("m33.identity", [], &Mat33.identity/0)
    emit("m33.zero", [], &Mat33.zero/0)
    times(n, fn -> emit("m33.add", [m3(), m3()], &Mat33.add/2) end)
    times(n, fn -> emit("m33.subtract", [m3(), m3()], &Mat33.subtract/2) end)
    times(n, fn -> emit("m33.scale", [m3(), r()], &Mat33.scale/2) end)
    times(n, fn -> emit("m33.multiply", [m3(), m3()], &Mat33.multiply/2) end)
    times(n, fn -> emit("m33.multiply_transpose", [m3(), m3()], &Mat33.multiply_transpose/2) end)
    times(n, fn -> emit("m33.apply", [m3(), v3()], &Mat33.apply/2) end)
    times(n, fn -> emit("m33.apply_left", [v3(), m3()], &Mat33.apply_left/2) end)
    times(n, fn -> emit("m33.apply_transpose", [m3(), v3()], &Mat33.apply_transpose/2) end)

    times(n, fn ->
      emit("m33.apply_left_transpose", [v3(), m3()], &Mat33.apply_left_transpose/2)
    end)

    times(n, fn -> emit("m33.transform_point", [m3(), v2()], &Mat33.transform_point/2) end)
    times(n, fn -> emit("m33.transform_vector", [m3(), v2()], &Mat33.transform_vector/2) end)
    for i <- 0..2, j <- 0..2, do: emit("m33.at", [m3(), i, j], &Mat33.at/3)
    for i <- 0..2, j <- 0..2, do: emit("m33.submatrix", [m3(), i, j], &Mat33.submatrix/3)
    for i <- 0..2, j <- 0..2, do: emit("m33.cofactor", [m3(), i, j], &Mat33.cofactor/3)
    times(n, fn -> emit("m33.row0", [m3()], &Mat33.row0/1) end)
    times(n, fn -> emit("m33.row1", [m3()], &Mat33.row1/1) end)
    times(n, fn -> emit("m33.row2", [m3()], &Mat33.row2/1) end)
    times(n, fn -> emit("m33.column0", [m3()], &Mat33.column0/1) end)
    times(n, fn -> emit("m33.column1", [m3()], &Mat33.column1/1) end)
    times(n, fn -> emit("m33.column2", [m3()], &Mat33.column2/1) end)
    times(n, fn -> emit("m33.diag", [m3()], &Mat33.diag/1) end)
    times(n, fn -> emit("m33.determinant", [m3()], &Mat33.determinant/1) end)
    times(n, fn -> emit("m33.trace", [m3()], &Mat33.trace/1) end)
    times(n, fn -> emit("m33.inverse", [m3()], &Mat33.inverse/1) end)
    times(n, fn -> emit("m33.round", [m3(), 3], &Mat33.round/2) end)
    times(n, fn -> emit("m33.make_rotate", [ang()], &Mat33.make_rotate/1) end)
    times(n, fn -> emit("m33.make_translate", [r(), r()], &Mat33.make_translate/2) end)
    times(n, fn -> emit("m33.make_scale1", [r()], &Mat33.make_scale/1) end)
    times(n, fn -> emit("m33.make_scale3", [r(), r(), r()], &Mat33.make_scale/3) end)
    times(n, fn -> emit("m33.make_reflect_2d", [v2(), r()], &Mat33.make_reflect_2d/2) end)
    times(n, fn -> emit("m33.make_reflect_3d", [v3()], &Mat33.make_reflect_3d/1) end)
    times(n, fn -> emit("m33.make_shear_x_2d", [r()], &Mat33.make_shear_x_2d/1) end)
    times(n, fn -> emit("m33.make_shear_y_2d", [r()], &Mat33.make_shear_y_2d/1) end)
    times(n, fn -> emit("m33.make_shear_x_3d", [r(), r()], &Mat33.make_shear_x_3d/2) end)
    times(n, fn -> emit("m33.make_shear_y_3d", [r(), r()], &Mat33.make_shear_y_3d/2) end)
    times(n, fn -> emit("m33.make_shear_z_3d", [r(), r()], &Mat33.make_shear_z_3d/2) end)
    times(n, fn -> emit("m33.orthonormalize", [m3()], &Mat33.orthonormalize/1) end)

    # ---------------- Mat44
    emit("m44.identity", [], &Mat44.identity/0)
    emit("m44.zero", [], &Mat44.zero/0)
    times(n, fn -> emit("m44.add", [m4(), m4()], &Mat44.add/2) end)
    times(n, fn -> emit("m44.subtract", [m4(), m4()], &Mat44.subtract/2) end)
    times(n, fn -> emit("m44.scale", [m4(), r()], &Mat44.scale/2) end)
    times(n, fn -> emit("m44.multiply", [m4(), m4()], &Mat44.multiply/2) end)
    times(n, fn -> emit("m44.multiply_transpose", [m4(), m4()], &Mat44.multiply_transpose/2) end)
    times(n, fn -> emit("m44.apply", [m4(), v4()], &Mat44.apply/2) end)
    times(n, fn -> emit("m44.apply_left", [v4(), m4()], &Mat44.apply_left/2) end)
    times(n, fn -> emit("m44.apply_transpose", [m4(), v4()], &Mat44.apply_transpose/2) end)

    times(n, fn ->
      emit("m44.apply_left_transpose", [v4(), m4()], &Mat44.apply_left_transpose/2)
    end)

    times(n, fn -> emit("m44.transform_point", [m4(), v3()], &Mat44.transform_point/2) end)
    times(n, fn -> emit("m44.transform_vector", [m4(), v3()], &Mat44.transform_vector/2) end)
    for i <- 0..3, j <- 0..3, do: emit("m44.at", [m4(), i, j], &Mat44.at/3)
    for i <- 0..3, j <- 0..3, do: emit("m44.submatrix", [m4(), i, j], &Mat44.submatrix/3)
    for i <- 0..3, j <- 0..3, do: emit("m44.cofactor", [m4(), i, j], &Mat44.cofactor/3)
    times(n, fn -> emit("m44.row0", [m4()], &Mat44.row0/1) end)
    times(n, fn -> emit("m44.row1", [m4()], &Mat44.row1/1) end)
    times(n, fn -> emit("m44.row2", [m4()], &Mat44.row2/1) end)
    times(n, fn -> emit("m44.row3", [m4()], &Mat44.row3/1) end)
    times(n, fn -> emit("m44.column0", [m4()], &Mat44.column0/1) end)
    times(n, fn -> emit("m44.column1", [m4()], &Mat44.column1/1) end)
    times(n, fn -> emit("m44.column2", [m4()], &Mat44.column2/1) end)
    times(n, fn -> emit("m44.column3", [m4()], &Mat44.column3/1) end)
    times(n, fn -> emit("m44.diag", [m4()], &Mat44.diag/1) end)
    times(n, fn -> emit("m44.determinant", [m4()], &Mat44.determinant/1) end)
    times(n, fn -> emit("m44.trace", [m4()], &Mat44.trace/1) end)
    times(n, fn -> emit("m44.inverse", [m4()], &Mat44.inverse/1) end)
    times(n, fn -> emit("m44.round", [m4(), 3], &Mat44.round/2) end)
    times(n, fn -> emit("m44.make_rotate_x", [ang()], &Mat44.make_rotate_x/1) end)
    times(n, fn -> emit("m44.make_rotate_y", [ang()], &Mat44.make_rotate_y/1) end)
    times(n, fn -> emit("m44.make_rotate_z", [ang()], &Mat44.make_rotate_z/1) end)
    times(n, fn -> emit("m44.make_translate", [r(), r(), r()], &Mat44.make_translate/3) end)
    times(n, fn -> emit("m44.make_scale1", [r()], &Mat44.make_scale/1) end)
    times(n, fn -> emit("m44.make_scale4", [r(), r(), r(), r()], &Mat44.make_scale/4) end)
    times(n, fn -> emit("m44.make_reflect", [v3(), r()], &Mat44.make_reflect/2) end)
    times(n, fn -> emit("m44.make_shear_x", [r(), r()], &Mat44.make_shear_x/2) end)
    times(n, fn -> emit("m44.make_shear_y", [r(), r()], &Mat44.make_shear_y/2) end)
    times(n, fn -> emit("m44.make_shear_z", [r(), r()], &Mat44.make_shear_z/2) end)
    times(n, fn -> emit("m44.orient", [v3(), v3(), v3()], &Mat44.orient/3) end)
    times(n, fn -> emit("m44.look_at", [v3(), v3(), v3()], &Mat44.look_at/3) end)
    times(n, fn -> emit("m44.make_billboard", [v3(), v3(), v3()], &Mat44.make_billboard/3) end)

    times(n, fn ->
      emit("m44.make_billboard_axis", [v3(), v3(), v3()], &Mat44.make_billboard_axis/3)
    end)

    times(n, fn ->
      emit(
        "m44.perspective",
        [:rand.uniform() * 2.5 + 0.3, rp(), rp() * 0.2, rp() * 10 + 5],
        &Mat44.perspective/4
      )
    end)

    times(n, fn ->
      {a, b} = {r(), r()}
      {c, d} = {r(), r()}
      {e, f} = {r(), r()}
      emit("m44.ortho", [a, b, c, d, e, f], &Mat44.ortho/6)
    end)

    # ---------------- Quatern
    emit("q.identity", [], &Quatern.identity/0)
    emit("q.zero", [], &Quatern.zero/0)
    times(n, fn -> emit("q.create", [r(), r(), r(), r()], &Quatern.create/4) end)
    times(n, fn -> emit("q.from_list", [[r(), r(), r(), r()]], &Quatern.from_list/1) end)
    times(n, fn -> emit("q.add", [v4(), v4()], &Quatern.add/2) end)
    times(n, fn -> emit("q.subtract", [v4(), v4()], &Quatern.subtract/2) end)
    times(n, fn -> emit("q.multiply", [v4(), v4()], &Quatern.multiply/2) end)
    times(n, fn -> emit("q.scale", [v4(), r()], &Quatern.scale/2) end)
    times(n, fn -> emit("q.dot", [v4(), v4()], &Quatern.dot/2) end)
    times(n, fn -> emit("q.norm", [v4()], &Quatern.norm/1) end)
    times(n, fn -> emit("q.normalize", [v4()], &Quatern.normalize/1) end)
    times(n, fn -> emit("q.normalize_strict", [v4()], &Quatern.normalize_strict/1) end)
    times(n, fn -> emit("q.conjugate", [v4()], &Quatern.conjugate/1) end)
    times(n, fn -> emit("q.inverse", [v4()], &Quatern.inverse/1) end)
    times(n, fn -> emit("q.equal", [v4(), v4()], &Quatern.equal/2) end)

    times(n, fn ->
      a = v4()
      emit("q.equal", [a, a], &Quatern.equal/2)
    end)

    times(n, fn -> emit("q.equal_elements", [v4(), v4(), rp()], &Quatern.equal_elements/3) end)
    times(n, fn -> emit("q.from_axis_angle", [ang(), unit3()], &Quatern.from_axis_angle/2) end)
    times(n, fn -> emit("q.to_rotation_matrix_33", [uq()], &Quatern.to_rotation_matrix_33/1) end)
    times(n, fn -> emit("q.to_rotation_matrix_44", [uq()], &Quatern.to_rotation_matrix_44/1) end)
    times(n, fn -> emit("q.transform_vector", [uq(), v3()], &Quatern.transform_vector/2) end)
    # from_rotation_matrix: feed a matrix from a known quaternion; also feed negative-trace cases
    times(n, fn ->
      q = uq()

      emit(
        "q.from_rotation_matrix",
        [Quatern.to_rotation_matrix_33(q)],
        &Quatern.from_rotation_matrix/1
      )
    end)

    for ax <- [{1.0, 0.0, 0.0}, {0.0, 1.0, 0.0}, {0.0, 0.0, 1.0}],
        th <- [3.0, -3.0, :math.pi()] do
      q = Quatern.from_axis_angle(th, ax)

      emit(
        "q.from_rotation_matrix",
        [Quatern.to_rotation_matrix_33(q)],
        &Quatern.from_rotation_matrix/1
      )
    end

    times(n, fn -> emit("q.slerp", [uq(), uq(), :rand.uniform()], &Quatern.slerp/3) end)

    times(3, fn ->
      q = uq()
      emit("q.slerp", [q, Quatern.scale(q, -1.0), :rand.uniform()], &Quatern.slerp/3)
    end)

    times(3, fn ->
      q = uq()
      emit("q.slerp", [q, q, :rand.uniform()], &Quatern.slerp/3)
    end)

    times(n, fn ->
      emit("q.integrate", [uq(), v3(), :rand.uniform() * 0.5], &Quatern.integrate/3)
    end)

    times(3, fn -> emit("q.integrate", [uq(), v3(), 1.0e-9], &Quatern.integrate/3) end)
    times(n, fn -> emit("q.random", [], &Quatern.random/0) end)
    # euler extraction against single-axis rotations
    times(n, fn ->
      th = ang()

      emit("q.get_roll_z", [th], fn t ->
        Quatern.get_roll(Quatern.from_axis_angle(t, {0.0, 0.0, 1.0}))
      end)
    end)

    times(n, fn ->
      th = ang()

      emit("q.get_pitch_x", [th], fn t ->
        Quatern.get_pitch(Quatern.from_axis_angle(t, {1.0, 0.0, 0.0}))
      end)
    end)

    times(n, fn ->
      th = ang()

      emit("q.get_yaw_y", [th], fn t ->
        Quatern.get_yaw(Quatern.from_axis_angle(t, {0.0, 1.0, 0.0}))
      end)
    end)

    times(n, fn ->
      q = uq()

      emit("q.euler", [q], fn q ->
        {Quatern.get_roll(q), Quatern.get_pitch(q), Quatern.get_yaw(q)}
      end)
    end)

    # --- documented error cases and edge cases
    times(2, fn -> emit("q.equal", [uq(), uq()], &Quatern.equal/2) end)

    times(3, fn ->
      q = uq()
      emit("q.equal", [q, Quatern.scale(q, -1.0)], &Quatern.equal/2)
    end)

    times(3, fn ->
      q = uq()
      emit("q.equal", [q, q], &Quatern.equal/2)
    end)

    emit("err.v2.project_zero", [v2(), {0.0, 0.0}], &Vec2.project/2)
    emit("err.v4.project_zero", [v4(), {0.0, 0.0, 0.0, 0.0}], &Vec4.project/2)
    emit("err.m22.make_reflect_zero", [{0.0, 0.0}], &Mat22.make_reflect/1)
    emit("err.m33.make_reflect_2d_zero", [{0.0, 0.0}, 1.0], &Mat33.make_reflect_2d/2)
    emit("err.m33.make_reflect_3d_zero", [{0.0, 0.0, 0.0}], &Mat33.make_reflect_3d/1)
    emit("err.m44.make_reflect_zero", [{0.0, 0.0, 0.0}, 1.0], &Mat44.make_reflect/2)

    emit(
      "err.m33.orthonormalize_zero_row",
      [{0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0, 0.0}],
      &Mat33.orthonormalize/1
    )

    emit(
      "err.m33.orthonormalize_dependent",
      [{1.0, 0.0, 0.0, 2.0, 0.0, 0.0, 0.0, 1.0, 0.0}],
      &Mat33.orthonormalize/1
    )

    emit(
      "err.m33.orthonormalize_coplanar",
      [{1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 1.0, 1.0, 0.0}],
      &Mat33.orthonormalize/1
    )

    emit("err.m44.orient_zero_fwd", [v3(), {0.0, 0.0, 0.0}, {0.0, 1.0, 0.0}], &Mat44.orient/3)
    emit("err.m44.orient_parallel_up", [v3(), {0.0, 2.0, 0.0}, {0.0, -1.0, 0.0}], &Mat44.orient/3)

    emit(
      "err.m44.look_at_coincident",
      [{1.0, 2.0, 3.0}, {1.0, 2.0, 3.0}, {0.0, 1.0, 0.0}],
      &Mat44.look_at/3
    )

    emit(
      "err.m44.look_at_zero_up",
      [{1.0, 2.0, 3.0}, {0.0, 0.0, 0.0}, {0.0, 0.0, 0.0}],
      &Mat44.look_at/3
    )

    emit(
      "err.m44.billboard_coincident",
      [{1.0, 2.0, 3.0}, {1.0, 2.0, 3.0}, {0.0, 1.0, 0.0}],
      &Mat44.make_billboard/3
    )

    emit(
      "err.m44.billboard_axis_on_axis",
      [{0.0, 0.0, 0.0}, {0.0, 5.0, 0.0}, {0.0, 1.0, 0.0}],
      &Mat44.make_billboard_axis/3
    )

    emit(
      "err.m44.billboard_axis_zero_axis",
      [{0.0, 0.0, 0.0}, {0.0, 5.0, 0.0}, {0.0, 0.0, 0.0}],
      &Mat44.make_billboard_axis/3
    )

    emit("err.m44.perspective_fov0", [0.0, 1.0, 0.1, 10.0], &Mat44.perspective/4)
    emit("err.m44.perspective_fovpi", [:math.pi(), 1.0, 0.1, 10.0], &Mat44.perspective/4)
    emit("err.m44.perspective_aspect0", [1.0, 0.0, 0.1, 10.0], &Mat44.perspective/4)
    emit("err.m44.perspective_near0", [1.0, 1.0, 0.0, 10.0], &Mat44.perspective/4)
    emit("err.m44.perspective_near_ge_far", [1.0, 1.0, 10.0, 10.0], &Mat44.perspective/4)
    emit("err.m44.ortho_x_equal", [1.0, 1.0, 0.0, 1.0, 0.0, 1.0], &Mat44.ortho/6)
    emit("err.m44.ortho_y_equal", [0.0, 1.0, 1.0, 1.0, 0.0, 1.0], &Mat44.ortho/6)
    emit("err.m44.ortho_z_equal", [0.0, 1.0, 0.0, 1.0, 2.0, 2.0], &Mat44.ortho/6)
    emit("err.m22.inverse_singular", [{1.0, 2.0, 2.0, 4.0}], &Mat22.inverse/1)

    emit(
      "err.m33.inverse_singular",
      [{1.0, 2.0, 3.0, 2.0, 4.0, 6.0, 0.0, 0.0, 1.0}],
      &Mat33.inverse/1
    )

    emit("err.m44.inverse_singular", [Mat44.zero()], &Mat44.inverse/1)
    emit("err.q.normalize_strict_zero", [{0.0, 0.0, 0.0, 0.0}], &Quatern.normalize_strict/1)
    emit("edge.q.normalize_zero", [{0.0, 0.0, 0.0, 0.0}], &Quatern.normalize/1)
    emit("edge.q.inverse_zero", [{0.0, 0.0, 0.0, 0.0}], &Quatern.inverse/1)
    emit("edge.q.integrate_zero_q", [{0.0, 0.0, 0.0, 0.0}, v3(), 0.1], &Quatern.integrate/3)
    emit("edge.q.integrate_zero_omega", [uq(), {0.0, 0.0, 0.0}, 0.1], &Quatern.integrate/3)
    emit("edge.q.integrate_zero_dt", [uq(), v3(), 0.0], &Quatern.integrate/3)
    emit("edge.v3.normalize_zero", [{0.0, 0.0, 0.0}], &Vec3.normalize/1)
    emit("edge.v2.normalize_zero", [{0.0, 0.0}], &Vec2.normalize/1)
    emit("edge.v4.normalize_zero", [{0.0, 0.0, 0.0, 0.0}], &Vec4.normalize/1)
    emit("edge.v2.near_exact", [{0.0, 0.0}, {3.0, 4.0}, 5.0], &Vec2.near/3)
    emit("edge.v3.create_ints", [[1, 2, 3]], &Vec3.create/1)
    emit("edge.q.from_list_ints", [[1, 0, 0, 0]], &Quatern.from_list/1)
    # doc examples
    emit("edge.m44.orient_doc", [{2.0, 3.0, 4.0}, {0.0, 0.0, -1.0}, {0.0, 1.0, 0.0}], fn p,
                                                                                         f,
                                                                                         u ->
      Mat44.transform_point(Mat44.orient(p, f, u), {1.0, 2.0, -3.0})
    end)

    emit("edge.m44.look_at_doc", [{0.0, 0.0, 5.0}, {0.0, 0.0, 0.0}, {0.0, 1.0, 0.0}], fn e,
                                                                                         c,
                                                                                         u ->
      Mat44.transform_point(Mat44.look_at(e, c, u), {2.0, 3.0, 0.0})
    end)

    emit("edge.m44.perspective_doc", [], fn ->
      {x, y, z, w} =
        Mat44.apply_left({0.0, 0.0, -1.0, 1.0}, Mat44.perspective(:math.pi() / 2, 1.0, 1.0, 3.0))

      {x / w, y / w, z / w}
    end)

    emit("edge.m44.perspective_far", [], fn ->
      {x, y, z, w} =
        Mat44.apply_left({0.0, 0.0, -3.0, 1.0}, Mat44.perspective(:math.pi() / 2, 1.0, 1.0, 3.0))

      {x / w, y / w, z / w}
    end)

    emit("edge.m44.ortho_doc", [], fn ->
      Mat44.transform_point(Mat44.ortho(-2.0, 6.0, -4.0, 4.0, 1.0, 3.0), {2.0, 0.0, -2.0})
    end)

    emit("edge.m44.rotate_y_doc", [], fn ->
      Mat44.transform_vector(Mat44.make_rotate_y(:math.pi() / 2), {1.0, 0.0, 0.0})
    end)

    emit(
      "edge.m33.orthonormalize_doc",
      [{2.0, 0.0, 0.0, 1.0, 3.0, 0.0, 4.0, 5.0, 6.0}],
      &Mat33.orthonormalize/1
    )

    finish()
    IO.puts("wrote #{Process.get(:k)} cases")
  end
end

Main.run()
