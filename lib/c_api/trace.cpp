#include "rtklib_api.hpp"
#include <string>
#include <memory>
#include <vector>
#include <algorithm>
#include <functional>
#include <iostream>

#include <stddef.h>
#include <stdlib.h>
#include <sys/types.h>
#include <csignal>

#include "dart_api.h"
#include "dart_native_api.h"
#include "dart_api_dl.h"

#if defined(WIN32)
#include <psapi.h>
#include <windows.h>
#else
#include <unistd.h>
#endif

typedef std::function<void()> PrintfWork;

const std::string COUT_TAG = "rtklib cout : ";

static void FreeFinalizer(void*, void* value) {
  delete(value);
}

static intptr_t (*print_callback_blocking_fp_)(const char* message, size_t message_len, int level) = [](const char* message, size_t message_len, int level) -> intptr_t {return 0;};
static Dart_Port send_port_blocking_ = -1;
static void (*print_callback_non_blocking_fp_)(const char* message, size_t message_len, int level) = [](const char* message, size_t message_len, int level){};
static Dart_Port send_port_non_blocking_ = -1;
static Dart_Port print_send_port = -1;

bool FlutterTraceIsInitialized(void) {
    return print_send_port > 0 &&  flutter_print != NULL;
}

// Notify Dart through a port that the C lib has pending async callbacks.
//
// Expects heap allocated `PrintfWork` so delete can be called on it.
//
// The `send_port` should be from the isolate which registered the callback.
static bool NotifyDart(Dart_Port send_port, char *message, size_t length, int level) {
    if (send_port <= 0) return false;
   
    char * const buffer = (char *)calloc(length+1, sizeof(char));
    strncpy(buffer, message, length);

    struct FlutterTraceMessgae * const dartMessagePtr = (FlutterTraceMessgae*)malloc(sizeof(struct FlutterTraceMessgae));
    struct FlutterTraceMessgae dartMessage =  {
        .message = buffer,
        .level = level,
        .message_lenght = length
    };
    *dartMessagePtr = dartMessage;

    Dart_CObject dart_object;
    dart_object.type = Dart_CObject_kNativePointer;
    auto ptr = reinterpret_cast<intptr_t>(&*dartMessagePtr);
    dart_object.value.as_native_pointer.ptr = ptr;
    dart_object.value.as_native_pointer.size = sizeof(struct FlutterTraceMessgae);
    dart_object.value.as_native_pointer.callback = [](void*, void* value) {

        /*
        * Not worked, see : 
        *   - https://github.com/dart-lang/sdk/issues/47901
        *   - https://github.com/fzyzcjy/flutter_rust_bridge/issues/243
        */
        std::cout << COUT_TAG << "NotifyDart : " << "[ ### ] FreeFinalizer";

        auto obj = reinterpret_cast<FlutterTraceMessgae*>(value);
        free((char*)(obj->message));
        free(obj);
    };

    const bool result = Dart_PostCObject_DL(send_port, &dart_object);
    if (!result) {
        FATAL("Posting message to port failed.");
    }
    return result;
}

extern void RegisterPrintCallbackBlocking(Dart_Port send_port,
                                            intptr_t (*callback)(const char* message, size_t message_len, int level)) {
    print_callback_blocking_fp_ = callback;
    send_port_blocking_ = send_port;
}

extern void RegisterPrintCallbackNonBlocking(Dart_Port send_port,
                                               void (*callback)(const char* message, size_t message_len, int level)) {
    print_callback_non_blocking_fp_ = callback;
    send_port_non_blocking_ = send_port;
}

// OVERRIDE TRACE FOR FLUTTER DEBUG
#if !defined(TRACE) && defined(EXTERNAL_TRACE)

static int level_trace=0;       
/// tick time at traceopen (ms)
static uint32_t tick_trace=0;   
/// time at traceopen
static gtime_t time_trace={0};  

