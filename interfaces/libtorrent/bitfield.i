%{
#include <libtorrent/bitfield.hpp>
%}

%extend libtorrent::bitfield {
    void const* bytes() const {
        return (void*)self->data();
    }
}

%ignore libtorrent::bitfield::bytes;

%include <libtorrent/bitfield.hpp>
