%{
#include <libtorrent/alert.hpp>
%}

%ignore libtorrent::log_alert;
%ignore libtorrent::peer_log_alert;
%ignore libtorrent::portmap_log_alert;
%ignore libtorrent::torrent_log_alert;
%ignore libtorrent::stats_alert;
%ignore libtorrent::picker_log_alert;

%{
    using libtorrent::time_point;
%}

%include <libtorrent/alert.hpp>

%template(stdVectorAlerts) std::vector<libtorrent::alert*>;