extern void traceopen(const char *file)
{
    gtime_t time=utc2gpst(timeget());
    tick_trace=tickget();
    time_trace=time;
}

extern void traceclose(void)
{
}

extern void tracelevel(int level)
{
    level_trace=level;
}

extern int gettracelevel(void)
{
    return level_trace;
}

extern void trace(int level, const char *format, ...)
{
    va_list ap;

    if (level<=gettracelevel()) {
        va_start(ap,format); 
        flutter_vtrace(level, format, ap);
        va_end(ap);
    }
}

extern void tracemat(int level, const double *A, int n, int m, int p, int q)
{
    if (level>level_trace) return;
    char **buffer = NULL;
    matsprint(A,n,m,p,q,buffer);
    if (buffer) free(buffer);
}

static std::string string_format(const char* format, ...)
{
    va_list args;
    va_start(args, format);

    int buf_len = vsnprintf(nullptr, 0, format, args);
    auto strBuf = std::make_unique<char[]>(buf_len + 1);
    vsnprintf(strBuf.get(), buf_len + 1, format, args);

    return std::string(strBuf.get());
}

template<typename ... Args>
static std::string format(const std::string &fmt, Args ... args)
{
    // C++11 specify that string store elements continously
    std::string ret;

    auto sz = std::snprintf(nullptr, 0, fmt.c_str(), args...);
    ret.reserve(sz + 1); ret.resize(sz);    // to be sure there have room for \0
    std::snprintf(&ret.front(), ret.capacity() + 1, fmt.c_str(), args...);
    return ret;
}

extern int matsprint(const double A[], int n /*rows*/, int m, int p, int q, char **buffer)
{
    *buffer = NULL;
    char *result;
    int maxSize = std::max(p+q+2,4)*m*n+1+n;
    if (!(result = (char *)calloc(maxSize+1, sizeof(char)))) {
        free(result);
        return 0;
    }
    
    int i,j;
    size_t len = 0;
    for (i=0;i<n;i++) {
        for (j=0;j<m;j++) {
            int count = snprintf(result+len,maxSize-len-1," %*.*f",p,q,A[i+j*n]);
            if (count <= 0) {
                free(result);
                result = NULL;
                return 0;
            }
            len += count;
        }
        len += snprintf(result+len,maxSize,"\n");
    }
    *buffer = result;
    return len;
}

extern void tracet(int level, const char *format, ...) 
{
    va_list args;
    va_start(args,format); vtracet(level, format, args); va_end(args);
}

extern void vtracet(int level, const char *format, va_list args) 
{
    va_list args2;
    va_copy(args2, args);

    if (level<=gettracelevel()) { 
        const char * level_format = "(level: %d) (time: %dms)";
        uint32_t timer = tickget()-tick_trace;
        int size1 = snprintf(NULL, 0, level_format, level, timer);
        char *str1 = (char*)calloc(size1+1, sizeof(char));
        snprintf(str1, size1+1, level_format, level, timer);
        
        int size2 = vsnprintf(NULL, 0, format, args);
        
        char *str2 = (char*)calloc(size2+1, sizeof(char));
        vsnprintf(str2, size2+1, format, args2);

        flutter_printf("%s %s", str1, str2);
    }
}

extern void traceobs(int level, const obsd_t *obs, int n)
{
    char str[64],id[16];
    int i;
    const char * flutter_format = "(%2d) %s %-3s rcv%d %13.3f %13.3f %13.3f %13.3f %d %d %d %d %x %x %3.1f %3.1f\n";

    for (i=0;i<n;i++) {
        time2str(obs[i].time,str,3);
        satno2id(obs[i].sat,id);

    flutter_trace(level, flutter_format, 
        i+1,str,id,obs[i].rcv,obs[i].L[0],obs[i].L[1],obs[i].P[0],
        obs[i].P[1],obs[i].LLI[0],obs[i].LLI[1],obs[i].code[0],
        obs[i].code[1],obs[i].Lstd[0],obs[i].Pstd[0],obs[i].SNR[0]*SNR_UNIT,obs[i].SNR[1]*SNR_UNIT);
        

    }
}

