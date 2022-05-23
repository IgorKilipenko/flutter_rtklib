#ifndef FFI_RTKLIB_H
#define FFI_RTKLIB_H

#include "rtklib.h"
#include "rtklib_api.h"
#include "ffi_convbin.h"

#ifdef __cplusplus
extern "C" {
#endif

#ifdef WIN_DLL
#define EXPORT __declspec(dllexport) // for Windows DLL
#else
#define EXPORT
#endif



#ifdef __cplusplus
}
#endif

#endif /* FFI_RTKLIB_H */
