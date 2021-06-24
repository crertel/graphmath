# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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