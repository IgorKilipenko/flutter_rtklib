#include "ffi_rtkrcv.hpp"
#include <thread>

Dart_Port rtkrcv_send_port = -1;
void (*rtkrcv_port_callback)() = NULL;

#define MIN_INT_RESET   30000   /* mininum interval of reset command (ms) */

/* baseline length -----------------------------------------------------------*/
static double baseline_len(const rtk_t *rtk)
{
	double dr[3];
	int i;

	if (norm(rtk->sol.rr,3)<=0.0||norm(rtk->rb,3)<=0.0) return 0.0;

	for (i=0;i<3;i++) {
		dr[i]=rtk->sol.rr[i]-rtk->rb[i];
	}
	return norm(dr,3)*0.001; /* (km) */
}

/* ------------------------------- */
/* Update static functions */
/* ------------------------------- */

/* update glonass frequency channel number in raw data struct ----------------*/
static void update_glofcn(rtksvr_t *svr)
{
    int i,j,sat,frq;
    
    for (i=0;i<MAXPRNGLO;i++) {
        sat=satno(SYS_GLO,i+1);
        
        for (j=0,frq=-999;j<3;j++) {
            if (svr->raw[j].nav.geph[i].sat!=sat) continue;
            frq=svr->raw[j].nav.geph[i].frq;
        }
        if (frq<-7||frq>6) continue;
        
        for (j=0;j<3;j++) {
            if (svr->raw[j].nav.geph[i].sat==sat) continue;
            svr->raw[j].nav.geph[i].sat=sat;
            svr->raw[j].nav.geph[i].frq=frq;
        }
    }
}
/* update observation data ---------------------------------------------------*/
static void update_obs(rtksvr_t *svr, obs_t *obs, int index, int iobs)
{
    int i,n=0,sat,sys;
    
        if (iobs<MAXOBSBUF) {
            for (i=0;i<obs->n;i++) {
            sat=obs->data[i].sat;
            sys=satsys(sat,NULL);
            if (svr->rtk.opt.exsats[sat-1]==1||!(sys&svr->rtk.opt.navsys)) {
                continue;
            }
                svr->obs[index][iobs].data[n]=obs->data[i];
                svr->obs[index][iobs].data[n++].rcv=index+1;
            }
            svr->obs[index][iobs].n=n;
            sortobs(&svr->obs[index][iobs]);
        }
        svr->nmsg[index][0]++;
    }
/* update ephemeris ----------------------------------------------------------*/
static void update_eph(rtksvr_t *svr, nav_t *nav, int ephsat, int ephset,
                       int index)
{
    eph_t *eph1,*eph2,*eph3;
    geph_t *geph1,*geph2,*geph3;
    int prn;
    
    if (satsys(ephsat,&prn)!=SYS_GLO) {
            if (!svr->navsel||svr->navsel==index+1) {
            /* svr->nav.eph={current_set1,current_set2,prev_set1,prev_set2} */
            eph1=nav->eph+ephsat-1+MAXSAT*ephset;         /* received */
            eph2=svr->nav.eph+ephsat-1+MAXSAT*ephset;     /* current */
            eph3=svr->nav.eph+ephsat-1+MAXSAT*(2+ephset); /* previous */
                if (eph2->ttr.time==0||
                    (eph1->iode!=eph3->iode&&eph1->iode!=eph2->iode)||
                    (timediff(eph1->toe,eph3->toe)!=0.0&&
                 timediff(eph1->toe,eph2->toe)!=0.0)||
                (timediff(eph1->toc,eph3->toc)!=0.0&&
                 timediff(eph1->toc,eph2->toc)!=0.0)) {
                *eph3=*eph2; /* current ->previous */
                *eph2=*eph1; /* received->current */
                }
            }
            svr->nmsg[index][1]++;
        }
        else {
           if (!svr->navsel||svr->navsel==index+1) {
               geph1=nav->geph+prn-1;
               geph2=svr->nav.geph+prn-1;
               geph3=svr->nav.geph+prn-1+MAXPRNGLO;
               if (geph2->tof.time==0||
                   (geph1->iode!=geph3->iode&&geph1->iode!=geph2->iode)) {
                   *geph3=*geph2;
                   *geph2=*geph1;
                update_glofcn(svr);
               }
           }
           svr->nmsg[index][6]++;
        }
    }
/* update sbas message -------------------------------------------------------*/
static void update_sbs(rtksvr_t *svr, sbsmsg_t *sbsmsg, int index)
{
    int i,sbssat=svr->rtk.opt.sbassatsel;
    
        if (sbsmsg&&(sbssat==sbsmsg->prn||sbssat==0)) {
        sbsmsg->rcv=index+1;
            if (svr->nsbs<MAXSBSMSG) {
                svr->sbsmsg[svr->nsbs++]=*sbsmsg;
            }
            else {
                for (i=0;i<MAXSBSMSG-1;i++) svr->sbsmsg[i]=svr->sbsmsg[i+1];
                svr->sbsmsg[i]=*sbsmsg;
            }
            sbsupdatecorr(sbsmsg,&svr->nav);
        }
        svr->nmsg[index][3]++;
    }
