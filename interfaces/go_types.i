%define TYPE_CAST(type, go_type)
%typemap(gotype) type "go_type"
%typemap(in) type      %{    $1 = (type) $input;%}
%typemap(out) type     %{    $result = $1;%}
%enddef

// Fix for darwin-x64
#ifdef SWIGMAC
typedef unsigned long long int uint64_t;
typedef long long int int64_t;
#endif

// %apply intptr_t { std::ptrdiff_t };
// Similar to what's done with size_t - https://github.com/swig/swig/blob/master/Lib/go/go.swg#L231
TYPE_CAST(std::ptrdiff_t, int64)
