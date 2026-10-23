%{
#include <libtorrent/session.hpp>
%}

%extend libtorrent::session {
  libtorrent::session_handle* get_handle() {
    return self;
  }
}

%include <libtorrent/session.hpp>
