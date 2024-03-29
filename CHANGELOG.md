# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

- Update `bundler` development dependency for CVE-2021-43809

## [0.4.0] - 2021-05-30

This release updates dependencies, changes the minimum Ruby version to 2.6, and adds support for Ruby version 3.

### Added

- Ruby version 3 is now supported.

### Changed

- The minimum required Ruby version is now 2.6.
- Dependencies have been updated.


## [0.3.3] - 2019-07-22

### Fixed

- When using the `_default.key` syntax to fetch to generate default values,
  the prefix was dropped using the `key_tree ~>0.5` api (inherited from
  Array#drop) instead of the proper `key_tree ~>0.6` api that takes the prefix
  to drop.


## [0.3.2] - 2019-07-16

### Fixed

- When using the `^.key` syntax to fetch a parent key, the prefix was
  dropped using the `key_tree ~>0.5` api (inhertited from Array#drop)
  instead of the proper `key_tree ~>0.6` api that takes the prefix to drop.


## [0.3.1] - 2019-07-05

### Fixed

- There was a debug print statement in numeric default value generation


## [0.3.0] - 2019-07-05

### Added
- Numeric default values
  - integer: for rounded integer values
  - float: for floating point values
  - both types also support summarizing functions
  	- sum: arithmetic sum of the values
  	- product: arithmetic product of the values
  	- arithmetic_mean: the [arithmetic mean] of the values
  	- geometric_mean: the [geometric mean] of the values
  	- harmonic_mean: the [harmonic mean] of the values

[arithmethic mean]: https://en.wikipedia.org/wiki/Mean#Arithmetic_mean_(AM)
[geometric mean]: https://en.wikipedia.org/wiki/Mean#Geometric_mean_(GM)
[harmonic mean]: https://en.wikipedia.org/wiki/Mean#Harmonic_mean_(HM)

### Changed
- Default value arguments used to be wrapped in arrays based on responding
  to `#enum`, but are now based on `#to_ary`, to ensure that hashes are also
  wrapped.


## [Older]
These releases have no change logs.


[Unreleased]: https://github.com/notCalle/ruby-dagger/compare/v0.4.0..HEAD
[0.4.0]: https://github.com/notCalle/ruby-dagger/compare/v0.3.3..v0.4.0
[0.3.3]: https://github.com/notCalle/ruby-dagger/compare/v0.3.2..v0.3.3
[0.3.2]: https://github.com/notCalle/ruby-dagger/compare/v0.3.1..v0.3.2
[0.3.1]: https://github.com/notCalle/ruby-dagger/compare/v0.3.0..v0.3.1
[0.3.0]: https://github.com/notCalle/ruby-dagger/compare/v0.2.1..v0.3.0
[Older]: https://github.com/notCalle/ruby-dagger/releases/tag/v0.2.1