/* update ion/utc parameters -------------------------------------------------*/
static void update_ionutc(rtksvr_t *svr, nav_t *nav, int index)
{
        if (svr->navsel==0||svr->navsel==index+1) {
        matcpy(svr->nav.utc_gps,nav->utc_gps,8,1);
        matcpy(svr->nav.utc_glo,nav->utc_glo,8,1);
        matcpy(svr->nav.utc_gal,nav->utc_gal,8,1);
        matcpy(svr->nav.utc_qzs,nav->utc_qzs,8,1);
        matcpy(svr->nav.utc_cmp,nav->utc_cmp,8,1);
        matcpy(svr->nav.utc_irn,nav->utc_irn,9,1);
        matcpy(svr->nav.utc_sbs,nav->utc_sbs,4,1);
        matcpy(svr->nav.ion_gps,nav->ion_gps,8,1);
        matcpy(svr->nav.ion_gal,nav->ion_gal,4,1);
        matcpy(svr->nav.ion_qzs,nav->ion_qzs,8,1);
        matcpy(svr->nav.ion_cmp,nav->ion_cmp,8,1);
        matcpy(svr->nav.ion_irn,nav->ion_irn,8,1);
        }
        svr->nmsg[index][2]++;
    }
/* update antenna position ---------------------------------------------------*/
static void update_antpos(rtksvr_t *svr, int index)
{
    sta_t *sta;
    double pos[3],del[3]={0},dr[3];
    int i;

        if (svr->rtk.opt.refpos==POSOPT_RTCM&&index==1) {
        if (svr->format[1]==STRFMT_RTCM2||svr->format[1]==STRFMT_RTCM3) {
            sta=&svr->rtcm[1].sta;
            }
        else {
            sta=&svr->raw[1].sta;
        }
        /* update base station position */
            for (i=0;i<3;i++) {
            svr->rtk.rb[i]=sta->pos[i];
            }
            /* antenna delta */
            ecef2pos(svr->rtk.rb,pos);
        if (sta->deltype) { /* xyz */
            del[2]=sta->hgt;
                enu2ecef(pos,del,dr);
                for (i=0;i<3;i++) {
                svr->rtk.rb[i]+=sta->del[i]+dr[i];
                }
            }
            else { /* enu */
            enu2ecef(pos,sta->del,dr);
                for (i=0;i<3;i++) {
                    svr->rtk.rb[i]+=dr[i];
                }
            }
        }
        svr->nmsg[index][4]++;
    }
/* update ssr corrections ----------------------------------------------------*/
static void update_ssr(rtksvr_t *svr, int index)
{
    int i,sys,prn,iode;

    for (i=0;i<MAXSAT;i++) {
        if (!svr->rtcm[index].ssr[i].update) continue;
        
        /* check consistency between iods of orbit and clock */
    if (svr->rtcm[index].ssr[i].iod[0]!=svr->rtcm[index].ssr[i].iod[1]) {
        continue;
    }
        svr->rtcm[index].ssr[i].update=0;
        
        iode=svr->rtcm[index].ssr[i].iode;
        sys=satsys(i+1,&prn);
        
        /* check corresponding ephemeris exists */
        if (sys==SYS_GPS||sys==SYS_GAL||sys==SYS_QZS) {
            if (svr->nav.eph[i       ].iode!=iode&&
                svr->nav.eph[i+MAXSAT].iode!=iode) {
                continue;
            }
        }
        else if (sys==SYS_GLO) {
            if (svr->nav.geph[prn-1          ].iode!=iode&&
                svr->nav.geph[prn-1+MAXPRNGLO].iode!=iode) {
                continue;
            }
        }
        svr->nav.ssr[i]=svr->rtcm[index].ssr[i];
    }
    svr->nmsg[index][7]++;
}

/* update rtk server struct --------------------------------------------------*/
static void update_svr(rtksvr_t *svr, int ret, obs_t *obs, nav_t *nav,
                       int ephsat, int ephset, sbsmsg_t *sbsmsg, int index,
                       int iobs)
{
    tracet(4,"updatesvr: ret=%d ephsat=%d ephset=%d index=%d\n",ret,ephsat,
           ephset,index);
    
    if (ret==1) { /* observation data */
        update_obs(svr,obs,index,iobs);
    }
    else if (ret==2) { /* ephemeris */
        update_eph(svr,nav,ephsat,ephset,index);
    }
    else if (ret==3) { /* sbas message */
        update_sbs(svr,sbsmsg,index);
    }
    else if (ret==9) { /* ion/utc parameters */
        update_ionutc(svr,nav,index);
    }
    else if (ret==5) { /* antenna postion */
        update_antpos(svr,index);
    }
    else if (ret==7) { /* dgps correction */
        svr->nmsg[index][5]++;
    }
    else if (ret==10) { /* ssr message */
        update_ssr(svr,index);
    }
    else if (ret==-1) { /* error */
        svr->nmsg[index][9]++;
    }
}

