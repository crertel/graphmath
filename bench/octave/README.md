# Octave cross-check

Independent numerical verification of every public function in
`Graphmath.{Vec2,Vec3,Vec4,Mat22,Mat33,Mat44,Quatern}` against GNU Octave.

```
bench/octave/run.sh            # needs mix + octave-cli on PATH
```

`gen_cases.exs` calls each function with seeded random inputs (plus documented
error and edge cases) and writes the arguments and results to an Octave data
file. `check.m` recomputes each result from the documented conventions and
prints the maximum relative error per function, flagging anything above 1e-9.
Cases named `err.*` / `edge.*` are listed in the data file for inspection only.
