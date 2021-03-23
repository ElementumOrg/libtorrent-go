FROM elementumorg/cross-compiler:android-arm64

RUN mkdir -p /build
WORKDIR /build

ARG BOOST_VERSION
ARG BOOST_VERSION_FILE
ARG BOOST_SHA256
ARG OPENSSL_VERSION
ARG OPENSSL_SHA256
ARG SWIG_VERSION
ARG SWIG_SHA256
ARG GOLANG_VERSION
ARG GOLANG_SRC_URL
ARG GOLANG_SRC_SHA256
ARG GOLANG_BOOTSTRAP_VERSION
ARG GOLANG_BOOTSTRAP_URL
ARG GOLANG_BOOTSTRAP_SHA256
ARG LIBTORRENT_VERSION

COPY scripts/common.sh /build/

# Install Boost.System
COPY scripts/build-boost.sh /build/
ENV BOOST_CC clang
ENV BOOST_CXX clang++
ENV BOOST_OS android
ENV BOOST_TARGET_OS linux
ENV BOOST_OPTS cxxflags=-fPIC cflags=-fPIC
RUN ./build-boost.sh

# Install OpenSSL
COPY scripts/build-openssl.sh /build/
ENV OPENSSL_OPTS linux-aarch64 -fPIC
RUN ./build-openssl.sh

# Install SWIG
COPY scripts/build-swig.sh /build/
RUN ./build-swig.sh

# Install Golang
COPY scripts/build-golang.sh /build/
ENV GOROOT_BOOTSTRAP /usr/go
ENV GOLANG_CC ${CROSS_TRIPLE}-clang
ENV GOLANG_CXX ${CROSS_TRIPLE}-clang++
ENV GOLANG_OS android
ENV GOLANG_ARCH arm64
ENV GOLANG_ARM 7
RUN ./build-golang.sh
ENV PATH ${PATH}:/usr/local/go/bin

# Install libtorrent
COPY scripts/build-libtorrent.sh /build/
ENV LT_CC ${CROSS_TRIPLE}-clang
ENV LT_CXX ${CROSS_TRIPLE}-clang++
ENV LT_PTHREADS TRUE
ENV LT_FLAGS -fPIC -fPIE
ENV LT_CXXFLAGS -Wno-macro-redefined -Wno-c++11-extensions
RUN ./build-libtorrent.sh