extern void tracenav(int level, const nav_t *nav)
{
    char s1[64],s2[64],id[16];
    int i;
    
    if (level>level_trace) return;
    for (i=0;i<nav->n;i++) {
        time2str(nav->eph[i].toe,s1,0);
        time2str(nav->eph[i].ttr,s2,0);
        satno2id(nav->eph[i].sat,id);
        trace(level,"(%3d) %-3s : %s %s %3d %3d %02x\n",i+1,
                id,s1,s2,nav->eph[i].iode,nav->eph[i].iodc,nav->eph[i].svh);
    }
    trace(level,"(ion) %9.4e %9.4e %9.4e %9.4e\n",nav->ion_gps[0],
            nav->ion_gps[1],nav->ion_gps[2],nav->ion_gps[3]);
    trace(level,"(ion) %9.4e %9.4e %9.4e %9.4e\n",nav->ion_gps[4],
            nav->ion_gps[5],nav->ion_gps[6],nav->ion_gps[7]);
    trace(level,"(ion) %9.4e %9.4e %9.4e %9.4e\n",nav->ion_gal[0],
            nav->ion_gal[1],nav->ion_gal[2],nav->ion_gal[3]);
}

extern void tracegnav(int level, const nav_t *nav)
{
    char s1[64],s2[64],id[16];
    int i;
    
    if (level>level_trace) return;
    for (i=0;i<nav->ng;i++) {
        time2str(nav->geph[i].toe,s1,0);
        time2str(nav->geph[i].tof,s2,0);
        satno2id(nav->geph[i].sat,id);
        trace(level,"(%3d) %-3s : %s %s %2d %2d %8.3f\n",i+1,
                id,s1,s2,nav->geph[i].frq,nav->geph[i].svh,nav->geph[i].taun*1E6);
    }
}

extern void tracehnav(int level, const nav_t *nav)
{
    char s1[64],s2[64],id[16];
    int i;
    
    if (level>level_trace) return;
    for (i=0;i<nav->ns;i++) {
        time2str(nav->seph[i].t0,s1,0);
        time2str(nav->seph[i].tof,s2,0);
        satno2id(nav->seph[i].sat,id);
        trace(level,"(%3d) %-3s : %s %s %2d %2d\n",i+1,
                id,s1,s2,nav->seph[i].svh,nav->seph[i].sva);
    }
}

extern void tracepeph(int level, const nav_t *nav)
{
    char s[64],id[16];
    int i,j;
    
    if (level>level_trace) return;
    
    for (i=0;i<nav->ne;i++) {
        time2str(nav->peph[i].time,s,0);
        for (j=0;j<MAXSAT;j++) {
            satno2id(j+1,id);
            trace(level,"%-3s %d %-3s %13.3f %13.3f %13.3f %13.3f %6.3f %6.3f %6.3f %6.3f\n",
                    s,nav->peph[i].index,id,
                    nav->peph[i].pos[j][0],nav->peph[i].pos[j][1],
                    nav->peph[i].pos[j][2],nav->peph[i].pos[j][3]*1E9,
                    nav->peph[i].std[j][0],nav->peph[i].std[j][1],
                    nav->peph[i].std[j][2],nav->peph[i].std[j][3]*1E9);
        }
    }
}

extern void tracepclk(int level, const nav_t *nav)
{
    char s[64],id[16];
    int i,j;
    
    if (level>level_trace) return;
    
    for (i=0;i<nav->nc;i++) {
        time2str(nav->pclk[i].time,s,0);
        for (j=0;j<MAXSAT;j++) {
            satno2id(j+1,id);
            trace(level,"%-3s %d %-3s %13.3f %6.3f\n",
                    s,nav->pclk[i].index,id,
                    nav->pclk[i].clk[j][0]*1E9,nav->pclk[i].std[j][0]*1E9);
        }
    }
}

