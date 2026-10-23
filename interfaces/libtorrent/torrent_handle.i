%{
#include <libtorrent/torrent_handle.hpp>
%}

// Equaler interface
%rename(Equal) libtorrent::torrent_handle::operator==;
%rename(NotEqual) libtorrent::torrent_handle::operator!=;
%rename(Less) libtorrent::torrent_handle::operator<;

// Must precede torrent_handle.hpp: partial_piece_info::blocks() below uses block_info_list_frompointer
%array_class(libtorrent::block_info, block_info_list);

%extend libtorrent::torrent_handle {
    const libtorrent::torrent_info* torrent_file() {
        return self->torrent_file().get();
    }

    libtorrent::memory_storage* get_memory_storage() {
        return ((libtorrent::memory_storage*) self->get_storage_impl());
    }
}

%ignore libtorrent::torrent_handle::torrent_file;
%ignore libtorrent::torrent_handle::use_interface;

%extend libtorrent::partial_piece_info {
    block_info_list* blocks() {
        return block_info_list_frompointer(self->blocks);
    }
}

%ignore libtorrent::partial_piece_info::blocks;
%ignore libtorrent::hash_value;
%ignore libtorrent::block_info::peer; // linux_arm
%ignore libtorrent::block_info::set_peer; // linux_arm

%include <libtorrent/torrent_handle.hpp>

%template(stdVectorPartialPieceInfo) std::vector<libtorrent::partial_piece_info>;
%template(stdVectorTorrentHandle) std::vector<libtorrent::torrent_handle>;