/* rtk server thread ---------------------------------------------------------*/
static void *rtksvrthread(void *arg)
//static int rtksvrthread(rtksvr_t *svr)
{
    obs_t obs;
    obsd_t data[MAXOBS*2];
    sol_t sol={{0}};
    double tt;
    uint32_t tick,ticknmea,tick1hz,tickreset;
    uint8_t *p,*q;
    char msg[128];
    int i,j,n,fobs[3]={0},cycle,cputime;
    
    tracet(3,"rtksvrthread:\n");
    
    rtksvr_t *svr=(rtksvr_t *)arg;

    svr->state=1; obs.data=data;
    svr->tick=tickget();
    ticknmea=tick1hz=svr->tick-1000;
    tickreset=svr->tick-MIN_INT_RESET;
    
    for (cycle=0;svr->state;cycle++) {
        tracet(-1,"*** rtksvrthread: main for\n");
        tick=tickget();
        bool isEofFile[3] = {false};
        for (i=0;i<3;i++) {
            tracet(-1,"*** rtksvrthread: read svr->buff (FOR)\n");
            p=svr->buff[i]+svr->nb[i]; q=svr->buff[i]+svr->buffsize;
            
            /* read receiver raw/rtcm data from input stream */
            tracet(-1,"*** rtksvrthread read receiver raw/rtcm data from input stream stream->type = %d, i = %d\n", svr->stream[i].type, i);
            if ((n=strread(svr->stream+i,p,q-p))<=0) {
                tracet(-1,"*** rtksvrthread svr->stream->type = %d, i = %d\n", svr->stream[i].type, i);
                if (svr->stream[i].type == STR_FILE || svr->stream[i].type == STR_NONE) {
                    isEofFile[i] = true;
                    if (i == 2 && isEofFile[0] && isEofFile[1]) {
                        tracet(-1,"*** rtksvrthread STOP SERVER\n");
                        svr->state = 0;
                    }
                }
                continue;
            }
            /* write receiver raw/rtcm data to log stream */
            strwrite(svr->stream+i+5,p,n);
            svr->nb[i]+=n;
            
            /* save peek buffer */
            rtksvrlock(svr);
            n=n<svr->buffsize-svr->npb[i]?n:svr->buffsize-svr->npb[i];
            memcpy(svr->pbuf[i]+svr->npb[i],p,n);
            svr->npb[i]+=n;
            rtksvrunlock(svr);
        }
        for (i=0;i<3;i++) {
            tracet(-1,"*** rtksvrthread: decode for\n");
            if (svr->format[i]==STRFMT_SP3||svr->format[i]==STRFMT_RNXCLK) {
                /* decode download file */
                tracet(-1,"*** rtksvrthread: rtksvr_decodefile\n");
                rtksvr_decodefile(svr,i);
            }
            else {
                /* decode receiver raw/rtcm data */
                tracet(-1,"*** rtksvrthread: rtksvr_decoderaw\n");
                fobs[i]=rtksvr_decoderaw(svr,i);
            }
        }
        /* averaging single base pos */
        if (fobs[1]>0&&svr->rtk.opt.refpos==POSOPT_SINGLE) {
            tracet(-1,"*** rtksvrthread: averaging single base pos\n");
            if ((svr->rtk.opt.maxaveep<=0||svr->nave<svr->rtk.opt.maxaveep)&&
                pntpos(svr->obs[1][0].data,svr->obs[1][0].n,&svr->nav,
                       &svr->rtk.opt,&sol,NULL,NULL,msg)) {
                svr->nave++;
                for (i=0;i<3;i++) {
                    svr->rb_ave[i]+=(sol.rr[i]-svr->rb_ave[i])/svr->nave;
                }
            }
            for (i=0;i<3;i++) {
                svr->rtk.opt.rb[i]=svr->rb_ave[i];
            }
        }

        for (i=0;i<fobs[0];i++) { /* for each rover observation data */
            tracet(-1,"*** rtksvrthread: for each rover observation data\n");
            obs.n=0;
            for (j=0;j<svr->obs[0][i].n&&obs.n<MAXOBS*2;j++) {
                tracet(-1,"*** rtksvrthread: observation data for\n");
                obs.data[obs.n++]=svr->obs[0][i].data[j];
            }
            for (j=0;j<svr->obs[1][0].n&&obs.n<MAXOBS*2;j++) {
                tracet(-1,"*** rtksvrthread: observation data for 2\n");
                obs.data[obs.n++]=svr->obs[1][0].data[j];
            }
            /* carrier phase bias correction */
            if (!strstr(svr->rtk.opt.pppopt,"-DIS_FCB")) {
                tracet(-1,"*** rtksvrthread: carrier phase bias correction\n");
                rtksvr_corr_phase_bias(obs.data,obs.n,&svr->nav);
            }
            /* rtk positioning */
            rtksvrlock(svr);
            tracet(-1,"*** rtksvrthread: rtk positioning\n");
            rtkpos(&svr->rtk,obs.data,obs.n,&svr->nav);
            rtksvrunlock(svr);
            
            if (svr->rtk.sol.stat!=SOLQ_NONE) {
                
                /* adjust current time */
                tracet(-1,"*** rtksvrthread: adjust current time\n");
                tt=(int)(tickget()-tick)/1000.0+DTTOL;
                timeset(gpst2utc(timeadd(svr->rtk.sol.time,tt)));
                
                /* write solution */
                tracet(-1,"*** rtksvrthread: write solution\n");
                rtksvr_writesol(svr,i);
            }
            /* if cpu overload, inclement obs outage counter and break */
            if ((int)(tickget()-tick)>=svr->cycle) {
                tracet(-1,"*** rtksvrthread: inclement obs outage counter and breakn\n");
                svr->prcout+=fobs[0]-i-1;
            }
        }
        /* send null solution if no solution (1hz) */
        if (svr->rtk.sol.stat==SOLQ_NONE&&(int)(tick-tick1hz)>=1000) {
            tracet(-1,"*** rtksvrthread: send null solution if no solution (1hz)\n");
            rtksvr_writesol(svr,0);
            tick1hz=tick;
        }
        /* write periodic command to input stream */
        for (i=0;i<3;i++) {
            tracet(-1,"*** rtksvrthread: write periodic command to input stream\n");
            rtksvr_periodic_cmd(cycle*svr->cycle,svr->cmds_periodic[i],svr->stream+i);
        }
        /* send nmea request to base/nrtk input stream */
        if (svr->nmeacycle>0&&(int)(tick-ticknmea)>=svr->nmeacycle) {
            tracet(-1,"*** rtksvrthread: send nmea request to base/nrtk input stream\n");
            rtksvr_send_nmea(svr,&tickreset);
            ticknmea=tick;
        }
        if ((cputime=(int)(tickget()-tick))>0) {
            tracet(-1,"*** rtksvrthread: cputime\n");
            svr->cputime=cputime;
        }
        
        /* sleep until next cycle */
        tracet(-1,"*** rtksvrthread: sleep %dms\n", svr->cycle-cputime);
        sleepms(svr->cycle-cputime);
    }
    for (i=0;i<MAXSTRRTK;i++) {
        tracet(-1,"*** rtksvrthread: strclose (FOR) i=%d. MAXSTRRTK=%d\n", i, MAXSTRRTK);
        strclose(svr->stream+i);
    }
    for (i=0;i<3;i++) {
        tracet(-1,"*** rtksvrthread: free svr (FOR) i=%d from %d\n", i, 3);
        svr->nb[i]=svr->npb[i]=0;
        free(svr->buff[i]); svr->buff[i]=NULL;
        free(svr->pbuf[i]); svr->pbuf[i]=NULL;
        free_raw (svr->raw +i);
        free_rtcm(svr->rtcm+i);
    }
    for (i=0;i<2;i++) {
        tracet(-1,"*** rtksvrthread: free svr->sbuf (FOR) i=%d from %d\n", i, 2);
        svr->nsb[i]=0;
        free(svr->sbuf[i]); svr->sbuf[i]=NULL;
    }
    trace(-2, "rtksever.state=stop");
    return 0;
}

