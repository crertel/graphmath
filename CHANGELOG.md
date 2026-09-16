# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.0.0] - Unreleased

### Added

- Add `Mat22` for 2x2 matrix arithmetic, inversion, trace, determinant, and 2D linear transforms.
- Add `Vec4` arithmetic and explicit homogeneous point (`w = 1`) and direction (`w = 0`) constructors.
- Add `trace/1`, `determinant/1`, `submatrix/3`, and `cofactor/3` to `Mat33` and `Mat44`.
- Add `Mat33.orthonormalize/1` for row bases, preserving handedness and rejecting degenerate inputs.
- Add reflection and shear constructors to `Mat22`, `Mat33`, and `Mat44`. Mat33 names explicitly distinguish 2D affine transforms from 3D linear transforms.
- Add `Mat44.orient/3`, `look_at/3`, `make_billboard/3`, and `make_billboard_axis/3` with right-handed, -Z-forward camera conventions.
- Add `Mat44.perspective/4` and `ortho/6` with normalized device depth in [-1, +1]. Perspective projection requires an explicit divide by the resulting homogeneous coordinate.
- Add Benchee benchmarks for Vec2, Vec3, Mat33, Mat44, and Quatern operations.
- Expand numeric, boundary, random, and transform tests, and enforce 100% library line coverage in CI.

### Changed

- Move CI to GitHub Actions and remove CircleCI configuration and reporting.
- Document matrix storage, row-vector graphics transforms, composition order, quaternion components, and world-space angular velocity for quaternion integration.
- Convert integer components to floats in `Vec3.create/1` and `Quatern.from_list/1`, matching their documented representation.

### Fixed

- Correct quaternion-to-matrix conversions to produce row-vector rotation matrices consistent with the matrix transform helpers.
- Correct `Quatern.from_rotation_matrix/1` rotation direction, diagonal selection, and `{w, x, y, z}` component order, including rotations with nonpositive trace.
- Correct `Mat44.make_rotate_y/1` to agree with right-handed vector and quaternion rotations.
- Make `Quatern.slerp/3` follow the shortest arc and handle opposite-sign representations of the same orientation without producing the zero quaternion.
- Make `Vec2.length_manhattan/1` and `Vec3.length_manhattan/1` sum absolute component values.
- Correct the August 2024 changelog heading to identify the published 2.6.0 release.

### Upgrading from 2.x

- Update the dependency requirement to `{:graphmath, "~> 3.0.0"}`. The minimum Elixir requirement remains `~> 1.15`.
- Review workarounds for rotation direction. `Quatern.to_rotation_matrix_33/1` and `to_rotation_matrix_44/1` now return the transpose of their previous results; `Quatern.from_rotation_matrix/1` expects the corresponding row-vector convention. Use `Mat33.apply_left/2` for full 3D row vectors or the Mat44 point/vector transform helpers. `apply/2` still computes a column-vector product.
- Remove any angle negation used to compensate for `Mat44.make_rotate_y/1`. A positive quarter-turn about Y now transforms +X toward -Z.
- Treat quaternion interpolation endpoints as orientations. `Quatern.slerp/3` can return the negation of the second quaternion at `t = 1` to select the shortest arc. Use `Quatern.equal/2` or `equal/3` for orientation comparisons.
- Expect nonnegative Manhattan lengths for vectors with negative components. For example, `Vec2.length_manhattan({-3.0, 4.0})` now returns `7.0`.
- Update integer-specific pattern matches or strict equality checks on results of `Vec3.create/1` and `Quatern.from_list/1`: these constructors now return floats for integer inputs.

## [2.6.0] - 2024-08-03
### Added
 - Added `is_float` hints to all modules.
 - Removed moduledoc for util and root module.

## [2.5.0] - 2021-06-14
### Added
- Added `Vec2.minkowski_distance/3`.
- Added `Vec3.minkowski_distance/3`.
- Added `Vec2.chebyshev_distance/3`.
- Added `Vec3.chebyshev_distance/3`.
- Added `Vec2.p_norm/2`.
- Added `Vec3.p_norm/2`.

