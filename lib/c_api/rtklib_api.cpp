#include "rtklib_api.hpp"
#include "dart_api.h"
#include "dart_native_api.h"
#include "dart_api_dl.h"
#include <thread>

static std::mutex mutex;

// Initialize `dart_api_dl.h`
extern intptr_t InitDartApiDL(void* data) {
  return Dart_InitializeApiDL(data);
}

extern char* obs2str(const obsd_t *obs, size_t * strLen) {
    char str[64],id[16];
    const char * format = "%s %-3s rcv%d %13.3f %13.3f %13.3f %13.3f %d %d %d %d %x %x %3.1f %3.1f";

    time2str(obs->time,str,3);
    satno2id(obs->sat,id);
    int len = snprintf(NULL, 0, format, 
        str,id,obs->rcv,obs->L[0],obs->L[1],obs->P[0],
        obs->P[1],obs->LLI[0],obs->LLI[1],obs->code[0],
        obs->code[1],obs->Lstd[0],obs->Pstd[0],obs->SNR[0]*SNR_UNIT,obs->SNR[1]*SNR_UNIT);

    char * outStr = (char *)calloc(len+1, sizeof(char *));

    *strLen = snprintf(outStr, len+1, format, 
        str,id,obs->rcv,obs->L[0],obs->L[1],obs->P[0],
        obs->P[1],obs->LLI[0],obs->LLI[1],obs->code[0],
        obs->code[1],obs->Lstd[0],obs->Pstd[0],obs->SNR[0]*SNR_UNIT,obs->SNR[1]*SNR_UNIT);

    return outStr;
}

extern size_t obs2str2(const obsd_t *obs, char ** outStr) {
    char str[64],id[16];
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
        if (raw) free(raw);
        raw = NULL;
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
	*raw = result;
    
    return init_raw(*raw, format);
}

extern void native_free(void *ptr) {
    if (ptr != NULL) free(ptr);
}

extern void Fatal(char const* file, int line, char const* error) {
    trace(1, "FATAL %s:%i\n%s\n", file, line, error);
#if !defined(WIN32) && !defined(ANDROID)
    Dart_DumpNativeStackTrace(NULL);
    Dart_PrepareToAbort();
#endif
    abort();
}

#if !defined(WIN32) && !defined(ANDROID)
extern Dart_Handle GetFlutterRootLibraryUrl() {
    Dart_Handle root_lib = Dart_RootLibrary();
    Dart_Handle lib_url = Dart_LibraryUrl(root_lib);
    assert(!Dart_IsError(lib_url));
    return lib_url;
}
#endif /* !WIN32 */

extern void native_delete_FlutterTraceMessage(FlutterTraceMessage* ptr) {
    if (ptr != NULL) {
        delete ptr;
    }
}
extern void native_deleteArray(void* ptrArr) {
    if (ptrArr != NULL) {
        delete[] ptrArr;
    }
}
extern void native_delete(void* ptr) {
    if (ptr != NULL) {
        delete ptr;
    }
}
extern bool sendMessageToFlutter(Dart_Port send_port, FlutterTraceMessage* message /*, void (*callback)(void*, void*)*/) {
    if (send_port <= 0) return false;
    
    std::lock_guard<std::mutex> guard(mutex);

    Dart_CObject dart_object;
    dart_object.type = Dart_CObject_kNativePointer;
    auto ptr = reinterpret_cast<intptr_t>(&*message);
    dart_object.value.as_native_pointer.ptr = ptr;
    dart_object.value.as_native_pointer.size = sizeof(struct FlutterTraceMessage);
    dart_object.value.as_native_pointer.callback = [](void*, void* value) {

        /*
        * Not worked, see : 
        *   - https://github.com/dart-lang/sdk/issues/47901
        *   - https://github.com/fzyzcjy/flutter_rust_bridge/issues/243
        */
        
        std::cout << "NotifyDart : " << "[ ### ] FreeFinalizer";
        
        if (value != nullptr) {
            auto obj = reinterpret_cast<FlutterTraceMessage*>(value);
            if (obj->message != nullptr) {
                free((char*)(obj->message));
                free(obj);
            }
        }
    };
    
    
    const bool result = Dart_PostCObject_DL(send_port, &dart_object);
    if (!result) {
        FATAL("Posting message to port failed.");
    }
    return result;
}

extern bool sendCommandMessageToFlutter(Dart_Port send_port, const char* command) {
    if (send_port <= 0) return false;

    auto message = new FlutterTraceMessage{
        .message = command,
        .type = 2,
        .level = -1,
        .message_lenght = strlen(command),
    };

    return sendMessageToFlutter(send_port, message);
}