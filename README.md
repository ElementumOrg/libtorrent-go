libtorrent-go [![Build Status](https://github.com/elementumorg/libtorrent-go/workflows/build/badge.svg)](https://github.com/elementumorg/libtorrent-go/actions?query=workflow%3Abuild)
=============

SWIG Go bindings for libtorrent-rasterbar

Forked from <https://github.com/steeve/libtorrent-go> and <https://github.com/scakemyer/libtorrent-go>


C/C++ Cross compiling environment containers

This has been designed to run `libtorrent-go` cross compilation and is not meant to be perfect nor minimal. Adapt as required.

## Overview

### Environment variables

- CROSS_TRIPLE
- CROSS_ROOT
- LD_LIBRARY_PATH
- PKG_CONFIG_PATH

### Installed packages

Based on Debian Bullseye (see [cross-compiler](https://github.com/ElementumOrg/cross-compiler)):
- bash
- curl
- wget
- pkg-config
- build-essential
- make
- automake
- autogen
- libtool
- libpcre3-dev
- bison
- yodl
- tar
- xz-utils
- bzip2
- gzip
- unzip
- file
- rsync
- sed
- upx

And a selection of platform specific packages (see below).

### Platforms built

Each platform image is built on top of the matching [cross-compiler](https://github.com/ElementumOrg/cross-compiler) image:

- android-arm, android-arm64, android-x64, android-x86 (Android NDK r20b, clang, API 21 / Android 5.0+)
- darwin-x64, darwin-arm64 (osxcross, macOS SDK 13.3, clang-16, minimum macOS 13.0)
- linux-armv6 (Raspberry Pi Linaro gcc toolchain, glibc 2.10+)
- linux-armv7, linux-armv7_softfp, linux-arm64, linux-x64, linux-x86 (gcc 10, glibc 2.28+)
- windows-x64, windows-x86 (mingw-w64, gcc 10; Go requires Windows 10+)

### Software

See the `Makefile` for exact versions and checksums:

+ BOOST_VERSION = 1.72.0
+ OPENSSL_VERSION = 1.1.1w
+ SWIG_VERSION = 4.6.0
+ GOLANG_VERSION = 1.27.3
+ LIBTORRENT_VERSION = RC_1_1 (760f94862ef6b76a13bba0a68d55ca6507aef7c2)


# Download and Build

+ First, you need [Docker](https://docs.docker.com/engine/installation/) and [golang](https://golang.org/doc/install)

+ Create Go home folder and set $GOPATH environment variable:

        mkdir ~/go
        export GOPATH=~/go

+ Download libtorrent-go:

        go get github.com/ElementumOrg/libtorrent-go
        cd ~/go/src/github.com/ElementumOrg/libtorrent-go

+ Pull the cross-compiler image for your platform:

        make pull PLATFORM=android-arm

+ Next, you need to prepare Docker environments. You can do it with two ways:

        make envs

    This will download and build all needed development packages and could take hours (images are built 4 in parallel; use `make JOBS=1 envs` to build one at a time with full live output). But it can be necessary if you want to make your own customizations.

    You can also prepare specific environments like so:

        make env PLATFORM=android-arm

+ (Optionally) Build locally without Docker (for local development, for example)

    Is helpful if you need to have all the required stack locally on your OS.
    You need to specify `CROSS_TRIPLE` - you can find possible values [here](https://github.com/ElementumOrg/cross-compiler/tree/master/docker).
    Everything is installed in `libtorrent-go/local-env/` directory.

        make local-env CROSS_TRIPLE=x86_64-linux-gnu

    Then you can run libtorrent-go module compilation:

        make re TARGET_OS=linux TARGET_ARCH=x64 CROSS_ROOT=local-env

    It will make sure to use `libtorrent-go/local-env/lib/pkgconfig/` to compile module and have all the dependencies.
    But before that you also need to install `swig`.

+ Build libtorrent-go:

        make [ android-arm | android-arm64 | android-x86 | android-x64 |
               linux-x86   | linux-x64     | linux-armv6 | linux-armv7 | linux-armv7_softfp | linux-arm64 |
               windows-x86 | windows-x64   |
               darwin-x64  | darwin-arm64 ]

    To build libtorrent bindings for all platforms use `make` or specify needed platform, e.g. `make android-arm`.
    Built packages will be placed under `~/go/pkg/<platform>`

# Release

Release is done by running `release.sh` script, that compiles all Docker images and pushes them to Docker Hub.

Thanks
------
- [steeve](https://github.com/steeve) for his awesome work.
- [dimitriss](https://github.com/dimitriss) for his great updates.
- [scakemyer](https://github.com/scakemyer) for his huge work.