extern void rtksvr_start_rtksvrthread(rtksvr_t *svr) {
    tracet(4,"rtksvr_start_rtksvrthread: \n");

    std::thread thread(rtksvrthread, svr);
    thread.join();
}

/* decode receiver raw/rtcm data ---------------------------------------------*/
extern int rtksvr_decoderaw(rtksvr_t *svr, int index)
{
    obs_t *obs;
    nav_t *nav;
    sbsmsg_t *sbsmsg=NULL;
    int i,ret,ephsat,ephset,fobs=0;
    
    tracet(4,"rtksvr_decoderaw: index=%d\n",index);
    
    rtksvrlock(svr);
    
    for (i=0;i<svr->nb[index];i++) {
        
        /* input rtcm/receiver raw data from stream */
        if (svr->format[index]==STRFMT_RTCM2) {
            ret=input_rtcm2(svr->rtcm+index,svr->buff[index][i]);
            obs=&svr->rtcm[index].obs;
            nav=&svr->rtcm[index].nav;
            ephsat=svr->rtcm[index].ephsat;
            ephset=svr->rtcm[index].ephset;
        }
        else if (svr->format[index]==STRFMT_RTCM3) {
            ret=input_rtcm3(svr->rtcm+index,svr->buff[index][i]);
            obs=&svr->rtcm[index].obs;
            nav=&svr->rtcm[index].nav;
            ephsat=svr->rtcm[index].ephsat;
            ephset=svr->rtcm[index].ephset;
        }
        else {
            ret=input_raw(svr->raw+index,svr->format[index],svr->buff[index][i]);
            obs=&svr->raw[index].obs;
            nav=&svr->raw[index].nav;
            ephsat=svr->raw[index].ephsat;
            ephset=svr->raw[index].ephset;
            sbsmsg=&svr->raw[index].sbsmsg;
        }
#ifdef RTKLIBEXPLORER_DEBUG /* record for receiving tick for debug */
        if (ret==1) {
            trace(0,"%d %10d T=%s NS=%2d\n",index,tickget(),
                  time_str(obs->data[0].time,0),obs->n);
        }
#endif
        /* update rtk server */
        if (ret>0) {
            update_svr(svr,ret,obs,nav,ephsat,ephset,sbsmsg,index,fobs);
        }
        /* observation data received */
        if (ret==1) {
            if (fobs<MAXOBSBUF) fobs++; else svr->prcout++;
        }
    }
    svr->nb[index]=0;
    
    rtksvrunlock(svr);
    
    return fobs;
}

