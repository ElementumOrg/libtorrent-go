FROM elementumorg/cross-compiler:android-arm as golang
    WORKDIR /golang

    ARG GOLANG_VERSION
    ARG GOLANG_SRC_URL
    ARG GOLANG_SRC_SHA256
    ARG GOLANG_BOOTSTRAP_VERSION
    ARG GOLANG_BOOTSTRAP_URL
    ARG GOLANG_BOOTSTRAP_SHA256

    # Install Golang
    COPY scripts/common.sh .
    COPY scripts/build-golang.sh .
    ENV GOROOT_BOOTSTRAP /usr/go
    ENV GOLANG_CC ${CROSS_TRIPLE}-clang
    ENV GOLANG_CXX ${CROSS_TRIPLE}-clang++
    ENV GOLANG_OS android
    ENV GOLANG_ARCH arm
    ENV GOLANG_ARM 7
    RUN ./build-golang.sh

FROM elementumorg/cross-compiler:android-arm as swig
    WORKDIR /libs/swig

    ARG SWIG_VERSION
    ARG SWIG_SHA256

    # Install SWIG
    COPY scripts/common.sh .
    COPY scripts/build-swig.sh .
    RUN ./build-swig.sh

FROM elementumorg/cross-compiler:android-arm as boost
    WORKDIR /libs/boost

    ARG BOOST_VERSION
    ARG BOOST_VERSION_FILE
    ARG BOOST_SHA256

    # Install Boost.System
    COPY scripts/common.sh .
    COPY scripts/build-boost.sh .
    ENV BOOST_CC clang
    ENV BOOST_CXX clang++
    ENV BOOST_OS android
    ENV BOOST_TARGET_OS linux
    ENV BOOST_OPTS cxxflags=-fPIC cflags=-fPIC
    RUN ./build-boost.sh

FROM elementumorg/cross-compiler:android-arm as openssl
    WORKDIR /libs/openssl

    ARG OPENSSL_VERSION
    ARG OPENSSL_SHA256

    # Install OpenSSL
    COPY scripts/common.sh .
    COPY scripts/build-openssl.sh .
    ENV OPENSSL_OPTS linux-armv4
    RUN ./build-openssl.sh

FROM elementumorg/cross-compiler:android-arm as libtorrent
    WORKDIR /libs/libtorrent

    COPY --from=boost ${CROSS_ROOT}/include/boost ${CROSS_ROOT}/include/boost
    COPY --from=boost ${CROSS_ROOT}/lib/libboost*.a ${CROSS_ROOT}/lib/
    COPY --from=openssl /libs/openssl/installed ${CROSS_ROOT}

    ARG LIBTORRENT_VERSION

    # Install libtorrent
    COPY scripts/common.sh .
    COPY scripts/build-libtorrent.sh .
    ENV LT_CC ${CROSS_TRIPLE}-clang
    ENV LT_CXX ${CROSS_TRIPLE}-clang++
    ENV LT_PTHREADS TRUE
    ENV LT_FLAGS -fPIC -DINT64_MAX=0x7fffffffffffffffLL -DINT16_MAX=32767 -DINT16_MIN=-32768 -DTORRENT_PRODUCTION_ASSERTS
    ENV LT_CXXFLAGS -Wno-macro-redefined -Wno-c++11-extensions
    RUN ./build-libtorrent.sh


FROM elementumorg/cross-compiler:android-arm
    # Install Golang
    COPY --from=golang /golang/go /usr/local/go
    ENV PATH ${PATH}:/usr/local/go/bin

    # Install Boost.System
    COPY --from=boost ${CROSS_ROOT}/include/boost ${CROSS_ROOT}/include/boost
    COPY --from=boost ${CROSS_ROOT}/lib/libboost*.a ${CROSS_ROOT}/lib/

    # Install OpenSSL
    COPY --from=openssl /libs/openssl/installed ${CROSS_ROOT}

    # Install SWIG
    COPY --from=swig /libs/swig/installed /libs/swig/installed
    ENV PATH ${PATH}:/libs/swig/installed/bin

    # Install libtorrent
    COPY --from=libtorrent ${CROSS_ROOT}/include/libtorrent ${CROSS_ROOT}/include/libtorrent
    COPY --from=libtorrent ${CROSS_ROOT}/lib/libtorrent*.a ${CROSS_ROOT}/lib/
    COPY --from=libtorrent ${CROSS_ROOT}/lib/pkgconfig/libtorrent*.pc ${CROSS_ROOT}/lib/pkgconfig/
    