extern void traceb(int level, const uint8_t *p, int n)
{
    int i;
    if (level>level_trace) return;
    size_t maxSize = 256*n;
    char * buffer = (char*)calloc(maxSize+1,sizeof(char));
    for (i=0;i<n;i++) snprintf(buffer,maxSize-1,"%02X%s",*p++,i%8==7?" ":"");
    snprintf(buffer,maxSize,"\n");
}

/// show message
extern int showmsg(const char *format, ...)
{
    if (flutter_print == NULL) return 0;
    va_list arg;
    va_start(arg,format); flutter_printf(format,arg); va_end(arg);
    flutter_printf(*format?"\r":"\n");
    return 0;
}

#endif // TRACE && EXTERNAL_TRACE

#if (defined(TRACE) || defined(EXTERNAL_TRACE)) && defined(FLUTTER_DEBUG)

static void flutter_default_debug_handler(char *message, size_t length, int level) {
    std::string msg{message, length};
    std::cout << "rtklib cout: " << message << std::endl; 
}

void (*flutter_print)(char *message, size_t length, int level) = flutter_default_debug_handler;

extern bool flutter_initialize(Dart_Port send_port)
{
    assert(print_send_port < 0);
    
    if (send_port <= 0 || print_send_port > 0) {
        return false;
    } 

    print_send_port = send_port;
    flutter_print = [](char * message, size_t len, int level) {
        NotifyDart(print_send_port, message, len, level);
    };
    if (flutter_print != NULL) {
        char str[] = "C library initialized\n";
        flutter_print(str, strlen(str), 3);
        return true;
    }
    return false;
}

extern int flutter_printf(const char *format, ...)
{
    if (flutter_print == NULL) return 0;

    va_list args;
  
    int done;
    va_start (args, format);
    done = flutter_vprintf(format, args);
    va_end(args);

    return done;
}

extern int flutter_vprintf(const char *format, va_list args)
{
    if (flutter_print == NULL) return 0;

    va_list args_copy;
    va_copy(args_copy, args);

    int size = vsnprintf(NULL, 0, format, args);

    char *str = NULL;
    if (!(str = (char*)calloc(size+1, sizeof(char)))) {
        if (str) free(str);
        str = NULL;
        return 0;
    }
    int done = vsnprintf(str, size+1, format, args_copy);

    flutter_print(str, done, 0);
    free(str);
    return done;
}

extern int flutter_trace(int level, const char *format, ...) {
    if (level<=gettracelevel()) {      
        va_list args;
        va_start(args,format); 
        int res = flutter_vtrace(level, format, args);
        va_end(args);

        return res;
    }
    return 0;
}

extern int flutter_vtrace(int level, const char *format, va_list args) {  
    if (level<=gettracelevel()) {
        va_list(args_copy);
        va_copy(args_copy, args);

        const char * level_format = "(level: %d)";
        int size1 = snprintf(NULL, 0, level_format, level);
        char *str1 = (char*)calloc(size1+1, sizeof(char));
        snprintf(str1, size1+1, level_format, level);

        int size2 = vsnprintf(NULL, 0, format, args);
        char *str2 = (char*)calloc(size2+1, sizeof(char));
        vsnprintf(str2, size2+1, format, args_copy);
        return flutter_printf("%s %s", str1, str2);
    }

    return 0;
}

extern void set_level_trace(int level) {
    tracelevel(level);
}


#else

extern void flutter_initialize(void (*printCallback)(char *, uint64_t)) {}
extern int flutter_printf(const char *format, ...) { return 0; }
extern int flutter_vprintf(const char *format, va_list args) { return 0; }
extern int flutter_vprintf(const char *format, va_list args) { return 0; }
extern int flutter_trace(int level, const char *format, ...) { return 0; }
extern int flutter_vtrace(int level, const char *format, va_list args) { return 0; }

#endif // (TRACE || EXTERNAL_TRACE) && FLUTTER_DEBUG
