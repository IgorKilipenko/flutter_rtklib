#ifndef FFI_RTKRCV_H
#define FFI_RTKRCV_H

#include "rtklib_api.hpp"

#ifdef __cplusplus
extern "C" {
#endif

EXPORT opt_t* rtkrcv_getRcvOptions(int *count);
EXPORT void rtkrcv_printCmdHelpInfo(void);

EXPORT int rtkrcv_readcmd(const char *file, char *cmd, int type);
EXPORT int rtkrcv_startsvr(void);
EXPORT int run_rtkrcv_cmd(int argc, char **argv);

#ifdef __cplusplus
}
#endif

#endif /* FFI_RTKRCV_H */
