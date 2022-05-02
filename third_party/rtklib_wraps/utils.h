#ifndef RTKLIBW_UTILS_H
#define RTKLIBW_UTILS_H

#include "rtklib.h"

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


#endif // RTKLIBW_UTILS_H