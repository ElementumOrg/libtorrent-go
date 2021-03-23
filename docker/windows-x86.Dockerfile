FROM elementumorg/cross-compiler:windows-x86

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
ENV BOOST_CC gcc
ENV BOOST_CXX c++
ENV BOOST_OS mingw32
ENV BOOST_TARGET_OS windows
ENV BOOST_OPTS address-model=32 architecture=x86 threadapi=win32
RUN ./build-boost.sh

# Install OpenSSL
COPY scripts/build-openssl.sh /build/
ENV OPENSSL_OPTS mingw
RUN ./build-openssl.sh

# Install SWIG
COPY scripts/build-swig.sh /build/
RUN ./build-swig.sh

# Install Golang
COPY scripts/build-golang.sh /build/
ENV GOROOT_BOOTSTRAP /usr/go
ENV GOLANG_CC ${CROSS_TRIPLE}-cc
ENV GOLANG_CXX ${CROSS_TRIPLE}-c++
ENV GOLANG_OS windows
ENV GOLANG_ARCH 386
RUN ./build-golang.sh
ENV PATH ${PATH}:/usr/local/go/bin

# Install libtorrent
COPY scripts/build-libtorrent.sh /build/
ENV LT_CC ${CROSS_TRIPLE}-cc
ENV LT_CXX ${CROSS_TRIPLE}-c++
ENV LT_FLAGS -lmswsock -DUNICODE -D_UNICODE -DWIN32 -DWIN32_LEAN_AND_MEAN -DIPV6_TCLASS=39 -D_WIN32_WINNT=0x0501
ENV LT_CXXFLAGS -std=c++11
ENV LT_LIBS -lmswsock
RUN ./build-libtorrent.sh
