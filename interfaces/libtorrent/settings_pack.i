%{
#include <libtorrent/settings_pack.hpp>
%}

%extend libtorrent::settings_pack {
  void set_bool(std::string const& name, bool val) {
    $self->set_bool(libtorrent::setting_by_name(name), val);
  };

  void set_int(std::string const& name, int val) {
    $self->set_int(libtorrent::setting_by_name(name), val);
  };

  void set_str(std::string const& name, std::string const& val) {
    $self->set_str(libtorrent::setting_by_name(name), val);
  };

  bool get_bool(std::string const& name) const { 
    return $self->get_bool(libtorrent::setting_by_name(name));
  }

  int get_int(std::string const& name) const { 
    return $self->get_int(libtorrent::setting_by_name(name));
  }

  std::string get_str(std::string const& name) const { 
    return $self->get_str(libtorrent::setting_by_name(name));
  }
}

%include <libtorrent/settings_pack.hpp>
