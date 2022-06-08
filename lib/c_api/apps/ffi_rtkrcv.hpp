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
EXPORT int rtkrcv_rtksvrstart(rtksvr_t *svr, int cycle, int buffsize, int *strs,
                       char **paths, int *formats, int navsel, char **cmds,
                       char **cmds_periodic, char **rcvopts, int nmeacycle,
                       int nmeareq, const double *nmeapos, prcopt_t *prcopt,
                       solopt_t *solopt, stream_t *moni, char *errmsg);
EXPORT int run_rtkrcv_cmd(int argc, char **argv);
EXPORT void rtksvr_lock  (rtksvr_t *svr);
EXPORT void rtksvr_unlock(rtksvr_t *svr);

EXPORT void rtkrcv_start_rtksvrthread(rtksvr_t *svr);
EXPORT int rtkrcv_decoderaw(rtksvr_t *svr, int index);
EXPORT void rtkrcv_decodefile(rtksvr_t *svr, int index);
EXPORT void rtkrcv_corr_phase_bias(obsd_t *obs, int n, const nav_t *nav);
EXPORT void rtkrcv_periodic_cmd(int cycle, const char *cmd, stream_t *stream);
EXPORT void rtkrcv_writesolhead(stream_t *stream, const solopt_t *solopt);
EXPORT void rtkrcv_writesol(rtksvr_t *svr, int index);
EXPORT void rtkrcv_send_nmea(rtksvr_t *svr, uint32_t *tickreset);
EXPORT void rtkrcv_saveoutbuf(rtksvr_t *svr, uint8_t *buff, int n, int index);
EXPORT void rtkrcv_readant(prcopt_t *opt, nav_t *nav, filopt_t *filopt );

#ifdef __cplusplus
}
#endif

#endif /* FFI_RTKRCV_H */