/* decode download file ------------------------------------------------------*/
extern void rtksvr_decodefile(rtksvr_t *svr, int index)
{
    nav_t nav={0};
    char file[1024];
    int nb;
    
    tracet(4,"rtksvr_decodefile: index=%d\n",index);
    
    rtksvrlock(svr);
    
    /* check file path completed */
    if ((nb=svr->nb[index])<=2||
        svr->buff[index][nb-2]!='\r'||svr->buff[index][nb-1]!='\n') {
        rtksvrunlock(svr);
        return;
    }
    strncpy(file,(char *)svr->buff[index],nb-2); file[nb-2]='\0';
    svr->nb[index]=0;
    
    rtksvrunlock(svr);
    
    if (svr->format[index]==STRFMT_SP3) { /* precise ephemeris */
        
        /* read sp3 precise ephemeris */
        readsp3(file,&nav,0);
        if (nav.ne<=0) {
            tracet(1,"sp3 file read error: %s\n",file);
            return;
        }
        /* update precise ephemeris */
        rtksvrlock(svr);
        
        if (svr->nav.peph) free(svr->nav.peph);
        svr->nav.ne=svr->nav.nemax=nav.ne;
        svr->nav.peph=nav.peph;
        svr->ftime[index]=utc2gpst(timeget());
        strcpy(svr->files[index],file);
        
        rtksvrunlock(svr);
    }
    else if (svr->format[index]==STRFMT_RNXCLK) { /* precise clock */
        
        /* read rinex clock */
        if (readrnxc(file,&nav)<=0) {
            tracet(1,"rinex clock file read error: %s\n",file);
            return;
        }
        /* update precise clock */
        rtksvrlock(svr);
        
        if (svr->nav.pclk) free(svr->nav.pclk);
        svr->nav.nc=svr->nav.ncmax=nav.nc;
        svr->nav.pclk=nav.pclk;
        svr->ftime[index]=utc2gpst(timeget());
        strcpy(svr->files[index],file);
        
        rtksvrunlock(svr);
    }
}
/* carrier-phase bias (fcb) correction ---------------------------------------*/
extern void rtksvr_corr_phase_bias(obsd_t *obs, int n, const nav_t *nav)
{
    double freq;
    uint8_t code;
    int i,j;
    
    for (i=0;i<n;i++) for (j=0;j<NFREQ;j++) {
        code=obs[i].code[j];
        if ((freq=sat2freq(obs[i].sat,code,nav))==0.0) continue;
        
        /* correct phase bias (cyc) */
        obs[i].L[j]-=nav->ssr[obs[i].sat-1].pbias[code-1]*freq/CLIGHT;
    }
}
/* periodic command ----------------------------------------------------------*/
extern void rtksvr_periodic_cmd(int cycle, const char *cmd, stream_t *stream)
{
    const char *p=cmd,*q;
    char msg[1024],*r;
    int n,period;
    
    for (p=cmd;;p=q+1) {
        for (q=p;;q++) if (*q=='\r'||*q=='\n'||*q=='\0') break;
        n=(int)(q-p); strncpy(msg,p,n); msg[n]='\0';
        
        period=0;
        if ((r=strrchr(msg,'#'))) {
            sscanf(r,"# %d",&period);
            *r='\0';
            while (*--r==' ') *r='\0'; /* delete tail spaces */
        }
        if (period<=0) period=1000;
        if (*msg&&cycle%period==0) {
            strsendcmd(stream,msg);
        }
        if (!*q) break;
	}
}

