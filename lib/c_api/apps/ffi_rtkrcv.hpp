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
EXPORT void rtkrcv_stopsvr(void);
EXPORT void rtkrcv_readant(prcopt_t *opt, nav_t *nav, filopt_t *filopt );

EXPORT void rtksvr_lock  (rtksvr_t *svr);
EXPORT void rtksvr_unlock(rtksvr_t *svr);

EXPORT int rtksvr_rtksvrstart(rtksvr_t *svr, int cycle, int buffsize, int *strs,
                       char **paths, int *formats, int navsel, char **cmds,
                       char **cmds_periodic, char **rcvopts, int nmeacycle,
                       int nmeareq, const double *nmeapos, prcopt_t *prcopt,
                       solopt_t *solopt, stream_t *moni, char *errmsg);
EXPORT void rtksvr_start_rtksvrthread(rtksvr_t *svr);
EXPORT int rtksvr_decoderaw(rtksvr_t *svr, int index);
EXPORT void rtksvr_decodefile(rtksvr_t *svr, int index);
EXPORT void rtksvr_corr_phase_bias(obsd_t *obs, int n, const nav_t *nav);
EXPORT void rtksvr_periodic_cmd(int cycle, const char *cmd, stream_t *stream);
EXPORT void rtksvr_writesolhead(stream_t *stream, const solopt_t *solopt);
EXPORT void rtksvr_writesol(rtksvr_t *svr, int index);
EXPORT void rtksvr_send_nmea(rtksvr_t *svr, uint32_t *tickreset);
EXPORT void rtksvr_saveoutbuf(rtksvr_t *svr, uint8_t *buff, int n, int index);

EXPORT bool rtkrcv_registerSendPort(Dart_Port send_port);

#ifdef __cplusplus
}
#endif

#endif /* FFI_RTKRCV_H */
