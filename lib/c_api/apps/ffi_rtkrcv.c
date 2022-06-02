/*------------------------------------------------------------------------------
* rtkrcv.c : rtk-gps/gnss receiver console ap
*
*          Copyright (C) 2009-2015 by T.TAKASU, All rights reserved.
*
* notes   :
*     current version does not support win32 without pthread library
*
* version : $Revision:$ $Date:$
* history : 2009/12/13 1.0  new
*           2010/07/18 1.1  add option -m
*           2010/08/12 1.2  fix bug on ftp/http
*           2011/01/22 1.3  add option misc-proxyaddr,misc-fswapmargin
*           2011/08/19 1.4  fix bug on size of arg solopt arg for rtksvrstart()
*           2012/11/03 1.5  fix bug on setting output format
*           2013/06/30 1.6  add "nvs" option for inpstr*-format
*           2014/02/10 1.7  fix bug on printing obs data
*                           add print of status, glonass nav data
*                           ignore SIGHUP
*           2014/04/27 1.8  add "binex" option for inpstr*-format
*           2014/08/10 1.9  fix cpu overload with abnormal telnet shutdown
*           2014/08/26 1.10 support input format "rt17"
*                           change file paths of solution status and debug trace
*           2015/01/10 1.11 add line editting and command history
*                           separate codes for virtual console to vt.c
*           2015/05/22 1.12 fix bug on sp3 id in inpstr*-format options
*           2015/07/31 1.13 accept 4:stat for outstr1-format or outstr2-format
*                           add reading satellite dcb
*           2015/12/14 1.14 add option -sta for station name (#339)
*           2015/12/25 1.15 fix bug on -sta option (#339)
*           2015/01/26 1.16 support septentrio
*           2016/07/01 1.17 support CMR/CMR+
*           2016/08/20 1.18 add output of patch level with version
*           2016/09/05 1.19 support ntrip caster for output stream
*           2016/09/19 1.20 support multiple remote console connections
*                           add option -w
*           2017/09/01 1.21 add command ssr
*-----------------------------------------------------------------------------*/
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/tcp.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <errno.h>
#include "rtklib.h"

#define PRGNAME     "rtkrcv"            /* program name */
#define CMDPROMPT   "rtkrcv> "          /* command prompt */
#define MAXCON      32                  /* max number of consoles */
#define MAXARG      10                  /* max number of args in a command */
#define MAXCMD      256                 /* max length of a command */
#define MAXSTR      1024                /* max length of a stream */
#define OPTSDIR     "."                 /* default config directory */
#define OPTSFILE    "rtkrcv.conf"       /* default config file */
#define NAVIFILE    "rtkrcv.nav"        /* navigation save file */
#define STATFILE    "rtkrcv_%Y%m%d%h%M.stat"  /* solution status file */
#define TRACEFILE   "rtkrcv_%Y%m%d%h%M.trace" /* debug trace file */
#define INTKEEPALIVE 1000               /* keep alive interval (ms) */

#define ESC_CLEAR   "\033[H\033[2J"     /* ansi/vt100 escape: erase screen */
#define ESC_RESET   "\033[0m"           /* ansi/vt100: reset attribute */
#define ESC_BOLD    "\033[1m"           /* ansi/vt100: bold */

#define SQRT(x)     ((x)<=0.0||(x)!=(x)?0.0:sqrt(x))

/* type defintions -----------------------------------------------------------*/

typedef struct {                       /* console type */
    int state;                         /* state (0:stop,1:run) */
    //vt_t *vt;                          /* virtual terminal */
    pthread_t thread;                  /* console thread */
} con_t;

/* function prototypes -------------------------------------------------------*/
extern FILE *popen(const char *, const char *);
extern int pclose(FILE *);

/* global variables ----------------------------------------------------------*/
static rtksvr_t svr;                    /* rtk server struct */
static stream_t moni;                   /* monitor stream */

static int intflg       =0;             /* interrupt flag (2:shtdown) */

