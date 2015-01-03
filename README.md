What is graphmath?
===================

Graphmath is a library for handling common 2D and 3D operations, usually with an eye towards vector arithmetic for graphics and simulation.

It's designed to be comfortable to use, reasonably fast, and something which will benefit game developers and graphics programmers, though it may also be useful for robotocists and anyone attempting large-scale simluations which exist in R2 or R3.

Features
========

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
* Support for list representations of vectors
* Support for tuple representations of vectors

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
        {:grapmath, "~> 0.1.0" },
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

###Issues###

1. Open an issue on Github.

###For developers###

1. Fork this project on Github.

2. Open an issue for your proposed changes.

3. Add tests for your new functionality, if applicable.

4. Add documentation for your functionality, if applicable. *NO DOCS -> NO MERGE*.

5. Submit a pull request.

6. Bask in the glory of having helped create content on one of the best platforms ever devised.

###For non-developers###

1. Buy me a beer if you see me at ElixirConf.

Wishlist
========

* Proper support for 4x4 rigid-body transofrms and mass-point math.

* C/SIMD native extensions (probably want to live in a different, API-compatible library).

* Left-handed coordinate system support (don't care enough right now, but some interop would appreciate it).

* Functions to convert to packed 32-bit and 64-bit float byte arrays.

License
=======

This project is put into the public domain under the unlicense.

If you can't use that, consider it under the WTFPL.

If you can't use *that*, fine--use the new BSD license.

