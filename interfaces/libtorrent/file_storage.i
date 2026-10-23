%{
#include <libtorrent/file_storage.hpp>
%}

// SWiG voodoo for Windows and the dreaded "'iovec' has not been declared"...
namespace libtorrent {
  namespace file {}
}

%include <libtorrent/file_storage.hpp>
