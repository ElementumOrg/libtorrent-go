package libtorrent

// Add '-fsanitize=address' to CXXFLAGS and LDFLAGS

// #cgo pkg-config: --static libtorrent-rasterbar openssl
// #cgo darwin CXXFLAGS: -fvisibility=hidden
// #cgo darwin LDFLAGS: -lm -lstdc++
// #cgo !android,linux CXXFLAGS: -std=c++11 -I/usr/include/libtorrent -Wno-deprecated-declarations -Wno-psabi
// #cgo !android,linux LDFLAGS: -lm -lstdc++ -ldl -lrt
// #cgo android CXXFLAGS: -Wno-macro-redefined -Wno-delete-non-virtual-dtor
// #cgo android LDFLAGS: -lm -lc++_shared -ldl
// #cgo windows CXXFLAGS: -std=c++11 -DIPV6_TCLASS=39 -DSWIGWIN -D_WIN32_WINNT=0x0600 -D__MINGW32__ -Wno-macro-redefined -Wno-delete-non-virtual-dtor -Wno-builtin-macro-redefined
// #cgo windows LDFLAGS: -static-libgcc -static-libstdc++ -static
import "C"
