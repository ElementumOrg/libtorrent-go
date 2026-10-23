%{
#include <libtorrent/sha1_hash.hpp>
%}

%ignore libtorrent::sha1_hash::begin;
%ignore libtorrent::sha1_hash::end;

%include <libtorrent/sha1_hash.hpp>
