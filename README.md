# NAME

File::Path - Create or remove directory trees
[![Build status](https://ci.appveyor.com/api/projects/status/gxeq4hl1ldw4t3p5?svg=true)](https://ci.appveyor.com/project/jkeenan/file-path)
[![Build Status](https://travis-ci.org/jkeenan/File-Path.svg?branch=master)](https://travis-ci.org/jkeenan/File-Path)
[![CPAN version](https://badge.fury.io/pl/File-Path.svg)](http://badge.fury.io/pl/File-Path)


# INSTALLATION

    perl Makefile.PL
    make
    make test
    make install

# PREREQUISITES

All prerequisites are found in the Perl 5 core distribution.

## To configure:

    ExtUtils::MakeMaker

## To build:

    Cwd                         File::Basename
    Exporter                    File::Spec

### To test:

    Carp                        File::Spec::Functions
    Config                      SelectSaver
    Cwd                         Test::More
    Errno                       Win32       # Windows only
    Fcntl

# BUGS

The File-Path bug tracker is located at:
[https://github.com/jkeenan/File-Path](https://github.com/jkeenan/File-Path)

# AUTHORS

Prior authors and maintainers: Tim Bunce, Charles Bailey, and
David Landgren (`david at landgren dot net`).

Current maintainer is James E Keenan (`jkeenan at pobox dot com`).

# COPYRIGHT

This module is copyright (C) Charles Bailey, Tim Bunce, David Landgren,
James Keenan, and Richard Elberger 1995-2026. All rights reserved.

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
