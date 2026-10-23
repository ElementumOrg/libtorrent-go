%{
#include <libtorrent/add_torrent_params.hpp>
%}

%ignore libtorrent::add_torrent_params::ti;

%extend libtorrent::add_torrent_params {
	const libtorrent::torrent_info* get_torrent_info() {
		return self->ti.get();
	}

	void set_torrent_info(libtorrent::torrent_info torrent_info) {
		boost::shared_ptr<libtorrent::torrent_info> ptr;
		ptr = boost::make_shared<libtorrent::torrent_info>(torrent_info);
		self->ti = ptr;
	}

	void set_memory_storage(boost::int64_t size) {
		libtorrent::memory_size = size;
		self->storage = libtorrent::memory_storage_constructor;
	}
}

%include <libtorrent/add_torrent_params.hpp>
