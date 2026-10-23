%{
#include <libtorrent/extensions/smart_ban.hpp>
#include <libtorrent/extensions/ut_metadata.hpp>
#include <libtorrent/extensions/ut_pex.hpp>
#include <upload_plugin.hpp>
%}

%extend libtorrent::session {
    void add_extensions() {
        self->add_extension(&libtorrent::create_smart_ban_plugin);
        self->add_extension(&libtorrent::create_ut_metadata_plugin);
        self->add_extension(&libtorrent::create_ut_pex_plugin);
    }

    void add_upload_extension() {
        self->add_extension(&libtorrent::create_upload_plugin);
    }
}
