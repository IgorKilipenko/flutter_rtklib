#include "rtklib_api.h"

extern char* obs2str(const obsd_t *obs, size_t * strLen) {
    char str[64],id[16];
    int i;
    const char * format = "%s %-3s rcv%d %13.3f %13.3f %13.3f %13.3f %d %d %d %d %x %x %3.1f %3.1f";

    time2str(obs->time,str,3);
    satno2id(obs->sat,id);
    int len = snprintf(NULL, 0, format, 
        str,id,obs->rcv,obs->L[0],obs->L[1],obs->P[0],
        obs->P[1],obs->LLI[0],obs->LLI[1],obs->code[0],
        obs->code[1],obs->Lstd[0],obs->Pstd[0],obs->SNR[0]*SNR_UNIT,obs->SNR[1]*SNR_UNIT);

    char * outStr = (char *)calloc(len, sizeof(char *));

    *strLen = snprintf(outStr, len, format, 
        str,id,obs->rcv,obs->L[0],obs->L[1],obs->P[0],
        obs->P[1],obs->LLI[0],obs->LLI[1],obs->code[0],
        obs->code[1],obs->Lstd[0],obs->Pstd[0],obs->SNR[0]*SNR_UNIT,obs->SNR[1]*SNR_UNIT);

    return outStr;
}

extern size_t obs2str2(const obsd_t *obs, char ** outStr) {
    char str[64],id[16];
    int i;
    const char * format = "%s %-3s rcv%d %13.3f %13.3f %13.3f %13.3f %d %d %d %d %x %x %3.1f %3.1f";

    time2str(obs->time,str,3);
    satno2id(obs->sat,id);
    int len = snprintf(NULL, 0, format, 
        str,id,obs->rcv,obs->L[0],obs->L[1],obs->P[0],
        obs->P[1],obs->LLI[0],obs->LLI[1],obs->code[0],
        obs->code[1],obs->Lstd[0],obs->Pstd[0],obs->SNR[0]*SNR_UNIT,obs->SNR[1]*SNR_UNIT);

    *outStr = (char *)calloc(len, sizeof(char *));

    const size_t strLen = snprintf(*outStr, len, format, 
        str,id,obs->rcv,obs->L[0],obs->L[1],obs->P[0],
        obs->P[1],obs->LLI[0],obs->LLI[1],obs->code[0],
        obs->code[1],obs->Lstd[0],obs->Pstd[0],obs->SNR[0]*SNR_UNIT,obs->SNR[1]*SNR_UNIT);

    return strLen;
}

extern raw_t * create_raw(int format, uint32_t* status) {
    
    raw_t *raw;

    flutter_printf("Start create_raw");
    trace(3, "size gtime_t: %d", sizeof(gtime_t));
    trace(3, "size raw_t: %d", sizeof(raw_t));
    
    if (!(raw = (raw_t *)calloc(1, sizeof(raw_t)))) {
        free_raw(raw);
		*status = 0;
        return NULL;
    }
  
    *status = init_raw(raw, format);
    return raw;
}

extern int init_raw_2(raw_t **raw, int format) {
    
    raw_t *result;
    
    *raw = NULL;
    
    if (!(result = (raw_t *)malloc(sizeof(raw_t)))) {
        free_raw(result);
		return 0;
    }

	memset(result, 0, sizeof(raw_t));
    result->icpc = 1515.255;
	*raw = result;
    
    return 98;
    
    //return init_raw(*raw, format);
}
