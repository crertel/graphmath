[![CircleCI](https://circleci.com/gh/crertel/graphmath.svg?style=svg)](https://circleci.com/gh/crertel/graphmath)
[![Inline docs](http://inch-ci.org/github/crertel/graphmath.svg)](http://inch-ci.org/github/crertel/graphmath)
[![hex.pm version](https://img.shields.io/hexpm/v/graphmath.svg)](https://hex.pm/packages/graphmath)
[![hex.pm downloads](https://img.shields.io/hexpm/dt/graphmath.svg)](https://hex.pm/packages/graphmath)
[![Coverage Status](https://coveralls.io/repos/crertel/graphmath/badge.svg?branch=master)](https://coveralls.io/r/crertel/graphmath?branch=master)

What is graphmath?
===================

Graphmath is a library for handling common 2D and 3D operations, usually with an eye towards vector arithmetic for graphics and simulation.

It's designed to be comfortable to use, reasonably fast, and something which will benefit game developers and graphics programmers, though it may also be useful for robotocists and anyone attempting large-scale simluations which exist in R2 or R3.

Features
========

* Support for vectors in R2 and R3.
* Support for 3x3 and 4x4 matrices.
* Support for quaternions
* Addition, subtraction
* Element-wise multiplication
* Scalar multiplication
* Inner-products (dot product)
* Cross products
* Projection
* Normalization
* Comparison
* Rotation
* Linear interpolation
* Matrix inversion
* Tuples are used to represent vectors and matrices (faster than lists or structs)

Installation
============

This package is available from the [hex](https://hex.pm) package manager.

Just add it to your `mix.exs` file like so:

```
  def project do
    [app: myapp,
     version: "x.y.z",
     elixir: "~> 1.0",
     description: "description",
     package: ...,
     deps: [
        ...,
        {:graphmath, "~> 1.0.2" },
        ...
        ] ]
  end
```

Conventions in library
======================

All mathematics are done in a right-handed coordinate system--that is to say, +Z is the cross-product of +X with +Y.

All operations are accompanied by tests and documentation.

Contributing
============

### Issues

1. Open an issue on Github.

### For developers

1. Fork this project on Github.

2. Open an issue for your proposed changes.

3. Add tests for your new functionality, if applicable.

4. Add documentation for your functionality, if applicable. *NO DOCS -> NO MERGE*.

5. Submit a pull request.

6. Bask in the glory of having helped create content on one of the best platforms ever devised.

### For non-developers

1. Buy me a beer if you see me at ElixirConf.

Wishlist
========

* C/SIMD native extensions (probably want to live in a different, API-compatible library).

* Left-handed coordinate system support (don't care enough right now, but some interop would appreciate it).

* Functions to convert to packed 32-bit and 64-bit float byte arrays.

License
=======

This project is put into the public domain under the unlicense.

If you can't use that, consider it under the WTFPL.

If you can't use *that*, fine--use the new BSD license.

Contributors
=============
* Chris Ertel
* Ivan Miranda
* Matthew Philyaw
