#ifndef RTKLIB_API_H
#define RTKLIB_API_H

#ifndef FFI_GEN
#include <iostream>
#endif

#include "rtklib.h"

#include "dart_api.h"

// #define FATAL(format, ...) trace(1, format, __VA_ARGS__)

#ifdef __cplusplus
extern "C" {
#endif

typedef struct {
    size_t gtime_t;
    size_t obsd_t;
    size_t obs_t;
    size_t erpd_t;
    size_t erp_t;
    size_t pcv_t;
    size_t pcvs_t;
    size_t alm_t;
    size_t eph_t;
    size_t geph_t;
    size_t peph_t;
    size_t pclk_t;
    size_t seph_t;
    size_t tled_t;
    size_t tle_t;
    size_t tec_t;
    size_t sbsmsg_t;
    size_t sbs_t;
    size_t sbsfcorr_t;
    size_t sbslcorr_t;
    size_t sbssatp_t;
    size_t sbssat_t;
    size_t sbsigp_t;
    size_t sbsigpband_t;
    size_t sbsion_t;
    size_t dgps_t;
    size_t ssr_t;
    size_t nav_t;
    size_t sta_t;
    size_t sol_t;
    size_t solbuf_t;
    size_t solstat_t;
    size_t solstatbuf_t;
    size_t rtcm_t;
    size_t rnxctr_t;
    size_t url_t;
    size_t opt_t;
    size_t snrmask_t;
    size_t prcopt_t;
    size_t solopt_t;
    size_t filopt_t;
    size_t rnxopt_t;
    size_t ssat_t;
    size_t ambc_t;
    size_t rtk_t;
    size_t raw_t;
    size_t stream_t;
    size_t strconv_t;
    size_t strsvr_t;
    size_t rtksvr_t;
    size_t gis_pnt_t;
    size_t gis_poly_t;
    size_t gis_polygon_t;
    size_t gisd_t;
    size_t gis_t;
} struct_sizes_t;

struct FlutterTraceMessgae {
    const char * const message;
    const int level;
    const size_t message_lenght;

#ifndef FFI_GEN
    ~FlutterTraceMessgae() {
        std::cout << "FlutterTraceMessgae destruct" << std::endl;
    }
#endif
};

EXPORT intptr_t InitDartApiDL(void* data);
EXPORT void RegisterPrintCallbackBlocking(Dart_Port send_port,
                                            intptr_t (*callback)(const char* message, size_t message_len, int level));
EXPORT void RegisterPrintCallbackNonBlocking(Dart_Port send_port,
                                               void (*callback)(const char* message, size_t message_len, int level));

EXPORT void Fatal(char const* file, int line, char const* error);

#define FATAL(error) Fatal(__FILE__, __LINE__, error)

/** 
 * @brief Convert obs to string
 * @param[in] obs - [obsd_t *] observation
 * @param[out] strLen - [size_t *] output string length
 * @return [char*] result string
 */
EXPORT char* obs2str(const obsd_t *obs, size_t * strLen);

EXPORT size_t obs2str2(const obsd_t *obs, char ** outStr);


/** 
 * @brief Create new raw controller
 * @param[in] format - [int] format raw data
 * @param[in, out] status - [uint32_t *] status code (0: memory allocation error, 1: success)
 * @return [raw_t *] pointer to raw_t instance
 */
EXPORT raw_t * create_raw(int format, uint32_t* status);

EXPORT int init_raw_2 (raw_t **raw, int format);

extern void (*flutter_print)(char *, size_t, int);

EXPORT int flutter_printf(const char *format, ...);
EXPORT int flutter_vprintf(const char *format, va_list args);
EXPORT int flutter_trace(int level, const char *format, ...);
EXPORT int flutter_vtrace(int level, const char *format, va_list args);
EXPORT bool flutter_initialize(Dart_Port send_port);
EXPORT void vtracet(int level, const char *format, va_list args);
EXPORT void set_level_trace(int level);

EXPORT Dart_Handle GetFlutterRootLibraryUrl(void);

/** 
 * @brief print matrix 
 * print matrix to stdout 
 * args   : double *A        I   matrix A (n x m) 
 *          int    n,m       I   number of rows and columns of A 
 *          int    p,q       I   total columns, columns under decimal point 
 *         (char **buffer    O   output string) 
 * @return [int] string length 
 * notes  : matirix stored by column-major order (fortran convention) 
 */
EXPORT int matsprint(const double A[], int n, int m, int p, int q, char **buffer);

EXPORT struct_sizes_t* getStructSizes(void);

EXPORT FILE* openReadFile(const char *filename);
EXPORT FILE* openWriteFile(const char *filename);
EXPORT FILE* openFile(const char *filename, const char * mode);

EXPORT void native_free(void *ptr);
EXPORT void native_deleteArray(void* ptrArr);
EXPORT void native_delete(void* ptr);
EXPORT void native_delete_FlutterTraceMessgae(FlutterTraceMessgae* ptr);

#ifdef __cplusplus
}
#endif

#endif /* RTKLIB_API_H */
