# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- Added changelog! Finally!
- Non-crashing `Quatern.normalize/1` which can deal with zero-magnitude quaternions.
- Add `Quatern.identity/0` to make identity quaternions.
- Add `Quatern.equals/2` to compare two quaternions for equality.
- Add `Quatern.to_rotation_matrix_44/1`.
- Add `Quatern.from_axis_angle_packed/1`.

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