/** 
 * write solution header to output stream 
 **/
extern void rtksvr_writesolhead(stream_t *stream, const solopt_t *solopt)
{
    trace(4, "rtksvr_writesolhead: \n");
    uint8_t buff[1024];
    int n;
    
    n=outsolheads(buff,solopt);
    strwrite(stream,buff,n);
}

/** 
 * write solution to output stream 
 **/
extern void rtksvr_writesol(rtksvr_t *svr, int index)
{
    solopt_t solopt=solopt_default;
    uint8_t buff[MAXSOLMSG+1];
    int i,n;
    
    tracet(4,"rtksvr_writesol: index=%d\n",index);
    
    for (i=0;i<2;i++) {
        
        if (svr->solopt[i].posf==SOLF_STAT) {
            
            /* output solution status */
            rtksvrlock(svr);
            n=rtkoutstat(&svr->rtk,(char *)buff);
            rtksvrunlock(svr);
        }
        else {
            /* output solution */
            n=outsols(buff,&svr->rtk.sol,svr->rtk.rb,svr->solopt+i);
        }
        strwrite(svr->stream+i+3,buff,n);
        
        /* save output buffer */
        rtksvr_saveoutbuf(svr,buff,n,i);
        
        /* output extended solution */
        n=outsolexs(buff,&svr->rtk.sol,svr->rtk.ssat,svr->solopt+i);
        strwrite(svr->stream+i+3,buff,n);
        
        /* save output buffer */
        rtksvr_saveoutbuf(svr,buff,n,i);
    }
    /* output solution to monitor port */
    if (svr->moni) {
        n=outsols(buff,&svr->rtk.sol,svr->rtk.rb,&solopt);
        strwrite(svr->moni,buff,n);
    }
    /* save solution buffer */
    if (svr->nsol<MAXSOLBUF) {
        rtksvrlock(svr);
        svr->solbuf[svr->nsol++]=svr->rtk.sol;
        rtksvrunlock(svr);
    }
}

/** 
 * send nmea request to base/nrtk input stream 
 **/
extern void rtksvr_send_nmea(rtksvr_t *svr, uint32_t *tickreset)
{
    trace(4, "rtksvr_send_nmea: \n");
	sol_t sol_nmea={{0}};
	double vel,bl;
	uint32_t tick=tickget();
	int i;

	if (svr->stream[1].state!=1) return;
	sol_nmea.ns=10; /* Some servers don't like when ns = 0 */

	if (svr->nmeareq==1) { /* lat-lon-hgt mode */
		sol_nmea.stat=SOLQ_SINGLE;
		sol_nmea.time=utc2gpst(timeget());
		matcpy(sol_nmea.rr,svr->nmeapos,3,1);
		strsendnmea(svr->stream+1,&sol_nmea);
	}
	else if (svr->nmeareq==2) { /* single-solution mode */
		if (norm(svr->rtk.sol.rr,3)<=0.0) return;
		sol_nmea.stat=SOLQ_SINGLE;
		sol_nmea.time=utc2gpst(timeget());
		matcpy(sol_nmea.rr,svr->rtk.sol.rr,3,1);
		strsendnmea(svr->stream+1,&sol_nmea);
	}
	else if (svr->nmeareq==3) { /* reset-and-single-sol mode */

		/* send reset command if baseline over threshold */
		bl=baseline_len(&svr->rtk);
		if (bl>=svr->bl_reset&&(int)(tick-*tickreset)>MIN_INT_RESET) {
			strsendcmd(svr->stream+1,svr->cmd_reset);
			
			tracet(2,"send reset: bl=%.3f rr=%.3f %.3f %.3f rb=%.3f %.3f %.3f\n",
				   bl,svr->rtk.sol.rr[0],svr->rtk.sol.rr[1],svr->rtk.sol.rr[2],
				   svr->rtk.rb[0],svr->rtk.rb[1],svr->rtk.rb[2]);
			*tickreset=tick;
		}
		if (norm(svr->rtk.sol.rr,3)<=0.0) return;
		sol_nmea.stat=SOLQ_SINGLE;
		sol_nmea.time=utc2gpst(timeget());
		matcpy(sol_nmea.rr,svr->rtk.sol.rr,3,1);

		/* set predicted position if velocity > 36km/h */
		if ((vel=norm(svr->rtk.sol.rr+3,3))>10.0) {
			for (i=0;i<3;i++) {
				sol_nmea.rr[i]+=svr->rtk.sol.rr[i+3]/vel*svr->bl_reset*0.8;
			}
		}
		strsendnmea(svr->stream+1,&sol_nmea);

		tracet(3,"send nmea: rr=%.3f %.3f %.3f\n",sol_nmea.rr[0],sol_nmea.rr[1],
			   sol_nmea.rr[2]);
	}
}

/** 
 * save output buffer 
 **/