### Changed
- Update to require Elixir 12.1.
- Update credo to 1.5.6.
- Update dialyxir to 1.1.0.
- Update ex_doc to 0.24.2.
- Update excoveralls to 0.14.1.
- Update use of `:random.uniform/0` to be `:rand.uniform/0`.

## [2.4.0] - 2019-07-28
### Added
- Add `Vec3.scalar_triple` product for vec3s.

## [2.3.0] - 2019-07-25
### Added
- Add `Vec2.negate/1` for negating vectors.
- Add `Vec3.negate/1` for negating vectors.
- Add `Vec2.weighted_sum/4` for summing vectors.
- Add `Vec3.weighted_sum/4` for summing vectors.

## [2.2.0] - 2019-07-10
### Added
- Add `Quatern.random/0` for generating random quaternions.
- Add `Vec2.random_circle/0` for generating vec2s on a unit circle.
- Add `Vec2.random_disc/0` for generating vec2s on a unit disc.
- Add `Vec2.random_square/0` for generating vec2s on unit square.
- Add `Vec3.random_box/0` for generating vec3s inside a unit box.
- Add `Vec3.random_sphere/0` for generating vec3s on a unit sphere.
- Add `Vec3.random_ball/0` for generating vec3s on or inside the unit sphere.

## [2.1.0] - 2019-06-20
### Added
- Add `Quatern.transform_vector/2` to transform a vector by a quaternion.
- Add `Vec3.equal/2` to compare two vec3s for equality.
- Add `Vec3.equal/3` to compare two vec3s for equality within a threshold.
- Add `Vec2.equal/2` to compare two vec2s for equality.
- Add `Vec2.equal/3` to compare two vec2s for equality within a threshold.

## [2.0.0] - 2019-06-20
### Added
- Added changelog! Finally!
- Non-crashing `Quatern.normalize/1` which can deal with zero-magnitude quaternions.
- Add `Quatern.identity/0` to make identity quaternions.
- Add `Quatern.equal/2` to compare two unit quaternions for orientation equality.
- Add `Quatern.equal/3` to compare two unit quaternions for orientation equality with a threshold.
- Add `Quatern.equal_elements/2` to compare two quaternions for element-wise equality.
- Add `Quatern.equal_elements/3` to compare two quaternions for element-wise equality with a threshold.
- Add `Quatern.to_rotation_matrix_44/1`.
- Add `Quatern.integrate/3`.

### Changed
- Old `Quatern.normalize/1` has become `Quatern.normalize_strict/1`.
- Clarified documentation on `Quatern.conjugate/1`.
- Renamed `Quatern.create/0` to `Quatern.zero/0`.
- Renamed `Quatern.create/1` to `Quatern.from_list/0`.
- Renamed `Quatern.create/2` to `Quatern.from_axis_angle/2`; changed implementation.
- Renamed `Quatern.to_rotation_matrix/1` to `Quatern.to_rotation_matrix_33/`

### Removed
- Removed `Quatern.zero/0`.
- Removed `Quatern.create/0`.
- Removed `Quatern.create/1`.
- Removed `Quatern.create/2`.
- Removed `Quatern.to_rotation_matrix/1`.

### Fixed
- Formatting fixes to readme.
- Fixed logic insinde `Quatern.from_axis_angle/2`.

## [1.0.7] - 2019-05-29
### Removed
- Remove TravisCI.
- Various Coveralls and CircleCI work.

## [1.0.6] - 2019-03-14
### Fixed
- Apppease dialyzer and fix mix format issues.

## [1.0.5] - 2019-03-14
### Fixed
- Appease credo warnings.

## [1.0.4] - 2019-03-14
### Added
- Added CirclCI.

## [1.0.3] - 2016-07-22
### Removed
- Remove doc artifacts from repo, update doc generation with help from @RobertDober

## [1.0.2] - 2016-02-08
### Fixed
- Fix buggy `Graphmath.Vec2.Rotate`.

## [1.0.1] - 2015-02-15
### Added
- Complete unit tests for `Graphmath.Quatern`.

## [1.0.0] - 2015-01-29
### Added
- First public release.

## [major.minor.patch] - 1234-56-78
### Added
### Changed
### Deprecated
### Removed
### Fixed
### Security
