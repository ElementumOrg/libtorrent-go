#!/usr/bin/env bash
set -ex

scripts_path=$(dirname "$(readlink -f "$0")")
source "${scripts_path}/common.sh"

if [ ! -f "swig-${SWIG_VERSION}.tar.gz" ]; then
  wget -q https://github.com/swig/swig/archive/${SWIG_VERSION}.tar.gz -O swig-${SWIG_VERSION}.tar.gz
fi
echo "$SWIG_SHA256  swig-${SWIG_VERSION}.tar.gz" | sha256sum -c -
tar -xzf swig-${SWIG_VERSION}.tar.gz
rm swig-${SWIG_VERSION}.tar.gz
cd swig-${SWIG_VERSION}/
run ./autogen.sh
run ./configure --prefix="${CROSS_ROOT}"
run make -j $(cat /proc/cpuinfo | grep processor | wc -l)
run make install
rm -rf `pwd`