static char passwd[MAXSTR]="admin";     /* login password */
static int timetype     =0;             /* time format (0:gpst,1:utc,2:jst,3:tow) */
static int soltype      =0;             /* sol format (0:dms,1:deg,2:xyz,3:enu,4:pyl) */
static int solflag      =2;             /* sol flag (1:std+2:age/ratio/ns) */
static int strtype[]={                  /* stream types */
    STR_SERIAL,STR_NONE,STR_NONE,STR_NONE,STR_NONE,STR_NONE,STR_NONE,STR_NONE
};
static char strpath[8][MAXSTR]={"","","","","","","",""}; /* stream paths */
static int strfmt[]={                   /* stream formats */
    STRFMT_UBX,STRFMT_RTCM3,STRFMT_SP3,SOLF_LLH,SOLF_NMEA
};
static int svrcycle     =10;            /* server cycle (ms) */
static int timeout      =10000;         /* timeout time (ms) */
static int reconnect    =10000;         /* reconnect interval (ms) */
static int nmeacycle    =5000;          /* nmea request cycle (ms) */
static int buffsize     =32768;         /* input buffer size (bytes) */
static int navmsgsel    =0;             /* navigation mesaage select */
static char proxyaddr[256]="";          /* http/ntrip proxy */
static int nmeareq      =0;             /* nmea request type (0:off,1:lat/lon,2:single) */
static double nmeapos[] ={0,0,0};       /* nmea position (lat/lon/height) (deg,m) */
static char rcvcmds[3][MAXSTR]={""};    /* receiver commands files */
static char startcmd[MAXSTR]="";        /* start command */
static char stopcmd [MAXSTR]="";        /* stop command */
static int modflgr[256] ={0};           /* modified flags of receiver options */
static int modflgs[256] ={0};           /* modified flags of system options */
static int moniport     =0;             /* monitor port */
static int keepalive    =0;             /* keep alive flag */
static int start        =0;             /* auto start */
static int fswapmargin  =30;            /* file swap margin (s) */
static char sta_name[256]="";           /* station name */

static prcopt_t prcopt;                 /* processing options */
static solopt_t solopt[2]={{0}};        /* solution options */
static filopt_t filopt  ={""};          /* file options */

/* help text -----------------------------------------------------------------*/
static const char *usage[]={
    "usage: rtkrcv [-s][-p port][-d dev][-o file][-w pwd][-r level][-t level][-sta sta]",
    "options",
    "  -s         start RTK server on program startup",
    "  -p port    port number for telnet console",
    "  -m port    port number for monitor stream",
    "  -d dev     terminal device for console",
    "  -o file    processing options file",
    "  -w pwd     login password for remote console (\"\": no password)",
    "  -r level   output solution status file (0:off,1:states,2:residuals)",
    "  -t level   debug trace level (0:off,1-5:on)",
    "  -sta sta   station name for receiver dcb"
};
static const char *helptxt[]={
    "start                 : start rtk server",
    "stop                  : stop rtk server",
    "restart               : restart rtk sever",
    "solution [cycle]      : show solution",
    "status [cycle]        : show rtk status",
    "satellite [-n] [cycle]: show satellite status",
    "observ [-n] [cycle]   : show observation data",
    "navidata [cycle]      : show navigation data",
    "stream [cycle]        : show stream status",
    "ssr [cycle]           : show ssr corrections",
    "error                 : show error/warning messages",
    "option [opt]          : show option(s)",
    "set opt [val]         : set option",
    "load [file]           : load options from file",
    "save [file]           : save options to file",
    "log [file|off]        : start/stop log to file",
    "help|? [path]         : print help",
    "exit|ctr-D            : logout console (only for telnet)",
    "shutdown              : shutdown rtk server",
    "!command [arg...]     : execute command in shell",
    ""
};
static const char *pathopts[]={         /* path options help */
    "stream path formats",
    "serial   : port[:bit_rate[:byte[:parity(n|o|e)[:stopb[:fctr(off|on)[#port]]]]]]]",
    "file     : path[::T[::+offset][::xspeed]]",
    "tcpsvr   : :port",
    "tcpcli   : addr:port",
    "ntripsvr : [passwd@]addr:port/mntpnt[:str]",
    "ntripcli : user:passwd@addr:port/mntpnt",
    "ntripcas : user:passwd@:[port]/mpoint[:srctbl]",
    "ftp      : user:passwd@addr/path[::T=poff,tint,off,rint]",
    "http     : addr/path[::T=poff,tint,off,rint]",
    ""
};
/* receiver options table ----------------------------------------------------*/
#define TIMOPT  "0:gpst,1:utc,2:jst,3:tow"
#define CONOPT  "0:dms,1:deg,2:xyz,3:enu,4:pyl"
#define FLGOPT  "0:off,1:std+2:age/ratio/ns"
#define ISTOPT  "0:off,1:serial,2:file,3:tcpsvr,4:tcpcli,6:ntripcli,7:ftp,8:http"
#define OSTOPT  "0:off,1:serial,2:file,3:tcpsvr,4:tcpcli,5:ntripsvr,9:ntripcas"
#define FMTOPT  "0:rtcm2,1:rtcm3,2:oem4,4:ubx,5:swift,6:hemis,7:skytraq,8:javad,9:nvs,10:binex,11:rt17,12:sbf,14,15:sp3"
#define NMEOPT  "0:off,1:latlon,2:single"
#define SOLOPT  "0:llh,1:xyz,2:enu,3:nmea,4:stat"
#define MSGOPT  "0:all,1:rover,2:base,3:corr"

