%{
#include <libtorrent/bencode.hpp>
%}

namespace libtorrent {
    std::string bencode(const entry& e);
}

%{
namespace libtorrent {
    std::string bencode(const entry& e) {
        std::ostringstream oss;
        bencode(std::ostream_iterator<char>(oss), e);
        return oss.str();
    }
}
%}

%include <libtorrent/bencode.hpp>
