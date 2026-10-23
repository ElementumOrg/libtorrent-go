%{
#include <libtorrent/alert_types.hpp>
%}

%ignore libtorrent::save_resume_data_alert::resume_data;

%extend libtorrent::save_resume_data_alert {
    entry ResumeData() const {
        boost::shared_ptr<libtorrent::entry> ptr;
        ptr = boost::make_shared<libtorrent::entry>(*self->resume_data);
        return *ptr;
    }
}

%include <libtorrent/alert_types.hpp>