static opt_t rcvopts[]={
    {"console-passwd",  2,  (void *)passwd,              ""     },
    {"console-timetype",3,  (void *)&timetype,           TIMOPT },
    {"console-soltype", 3,  (void *)&soltype,            CONOPT },
    {"console-solflag", 0,  (void *)&solflag,            FLGOPT },
    
    {"inpstr1-type",    3,  (void *)&strtype[0],         ISTOPT },
    {"inpstr2-type",    3,  (void *)&strtype[1],         ISTOPT },
    {"inpstr3-type",    3,  (void *)&strtype[2],         ISTOPT },
    {"inpstr1-path",    2,  (void *)strpath [0],         ""     },
    {"inpstr2-path",    2,  (void *)strpath [1],         ""     },
    {"inpstr3-path",    2,  (void *)strpath [2],         ""     },
    {"inpstr1-format",  3,  (void *)&strfmt [0],         FMTOPT },
    {"inpstr2-format",  3,  (void *)&strfmt [1],         FMTOPT },
    {"inpstr3-format",  3,  (void *)&strfmt [2],         FMTOPT },
    {"inpstr2-nmeareq", 3,  (void *)&nmeareq,            NMEOPT },
    {"inpstr2-nmealat", 1,  (void *)&nmeapos[0],         "deg"  },
    {"inpstr2-nmealon", 1,  (void *)&nmeapos[1],         "deg"  },
    {"inpstr2-nmeahgt", 1,  (void *)&nmeapos[2],         "m"    },
    {"outstr1-type",    3,  (void *)&strtype[3],         OSTOPT },
    {"outstr2-type",    3,  (void *)&strtype[4],         OSTOPT },
    {"outstr1-path",    2,  (void *)strpath [3],         ""     },
    {"outstr2-path",    2,  (void *)strpath [4],         ""     },
    {"outstr1-format",  3,  (void *)&strfmt [3],         SOLOPT },
    {"outstr2-format",  3,  (void *)&strfmt [4],         SOLOPT },
    {"logstr1-type",    3,  (void *)&strtype[5],         OSTOPT },
    {"logstr2-type",    3,  (void *)&strtype[6],         OSTOPT },
    {"logstr3-type",    3,  (void *)&strtype[7],         OSTOPT },
    {"logstr1-path",    2,  (void *)strpath [5],         ""     },
    {"logstr2-path",    2,  (void *)strpath [6],         ""     },
    {"logstr3-path",    2,  (void *)strpath [7],         ""     },
    
    {"misc-svrcycle",   0,  (void *)&svrcycle,           "ms"   },
    {"misc-timeout",    0,  (void *)&timeout,            "ms"   },
    {"misc-reconnect",  0,  (void *)&reconnect,          "ms"   },
    {"misc-nmeacycle",  0,  (void *)&nmeacycle,          "ms"   },
    {"misc-buffsize",   0,  (void *)&buffsize,           "bytes"},
    {"misc-navmsgsel",  3,  (void *)&navmsgsel,          MSGOPT },
    {"misc-proxyaddr",  2,  (void *)proxyaddr,           ""     },
    {"misc-fswapmargin",0,  (void *)&fswapmargin,        "s"    },
    
    {"misc-startcmd",   2,  (void *)startcmd,            ""     },
    {"misc-stopcmd",    2,  (void *)stopcmd,             ""     },
    
    {"file-cmdfile1",   2,  (void *)rcvcmds[0],          ""     },
    {"file-cmdfile2",   2,  (void *)rcvcmds[1],          ""     },
    {"file-cmdfile3",   2,  (void *)rcvcmds[2],          ""     },
    
    {"",0,NULL,""}
};

