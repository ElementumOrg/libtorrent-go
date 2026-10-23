%{
#include <memory_storage.hpp>
%}

%apply char *INOUT {char *read_buf};

%include <memory_storage.hpp>
