#!/usr/bin/env bash
set -ex

scripts_path=$(dirname "$(readlink -f "$0")")
source "${scripts_path}/common.sh"

if [ -v LT_PTHREADS ]; then
  echo "#define BOOST_SP_USE_PTHREADS" >> ${CROSS_ROOT}/include/boost/config/user.hpp
fi
if [ ! -f "${LIBTORRENT_VERSION}.tar.gz" ]; then
  wget -q https://github.com/arvidn/libtorrent/archive/`echo ${LIBTORRENT_VERSION} | sed 's/\\./_/g'`.tar.gz
fi
tar -xzf ${LIBTORRENT_VERSION}.tar.gz
rm ${LIBTORRENT_VERSION}.tar.gz
cd libtorrent-`echo ${LIBTORRENT_VERSION} | sed 's/\\./_/g'`/
./autotool.sh
sed -i 's/$PKG_CONFIG openssl --libs-only-/$PKG_CONFIG openssl --static --libs-only-/' ./configure
if [ -v LT_OSXCROSS ]; then
  export OSXCROSS_PKG_CONFIG_PATH=${CROSS_ROOT}/lib/pkgconfig/
fi
CC=${LT_CC} CXX=${LT_CXX} \
CFLAGS="${CFLAGS} -O2 ${LT_FLAGS}" \
CXXFLAGS="${CXXFLAGS} ${LT_CXXFLAGS} ${CFLAGS}" \
LIBS=${LT_LIBS} \
run ./configure \
    --enable-static \
    --disable-shared \
    --disable-deprecated-functions \
    --host=${CROSS_TRIPLE} \
    --prefix=${CROSS_ROOT} \
    --with-openssl=${CROSS_ROOT} \
    --with-boost=${CROSS_ROOT} --with-boost-libdir=${CROSS_ROOT}/lib ${LT_OPTS}
run make -j $(cat /proc/cpuinfo | grep processor | wc -l) && make install
rm -rf `pwd`
