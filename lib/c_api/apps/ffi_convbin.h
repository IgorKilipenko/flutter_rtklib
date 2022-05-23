#ifndef FFI_CONVBIN_H
#define FFI_CONVBIN_H

#include "rtklib_api.h"

#ifdef __cplusplus
extern "C" {
#endif

EXPORT rnxopt_t* convbin_parse_options_cmd(int arg_count, char **arg_vars);
EXPORT int convbin_convert_cmd(int arg_count, char **arg_vars, rnxopt_t *options, int trace);

#ifdef __cplusplus
}
#endif

#endif /* FFI_CONVBIN_H */