extern void rtksvr_saveoutbuf(rtksvr_t *svr, uint8_t *buff, int n, int index)
{
    rtksvrlock(svr);
    
    n=n<svr->buffsize-svr->nsb[index]?n:svr->buffsize-svr->nsb[index];
    memcpy(svr->sbuf[index]+svr->nsb[index],buff,n);
    svr->nsb[index]+=n;
    
    rtksvrunlock(svr);
}

/** 
 * start rtk server
 * start rtk server thread
 * args   : rtksvr_t *svr    IO rtk server
 *          int     cycle    I  server cycle (ms)
 *          int     buffsize I  input buffer size (bytes)
 *          int     *strs    I  stream types (STR_???)
 *                              types[0]=input stream rover
 *                              types[1]=input stream base station
 *                              types[2]=input stream correction
 *                              types[3]=output stream solution 1
 *                              types[4]=output stream solution 2
 *                              types[5]=log stream rover
 *                              types[6]=log stream base station
 *                              types[7]=log stream correction
 *          char    *paths   I  input stream paths
 *          int     *format  I  input stream formats (STRFMT_???)
 *                              format[0]=input stream rover
 *                              format[1]=input stream base station
 *                              format[2]=input stream correction
 *          int     navsel   I  navigation message select
 *                              (0:rover,1:base,2:ephem,3:all)
 *          char    **cmds   I  input stream start commands
 *                              cmds[0]=input stream rover (NULL: no command)
 *                              cmds[1]=input stream base (NULL: no command)
 *                              cmds[2]=input stream corr (NULL: no command)
 *          char    **cmds_periodic I input stream periodic commands
 *                              cmds[0]=input stream rover (NULL: no command)
 *                              cmds[1]=input stream base (NULL: no command)
 *                              cmds[2]=input stream corr (NULL: no command)
 *          char    **rcvopts I receiver options
 *                              rcvopt[0]=receiver option rover
 *                              rcvopt[1]=receiver option base
 *                              rcvopt[2]=receiver option corr
 *          int     nmeacycle I nmea request cycle (ms) (0:no request)
 *          int     nmeareq  I  nmea request type
 *                              (0:no,1:base pos,2:single sol,3:reset and single)
 *          double *nmeapos  I  transmitted nmea position (ecef) (m)
 *          prcopt_t *prcopt I  rtk processing options
 *          solopt_t *solopt I  solution options
 *                              solopt[0]=solution 1 options
 *                              solopt[1]=solution 2 options
 *          stream_t *moni   I  monitor stream (NULL: not used)
 *          char   *errmsg   O  error message
 * return : status (1:ok 0:error)
 */
