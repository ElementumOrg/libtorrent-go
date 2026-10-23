%{
#include <libtorrent/announce_entry.hpp>
%}

%include <libtorrent/announce_entry.hpp>

%template(stdVectorAnnounceEntry) std::vector<libtorrent::announce_entry>;