/* print usage ---------------------------------------------------------------*/
static void printusage(void)
{
    int i;
    for (i=0;i<(int)(sizeof(usage)/sizeof(*usage));i++) {
        trace(1,"%s\n",usage[i]);
    }
    exit(0);
}


/* read antenna file ---------------------------------------------------------*/
static void readant(prcopt_t *opt, nav_t *nav)
{
    const pcv_t pcv0={0};
    pcvs_t pcvr={0},pcvs={0};
    pcv_t *pcv;
    gtime_t time=timeget();
    int i;
    
    trace(3,"readant:\n");
    
    opt->pcvr[0]=opt->pcvr[1]=pcv0;
    if (!*filopt.rcvantp) return;
    
    if (readpcv(filopt.rcvantp,&pcvr)) {
        for (i=0;i<2;i++) {
            if (!*opt->anttype[i]) continue;
            if (!(pcv=searchpcv(0,opt->anttype[i],time,&pcvr))) {
                showmsg("no antenna %s in %s",opt->anttype[i],filopt.rcvantp);
                continue;
            }
            opt->pcvr[i]=*pcv;
        }
    }
    else showmsg("antenna file open error %s",filopt.rcvantp);
    
    if (readpcv(filopt.satantp,&pcvs)) {
        for (i=0;i<MAXSAT;i++) {
            if (!(pcv=searchpcv(i+1,"",time,&pcvs))) continue;
            nav->pcvs[i]=*pcv;
        }
    }
    else showmsg("antenna file open error %s",filopt.satantp);
    
    free(pcvr.pcv); free(pcvs.pcv);
}

