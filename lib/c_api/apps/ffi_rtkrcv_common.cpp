#include "ffi_rtkrcv.hpp"
#include <thread>

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
static int rtksvrthread(rtksvr_t *svr)
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
    
    svr->state=1; obs.data=data;
    svr->tick=tickget();
    ticknmea=tick1hz=svr->tick-1000;
    tickreset=svr->tick-MIN_INT_RESET;
    
    for (cycle=0;svr->state;cycle++) {
        tick=tickget();
        for (i=0;i<3;i++) {
            p=svr->buff[i]+svr->nb[i]; q=svr->buff[i]+svr->buffsize;
            
            /* read receiver raw/rtcm data from input stream */
            if ((n=strread(svr->stream+i,p,q-p))<=0) {
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
            if (svr->format[i]==STRFMT_SP3||svr->format[i]==STRFMT_RNXCLK) {
                /* decode download file */
                rtkrcv_decodefile(svr,i);
            }
            else {
                /* decode receiver raw/rtcm data */
                fobs[i]=rtkrcv_decoderaw(svr,i);
            }
        }
        /* averaging single base pos */
        if (fobs[1]>0&&svr->rtk.opt.refpos==POSOPT_SINGLE) {
            if ((svr->rtk.opt.maxaveep<=0||svr->nave<svr->rtk.opt.maxaveep)&&
                pntpos(svr->obs[1][0].data,svr->obs[1][0].n,&svr->nav,
                       &svr->rtk.opt,&sol,NULL,NULL,msg)) {
                svr->nave++;
                for (i=0;i<3;i++) {
                    svr->rb_ave[i]+=(sol.rr[i]-svr->rb_ave[i])/svr->nave;
                }
            }
            for (i=0;i<3;i++) svr->rtk.opt.rb[i]=svr->rb_ave[i];
        }
        for (i=0;i<fobs[0];i++) { /* for each rover observation data */
            obs.n=0;
            for (j=0;j<svr->obs[0][i].n&&obs.n<MAXOBS*2;j++) {
                obs.data[obs.n++]=svr->obs[0][i].data[j];
            }
            for (j=0;j<svr->obs[1][0].n&&obs.n<MAXOBS*2;j++) {
                obs.data[obs.n++]=svr->obs[1][0].data[j];
            }
            /* carrier phase bias correction */
            if (!strstr(svr->rtk.opt.pppopt,"-DIS_FCB")) {
                rtkrcv_corr_phase_bias(obs.data,obs.n,&svr->nav);
            }
            /* rtk positioning */
            rtksvrlock(svr);
            rtkpos(&svr->rtk,obs.data,obs.n,&svr->nav);
            rtksvrunlock(svr);
            
            if (svr->rtk.sol.stat!=SOLQ_NONE) {
                
                /* adjust current time */
                tt=(int)(tickget()-tick)/1000.0+DTTOL;
                timeset(gpst2utc(timeadd(svr->rtk.sol.time,tt)));
                
                /* write solution */
                rtkrcv_writesol(svr,i);
            }
            /* if cpu overload, inclement obs outage counter and break */
            if ((int)(tickget()-tick)>=svr->cycle) {
                svr->prcout+=fobs[0]-i-1;
            }
        }
        /* send null solution if no solution (1hz) */
        if (svr->rtk.sol.stat==SOLQ_NONE&&(int)(tick-tick1hz)>=1000) {
            rtkrcv_writesol(svr,0);
            tick1hz=tick;
        }
        /* write periodic command to input stream */
        for (i=0;i<3;i++) {
            rtkrcv_periodic_cmd(cycle*svr->cycle,svr->cmds_periodic[i],svr->stream+i);
        }
        /* send nmea request to base/nrtk input stream */
        if (svr->nmeacycle>0&&(int)(tick-ticknmea)>=svr->nmeacycle) {
            rtkrcv_send_nmea(svr,&tickreset);
            ticknmea=tick;
        }
        if ((cputime=(int)(tickget()-tick))>0) svr->cputime=cputime;
        
        /* sleep until next cycle */
        sleepms(svr->cycle-cputime);
    }
    for (i=0;i<MAXSTRRTK;i++) strclose(svr->stream+i);
    for (i=0;i<3;i++) {
        svr->nb[i]=svr->npb[i]=0;
        free(svr->buff[i]); svr->buff[i]=NULL;
        free(svr->pbuf[i]); svr->pbuf[i]=NULL;
        free_raw (svr->raw +i);
        free_rtcm(svr->rtcm+i);
    }
    for (i=0;i<2;i++) {
        svr->nsb[i]=0;
        free(svr->sbuf[i]); svr->sbuf[i]=NULL;
    }
    return 0;
}

