#include "rtklib_api.h"

// OVERRIDE TRACE FOR FLUTTER DEBUG
#if !defined(TRACE) && defined(EXTERNAL_TRACE)

/// file pointer of trace
static FILE *fp_trace=NULL;     
/// trace file
static char file_trace[1024];   
/// level of trace
static int level_trace=0;       
/// tick time at traceopen (ms)
static uint32_t tick_trace=0;   
/// time at traceopen
static gtime_t time_trace={0};  
/// lock for trace
static lock_t lock_trace;       

static void traceswap(void)
{
    gtime_t time=utc2gpst(timeget());
    char path[1024];
    
    lock(&lock_trace);
    
    if ((int)(time2gpst(time      ,NULL)/INT_SWAP_TRAC)==
        (int)(time2gpst(time_trace,NULL)/INT_SWAP_TRAC)) {
        unlock(&lock_trace);
        return;
    }
    time_trace=time;
    
    if (!reppath(file_trace,path,time,"","")) {
        unlock(&lock_trace);
        return;
    }
    if (fp_trace) fclose(fp_trace);
    
    if (!(fp_trace=fopen(path,"w"))) {
        fp_trace=stderr;
    }
    unlock(&lock_trace);
}

extern void traceopen(const char *file)
{
    gtime_t time=utc2gpst(timeget());
    char path[1024];
    
    reppath(file,path,time,"","");
    if (!*path||!(fp_trace=fopen(path,"w"))) fp_trace=stderr;
    strcpy(file_trace,file);
    tick_trace=tickget();
    time_trace=time;
    initlock(&lock_trace);
}

extern void traceclose(void)
{
    if (fp_trace&&fp_trace!=stderr) fclose(fp_trace);
    fp_trace=NULL;
    file_trace[0]='\0';
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
    if (!fp_trace||level>level_trace) return;
    matfprint(A,n,m,p,q,fp_trace); fflush(fp_trace);
}

extern void tracet(int level, const char *format, ...)
{
    va_list ap;

    if (level<=gettracelevel()) {
        flutter_printf("%d %9.3f: ",level,(tickget()-tick_trace)/1000.0); 
        va_start(ap,format); 
        flutter_vprintf(format,ap); 
        va_end (ap);
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
    
    if (!fp_trace||level>level_trace) return;
    for (i=0;i<nav->n;i++) {
        time2str(nav->eph[i].toe,s1,0);
        time2str(nav->eph[i].ttr,s2,0);
        satno2id(nav->eph[i].sat,id);
        fprintf(fp_trace,"(%3d) %-3s : %s %s %3d %3d %02x\n",i+1,
                id,s1,s2,nav->eph[i].iode,nav->eph[i].iodc,nav->eph[i].svh);
    }
    fprintf(fp_trace,"(ion) %9.4e %9.4e %9.4e %9.4e\n",nav->ion_gps[0],
            nav->ion_gps[1],nav->ion_gps[2],nav->ion_gps[3]);
    fprintf(fp_trace,"(ion) %9.4e %9.4e %9.4e %9.4e\n",nav->ion_gps[4],
            nav->ion_gps[5],nav->ion_gps[6],nav->ion_gps[7]);
    fprintf(fp_trace,"(ion) %9.4e %9.4e %9.4e %9.4e\n",nav->ion_gal[0],
            nav->ion_gal[1],nav->ion_gal[2],nav->ion_gal[3]);
}

extern void tracegnav(int level, const nav_t *nav)
{
    char s1[64],s2[64],id[16];
    int i;
    
    if (!fp_trace||level>level_trace) return;
    for (i=0;i<nav->ng;i++) {
        time2str(nav->geph[i].toe,s1,0);
        time2str(nav->geph[i].tof,s2,0);
        satno2id(nav->geph[i].sat,id);
        fprintf(fp_trace,"(%3d) %-3s : %s %s %2d %2d %8.3f\n",i+1,
                id,s1,s2,nav->geph[i].frq,nav->geph[i].svh,nav->geph[i].taun*1E6);
    }
}

extern void tracehnav(int level, const nav_t *nav)
{
    char s1[64],s2[64],id[16];
    int i;
    
    if (!fp_trace||level>level_trace) return;
    for (i=0;i<nav->ns;i++) {
        time2str(nav->seph[i].t0,s1,0);
        time2str(nav->seph[i].tof,s2,0);
        satno2id(nav->seph[i].sat,id);
        fprintf(fp_trace,"(%3d) %-3s : %s %s %2d %2d\n",i+1,
                id,s1,s2,nav->seph[i].svh,nav->seph[i].sva);
    }
}

extern void tracepeph(int level, const nav_t *nav)
{
    char s[64],id[16];
    int i,j;
    
    if (!fp_trace||level>level_trace) return;
    
    for (i=0;i<nav->ne;i++) {
        time2str(nav->peph[i].time,s,0);
        for (j=0;j<MAXSAT;j++) {
            satno2id(j+1,id);
            fprintf(fp_trace,"%-3s %d %-3s %13.3f %13.3f %13.3f %13.3f %6.3f %6.3f %6.3f %6.3f\n",
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
    
    if (!fp_trace||level>level_trace) return;
    
    for (i=0;i<nav->nc;i++) {
        time2str(nav->pclk[i].time,s,0);
        for (j=0;j<MAXSAT;j++) {
            satno2id(j+1,id);
            fprintf(fp_trace,"%-3s %d %-3s %13.3f %6.3f\n",
                    s,nav->pclk[i].index,id,
                    nav->pclk[i].clk[j][0]*1E9,nav->pclk[i].std[j][0]*1E9);
        }
    }
}

extern void traceb(int level, const uint8_t *p, int n)
{
    int i;
    if (!fp_trace||level>level_trace) return;
    for (i=0;i<n;i++) fprintf(fp_trace,"%02X%s",*p++,i%8==7?" ":"");
    fprintf(fp_trace,"\n");
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

static void flutter_default_debug_handler(char *format, uint64_t length) {}

void (*flutter_print)(char *format, uint64_t length) = flutter_default_debug_handler;

extern void flutter_initialize(void (*printCallback)(char *, uint64_t))
{
    flutter_print = printCallback;
    if (flutter_print != NULL) {
        char str[] = "C library initialized";
        flutter_print(str, strlen(str));
    }
}

extern int flutter_printf(const char *format, ...)
{
    if (flutter_print == NULL) return 0;

    va_list args1;
  
    int done;
    va_start (args1, format);
    done = flutter_vprintf(format, args1);
    va_end(args1);

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
        free(str);
        return 0;
    }
    int done = vsnprintf(str, size, format, args_copy);

    flutter_print(str, done);
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
        char str1[80];
        char str2[256*2];
        const char * level_format = "(level: %d)";
        int size1 = snprintf(NULL, 0, level_format, level);
        snprintf(str1, size1 + 1, level_format, level);

        int size2 = vsnprintf(NULL, 0, format, args);
        vsnprintf(str2, size2 + 1, format, args);
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
