#!/usr/bin/env bash
set -ex

scripts_path=$(dirname "$(readlink -f "$0")")
source "${scripts_path}/common.sh"

mkdir -p /golang/bootstrap
if [ ! -f "golang-bootstrap.tar.gz" ]; then
  wget -q "https://dl.google.com/go/go${GOLANG_BOOTSTRAP_VERSION}.tar.gz" -O golang-bootstrap.tar.gz
fi
echo "$GOLANG_BOOTSTRAP_SHA256  golang-bootstrap.tar.gz" | sha256sum -c -
tar -C /golang/bootstrap -xzf golang-bootstrap.tar.gz
rm golang-bootstrap.tar.gz
cd /golang/bootstrap/go/src
run ./make.bash
export GOROOT_BOOTSTRAP=/golang/bootstrap/go

cd /golang
if [ ! -f "golang.tar.gz" ]; then
  wget -q "https://golang.org/dl/go${GOLANG_VERSION}.src.tar.gz" -O golang.tar.gz
fi
echo "$GOLANG_SRC_SHA256  golang.tar.gz" | sha256sum -c -
tar -C /golang -xzf golang.tar.gz
rm golang.tar.gz
cd /golang/go/src
run ./make.bash

CC_FOR_TARGET=${GOLANG_CC} \
  CXX_FOR_TARGET=${GOLANG_CXX} \
  GOOS=${GOLANG_OS} \
  GOARCH=${GOLANG_ARCH} \
  GOARM=${GOLANG_ARM} \
  CGO_ENABLED=1 \
  ./make.bash --no-clean
rm -rf /golang/bootstrap /golang/go/pkg/bootstrap