extern void rtkrcv_start_rtksvrthread(rtksvr_t *svr) {
    std::thread thread([](rtksvr_t *svr) {
        rtksvrthread(svr);
    }, svr);
    thread.join();
}

/* decode receiver raw/rtcm data ---------------------------------------------*/
extern int rtkrcv_decoderaw(rtksvr_t *svr, int index)
{
    obs_t *obs;
    nav_t *nav;
    sbsmsg_t *sbsmsg=NULL;
    int i,ret,ephsat,ephset,fobs=0;
    
    tracet(4,"rtkrcv_decoderaw: index=%d\n",index);
    
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
extern void rtkrcv_decodefile(rtksvr_t *svr, int index)
{
    nav_t nav={0};
    char file[1024];
    int nb;
    
    tracet(4,"rtkrcv_decodefile: index=%d\n",index);
    
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
extern void rtkrcv_corr_phase_bias(obsd_t *obs, int n, const nav_t *nav)
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
extern void rtkrcv_periodic_cmd(int cycle, const char *cmd, stream_t *stream)
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
extern void rtkrcv_writesolhead(stream_t *stream, const solopt_t *solopt)
{
    trace(4, "rtkrcv_writesol: \n");
    uint8_t buff[1024];
    int n;
    
    n=outsolheads(buff,solopt);
    strwrite(stream,buff,n);
}

/** 
 * write solution to output stream 
 **/
extern void rtkrcv_writesol(rtksvr_t *svr, int index)
{
    solopt_t solopt=solopt_default;
    uint8_t buff[MAXSOLMSG+1];
    int i,n;
    
    tracet(4,"rtkrcv_writesol: index=%d\n",index);
    
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
        rtkrcv_saveoutbuf(svr,buff,n,i);
        
        /* output extended solution */
        n=outsolexs(buff,&svr->rtk.sol,svr->rtk.ssat,svr->solopt+i);
        strwrite(svr->stream+i+3,buff,n);
        
        /* save output buffer */
        rtkrcv_saveoutbuf(svr,buff,n,i);
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
extern void rtkrcv_send_nmea(rtksvr_t *svr, uint32_t *tickreset)
{
    trace(4, "rtkrcv_send_nmea: \n");
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
extern void rtkrcv_saveoutbuf(rtksvr_t *svr, uint8_t *buff, int n, int index)
{
    rtksvrlock(svr);
    
    n=n<svr->buffsize-svr->nsb[index]?n:svr->buffsize-svr->nsb[index];
    memcpy(svr->sbuf[index]+svr->nsb[index],buff,n);
    svr->nsb[index]+=n;
    
    rtksvrunlock(svr);
}

/** 
 * read antenna file 
 **/
extern void rtkrcv_readant(prcopt_t *opt, nav_t *nav, filopt_t *filopt )
{
    const pcv_t pcv0={0};
    pcvs_t pcvr={0},pcvs={0};
    pcv_t *pcv;
    gtime_t time=timeget();
    int i;
    
    trace(3,"readant:\n");
    
    opt->pcvr[0]=opt->pcvr[1]=pcv0;
    if (!*filopt->rcvantp) return;
    
    if (readpcv(filopt->rcvantp,&pcvr)) {
        for (i=0;i<2;i++) {
            if (!*opt->anttype[i]) continue;
            if (!(pcv=searchpcv(0,opt->anttype[i],time,&pcvr))) {
                showmsg("no antenna %s in %s",opt->anttype[i],filopt->rcvantp);
                continue;
            }
            opt->pcvr[i]=*pcv;
        }
    }
    else showmsg("antenna file open error %s",filopt->rcvantp);
    
    if (readpcv(filopt->satantp,&pcvs)) {
        for (i=0;i<MAXSAT;i++) {
            if (!(pcv=searchpcv(i+1,"",time,&pcvs))) continue;
            nav->pcvs[i]=*pcv;
        }
    }
    else showmsg("antenna file open error %s",filopt->satantp);
    
    free(pcvr.pcv); free(pcvs.pcv);
}