extern int rtksvr_rtksvrstart(rtksvr_t *svr, int cycle, int buffsize, int *strs,
                       char **paths, int *formats, int navsel, char **cmds,
                       char **cmds_periodic, char **rcvopts, int nmeacycle,
                       int nmeareq, const double *nmeapos, prcopt_t *prcopt,
                       solopt_t *solopt, stream_t *moni, char *errmsg)
{
    gtime_t time,time0={0};
    int i,j,rw;
    
    tracet(3,"rtksvr_rtksvrstart: cycle=%d buffsize=%d navsel=%d nmeacycle=%d nmeareq=%d\n",
           cycle,buffsize,navsel,nmeacycle,nmeareq);
    
    if (svr->state) {
        sprintf(errmsg,"server already started");
        return 0;
    }
    strinitcom();
    svr->cycle=cycle>1?cycle:1;
    svr->nmeacycle=nmeacycle>1000?nmeacycle:1000;
    svr->nmeareq=nmeareq;
    for (i=0;i<3;i++) svr->nmeapos[i]=nmeapos[i];
    svr->buffsize=buffsize>4096?buffsize:4096;
    for (i=0;i<3;i++) svr->format[i]=formats[i];
    svr->navsel=navsel;
    svr->nsbs=0;
    svr->nsol=0;
    svr->prcout=0;
    rtkfree(&svr->rtk);
    rtkinit(&svr->rtk,prcopt);
    
    if (prcopt->initrst) { /* init averaging pos by restart */
        svr->nave=0;
        for (i=0;i<3;i++) svr->rb_ave[i]=0.0;
    }
    for (i=0;i<3;i++) { /* input/log streams */
        svr->nb[i]=svr->npb[i]=0;
        if (!(svr->buff[i]=(uint8_t *)malloc(buffsize))||
            !(svr->pbuf[i]=(uint8_t *)malloc(buffsize))) {
            tracet(1,"rtksvr_rtksvrstart: malloc error\n");
            sprintf(errmsg,"rtk server malloc error");
            return 0;
        }
        for (j=0;j<10;j++) svr->nmsg[i][j]=0;
        for (j=0;j<MAXOBSBUF;j++) svr->obs[i][j].n=0;
        strcpy(svr->cmds_periodic[i],!cmds_periodic[i]?"":cmds_periodic[i]);
        
        /* initialize receiver raw and rtcm control */
        init_raw(svr->raw+i,formats[i]);
        init_rtcm(svr->rtcm+i);
        
        trace(3,"*** rtksvr_rtksvrstart: set receiver and rtcm option\n");
        /* set receiver and rtcm option */
        strcpy(svr->raw [i].opt,rcvopts[i]);
        strcpy(svr->rtcm[i].opt,rcvopts[i]);
        
        trace(3,"*** rtksvr_rtksvrstart: connect dgps corrections\n");
        /* connect dgps corrections */
        svr->rtcm[i].dgps=svr->nav.dgps;
    }

    trace(3,"*** rtksvr_rtksvrstart: output peek buffer\n");

    for (i=0;i<2;i++) { /* output peek buffer */
        if (!(svr->sbuf[i]=(uint8_t *)malloc(buffsize))) {
            tracet(1,"rtksvr_rtksvrstart: malloc error\n");
            sprintf(errmsg,"rtk server malloc error");
            return 0;
        }
    }

    trace(3,"*** rtksvr_rtksvrstart: set solution options\n");

    /* set solution options */
    for (i=0;i<2;i++) {
        svr->solopt[i]=solopt[i];
    }
    /* set base station position */
    if (prcopt->refpos!=POSOPT_SINGLE) {
        for (i=0;i<6;i++) {
            svr->rtk.rb[i]=i<3?prcopt->rb[i]:0.0;
        }
    }
    /* update navigation data */
    for (i=0;i<MAXSAT*4 ;i++) svr->nav.eph [i].ttr=time0;
    for (i=0;i<NSATGLO*2;i++) svr->nav.geph[i].tof=time0;
    for (i=0;i<NSATSBS*2;i++) svr->nav.seph[i].tof=time0;
    
    /* set monitor stream */
    svr->moni=moni;
    
    trace(3,"*** rtksvr_rtksvrstart: open input streams\n");
    /* open input streams */
    for (i=0;i<8;i++) {
        rw=i<3?STR_MODE_R:STR_MODE_W;
        if (strs[i]!=STR_FILE) rw|=STR_MODE_W;
        if (!stropen(svr->stream+i,strs[i],rw,paths[i])) {
            sprintf(errmsg,"str%d open error path=%s",i+1,paths[i]);
            for (i--;i>=0;i--) strclose(svr->stream+i);
            return 0;
        }
        /* set initial time for rtcm and raw */
        if (i<3) {
            time=utc2gpst(timeget());
            svr->raw [i].time=strs[i]==STR_FILE?strgettime(svr->stream+i):time;
            svr->rtcm[i].time=strs[i]==STR_FILE?strgettime(svr->stream+i):time;
        }
    }

    trace(3,"*** rtksvr_rtksvrstart: sync input streams\n");
    /* sync input streams */
    strsync(svr->stream,svr->stream+1);
    strsync(svr->stream,svr->stream+2);
    
    trace(3,"*** rtksvr_rtksvrstart: write start commands to input streams\n");
    /* write start commands to input streams */
    for (i=0;i<3;i++) {
        if (!cmds[i]) continue;
        strwrite(svr->stream+i,(unsigned char *)"",0); /* for connect */
        sleepms(100);
        strsendcmd(svr->stream+i,cmds[i]);
    }
    trace(3,"*** rtksvr_rtksvrstart: write solution header to solution streams\n");
    /* write solution header to solution streams */
    for (i=3;i<5;i++) {
        rtksvr_writesolhead(svr->stream+i,svr->solopt+i-3);
    }

    trace(3,"*** rtksvr_rtksvrstart: create rtk server thread\n");
    /* create rtk server thread */
#ifdef WIN32
    if (!(svr->thread=CreateThread(NULL,0,rtksvrthread,svr,0,NULL))) {
#else
    if (pthread_create(&svr->thread,NULL,rtksvrthread,svr)) {
#endif
        for (i=0;i<MAXSTRRTK;i++) strclose(svr->stream+i);
        sprintf(errmsg,"thread create error\n");
        return 0;
    }
    
    //! rtksvr_start_rtksvrthread(svr);
    
    trace(3,"*** rtksvr_rtksvrstart: thread created success\n");

    trace(3,"*** rtksvr_rtksvrstart: END\n");
    return 1;
}

/// Initialize port for async communication with flutter from rtk server
/// return true if successful initialize
extern bool rtkrcv_registerSendPort(Dart_Port send_port) {
    trace(3,"rtkrcv_registerSendPort: \n");
    assert(rtkrcv_send_port <= 0);  //! Only once initialized

    if (rtkrcv_send_port > 0) {return false;}

    rtkrcv_send_port = send_port;
    // rtkrcv_port_callback = callback;
    return true;
}