#include "utils.h"

extern struct_sizes_t* getStructSizes() {
    struct_sizes_t *res = (struct_sizes_t*)calloc(1, sizeof(struct_sizes_t));

    res->gtime_t = sizeof(gtime_t);
    res->obsd_t = sizeof(obsd_t);
    res->obs_t = sizeof(obs_t);
    res->erpd_t = sizeof(erpd_t);
    res->erp_t = sizeof(erp_t);
    res->pcv_t = sizeof(pcv_t);
    res->pcvs_t = sizeof(pcvs_t);
    res->alm_t = sizeof(alm_t);
    res->eph_t = sizeof(eph_t);
    res->geph_t = sizeof(geph_t);
    res->peph_t = sizeof(peph_t);
    res->pclk_t = sizeof(pclk_t);
    res->seph_t = sizeof(seph_t);
    res->tled_t = sizeof(tled_t);
    res->tle_t = sizeof(tle_t);
    res->tec_t = sizeof(tec_t);
    res->sbsmsg_t = sizeof(sbsmsg_t);
    res->sbs_t = sizeof(sbs_t);
    res->sbsfcorr_t = sizeof(sbsfcorr_t);
    res->sbslcorr_t = sizeof(sbslcorr_t);
    res->sbssatp_t = sizeof(sbssatp_t);
    res->sbssat_t = sizeof(sbssat_t);
    res->sbsigp_t = sizeof(sbsigp_t);
    res->sbsigpband_t = sizeof(sbsigpband_t);
    res->sbsion_t = sizeof(sbsion_t);
    res->dgps_t = sizeof(dgps_t);
    res->ssr_t = sizeof(ssr_t);
    res->nav_t = sizeof(nav_t);
    res->sta_t = sizeof(sta_t);
    res->sol_t = sizeof(sol_t);
    res->solbuf_t = sizeof(solbuf_t);
    res->solstat_t = sizeof(solstat_t);
    res->solstatbuf_t = sizeof(solstatbuf_t);
    res->rtcm_t = sizeof(rtcm_t);
    res->rnxctr_t = sizeof(rnxctr_t);
    res->url_t = sizeof(url_t);
    res->opt_t = sizeof(opt_t);
    res->snrmask_t = sizeof(snrmask_t);
    res->prcopt_t = sizeof(prcopt_t);
    res->solopt_t = sizeof(solopt_t);
    res->filopt_t = sizeof(filopt_t);
    res->rnxopt_t = sizeof(rnxopt_t);
    res->ssat_t = sizeof(ssat_t);
    res->ambc_t = sizeof(ambc_t);
    res->rtk_t = sizeof(rtk_t);
    res->raw_t = sizeof(raw_t);
    res->stream_t = sizeof(stream_t);
    res->strconv_t = sizeof(strconv_t);
    res->strsvr_t = sizeof(strsvr_t);
    res->rtksvr_t = sizeof(rtksvr_t);
    res->gis_pnt_t = sizeof(gis_pnt_t);
    res->gis_poly_t = sizeof(gis_poly_t);
    res->gis_polygon_t = sizeof(gis_polygon_t);
    res->gisd_t = sizeof(gisd_t);
    res->gis_t = sizeof(gis_t);

    return res;
}