/* start rtk server ----------------------------------------------------------*/
static int startsvr()
{
    static sta_t sta[MAXRCV]={{""}};
    double pos[3],npos[3];
    char s1[3][MAXRCVCMD]={"","",""},*cmds[]={NULL,NULL,NULL};
    char s2[3][MAXRCVCMD]={"","",""},*cmds_periodic[]={NULL,NULL,NULL};
    char *ropts[]={"","",""};
    char *paths[]={
        strpath[0],strpath[1],strpath[2],strpath[3],strpath[4],strpath[5],
        strpath[6],strpath[7]
    };
    char errmsg[2048]="";
    int i,ret,stropt[8]={0};
    
    trace(3,"startsvr:\n");
    
    /* read start commads from command files */
    for (i=0;i<3;i++) {
        if (!*rcvcmds[i]) continue;
        if (!readcmd(rcvcmds[i],s1[i],0)) {
            showmsg("no command file: %s\n",rcvcmds[i]);
        }
        else cmds[i]=s1[i];
        if (!readcmd(rcvcmds[i],s2[i],2)) {
            showmsg("no command file: %s\n",rcvcmds[i]);
        }
        else cmds_periodic[i]=s2[i];
    }
    /* confirm overwrite */
    //!! ****************************************************************
    /*
    for (i=3;i<8;i++) {
        if (strtype[i]==STR_FILE
        &&!confwrite(vt,strpath[i])
        ) return 0;
    }
    */
    if (prcopt.refpos==4) { /* rtcm */
        for (i=0;i<3;i++) prcopt.rb[i]=0.0;
    }
    pos[0]=nmeapos[0]*D2R;
    pos[1]=nmeapos[1]*D2R;
    pos[2]=nmeapos[2];
    pos2ecef(pos,npos);
    
    /* read antenna file */
    readant(&prcopt,&svr.nav);
    
    /* read dcb file */
    if (*filopt.dcb) {
        strcpy(sta[0].name,sta_name);
        readdcb(filopt.dcb,&svr.nav,sta);
    }
    /* open geoid data file */
    if (solopt[0].geoid>0&&!opengeoid(solopt[0].geoid,filopt.geoid)) {
        trace(2,"geoid data open error: %s\n",filopt.geoid);
    }
    for (i=0;*rcvopts[i].name;i++) modflgr[i]=0;
    for (i=0;*sysopts[i].name;i++) modflgs[i]=0;
    
    /* set stream options */
    stropt[0]=timeout;
    stropt[1]=reconnect;
    stropt[2]=1000;
    stropt[3]=buffsize;
    stropt[4]=fswapmargin;
    strsetopt(stropt);
    
    if (strfmt[2]==8) strfmt[2]=STRFMT_SP3;
    
    /* set ftp/http directory and proxy */
    strsetdir(filopt.tempdir);
    strsetproxy(proxyaddr);
    
    /* execute start command */
    if (*startcmd&&(ret=system(startcmd))) {
        trace(2,"command exec error: %s (%d)\n",startcmd,ret);
    }
    solopt[0].posf=strfmt[3];
    solopt[1].posf=strfmt[4];
    
    /* start rtk server */
    if (!rtksvrstart(&svr,svrcycle,buffsize,strtype,paths,strfmt,navmsgsel,
                     cmds,cmds_periodic,ropts,nmeacycle,nmeareq,npos,&prcopt,
                     solopt,&moni,errmsg)) {
        trace(2,"rtk server start error (%s)\n",errmsg);
        return 0;
    }
    return 1;
}

extern int run_rtkrcv_cmd(int argc, char **argv) {
    con_t *con[MAXCON]={0};
    int i,port=0,outstat=0,trace_level=0,sock=0;
    char *dev="",file[MAXSTR]="";
    
    for (i=1;i<argc;i++) {
        if      (!strcmp(argv[i],"-s")) start=1;
        else if (!strcmp(argv[i],"-p")&&i+1<argc) port=atoi(argv[++i]);
        else if (!strcmp(argv[i],"-m")&&i+1<argc) moniport=atoi(argv[++i]);
        else if (!strcmp(argv[i],"-d")&&i+1<argc) dev=argv[++i];
        else if (!strcmp(argv[i],"-o")&&i+1<argc) strcpy(file,argv[++i]);
        else if (!strcmp(argv[i],"-w")&&i+1<argc) strcpy(passwd,argv[++i]);
        else if (!strcmp(argv[i],"-r")&&i+1<argc) outstat=atoi(argv[++i]);
        else if (!strcmp(argv[i],"-t")&&i+1<argc) trace_level=atoi(argv[++i]);
        else if (!strcmp(argv[i],"-sta")&&i+1<argc) strcpy(sta_name,argv[++i]);
        else printusage();
    }

    if (trace_level>0) {
        tracelevel(trace_level);
    }

    /* initialize rtk server and monitor port */
    rtksvrinit(&svr);
    strinit(&moni);
    
    /* load options file */
    if (!*file) sprintf(file,"%s/%s",OPTSDIR,OPTSFILE);

    resetsysopts();
    if (!loadopts(file,rcvopts)||!loadopts(file,sysopts)) {
        trace(1,"no options file: %s. defaults used\n",file);
    }
    getsysopts(&prcopt,solopt,&filopt);

    /* read navigation data */
    if (!readnav(NAVIFILE,&svr.nav)) {
        trace(1,"no navigation data: %s\n",NAVIFILE);
    }

    if (outstat>0) {
        rtkopenstat(STATFILE,outstat);
    }

    if (start) startsvr();

    return 0;
}
