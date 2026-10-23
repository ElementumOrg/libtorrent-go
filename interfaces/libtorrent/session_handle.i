%{
#include <libtorrent/session_handle.hpp>
%}

%ignore libtorrent::session_handle::add_extension;
%ignore libtorrent::session_handle::dht_put_item;
%ignore libtorrent::session_handle::pop_alerts;

%extend libtorrent::session_handle {
  std::vector<libtorrent::alert*> PopAlerts() {
    std::vector<libtorrent::alert*> alerts;
    self->pop_alerts(&alerts);
    return alerts;
  }
}

%include <libtorrent/session_handle.hpp>
