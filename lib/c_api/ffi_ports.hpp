#ifndef FFI_PORTS_H
#define FFI_PORTS_H

#include <stddef.h>
#include <stdlib.h>
#include <sys/types.h>
#include <csignal>

#include "dart_api.h"
#include "dart_native_api.h"
#include "dart_api_dl.h"

#if !defined(FFI_GEN)
#include <thread>
#include <mutex>
#include <condition_variable>

#include "rtklib_api.hpp"

class PendingFfiCall
{
public:
    PendingFfiCall(void **buffer, size_t *length, std::string receive_port_name, Dart_Port send_port)
        : _response_buffer(buffer), _response_length(length), _receive_port_name(receive_port_name), _send_port(send_port)
    {
        _receive_port =
            Dart_NewNativePort_DL(/*"cpp-response"*/ _receive_port_name.c_str(), &PendingFfiCall::HandleResponse,
                                  /*handle_concurrently=*/false);
    }
    ~PendingFfiCall() { Dart_CloseNativePort_DL(_receive_port); }

    Dart_Port port() const { return _receive_port; }
    std::string portName() const { return _receive_port_name; }

    static void HandleResponse(Dart_Port p, Dart_CObject *message)
    {
        if (message->type != Dart_CObject_kArray)
        {
            FATAL("PendingFfiCall (HandleResponse):   Wrong Data: message->type != Dart_CObject_kArray.\n");
        }
        Dart_CObject **c_response_args = message->value.as_array.values;
        Dart_CObject *c_pending_call = c_response_args[0];
        Dart_CObject *c_message = c_response_args[1];
        trace(3, "PendingFfiCall (HandleResponse):   HandleResponse (call: %d"
                 ", message: %d\n",
              reinterpret_cast<intptr_t>(c_pending_call),
              reinterpret_cast<intptr_t>(c_message));

        auto pending_call = reinterpret_cast<PendingFfiCall *>(
            c_pending_call->type == Dart_CObject_kInt64
                ? c_pending_call->value.as_int64
                : c_pending_call->value.as_int32);

        pending_call->ResolveCall(c_message);
    }

    static void FreeFinalizer(void*, void* value) {
        trace(4, "PendingFfiCall (FreeFinalizer):\n");
        free(value);
    }

    void PostAndWait(Dart_Port port, Dart_CObject *object);
    intptr_t SendRequest(const char* method_name, uint8_t callback_flag, bool with_thread_block);

private:
    static bool NonEmptyBuffer(void **value) { return *value != nullptr; }

    void ResolveCall(Dart_CObject *bytes)
    {
        assert(bytes->type == Dart_CObject_kTypedData);
        if (bytes->type != Dart_CObject_kTypedData)
        {
            FATAL("PendingFfiCall (ResolveCall):   Wrong Data: bytes->type != Dart_CObject_kTypedData.\n");
        }
        const intptr_t response_length = bytes->value.as_typed_data.length;
        const uint8_t *response_buffer = bytes->value.as_typed_data.values;
        trace(3, "PendingFfiCall (ResolveCall):    ResolveCall(length: %d, buffer: %d.\n",
              response_length, reinterpret_cast<intptr_t>(response_buffer));

        void *buffer = malloc(response_length);
        memmove(buffer, response_buffer, response_length);

        *_response_buffer = buffer;
        *_response_length = response_length;

        trace(4, "PendingFfiCall (ResolveCall):     Notify result ready.\n");
        notified = true;
        cv.notify_one();
    }

    std::mutex mutex;
    std::condition_variable cv;
    bool notified = false;

    Dart_Port _receive_port;
    void **_response_buffer;
    size_t *_response_length;

    std::string _receive_port_name;
    const Dart_Port _send_port;
};

#endif /* FFI_GEN */

#ifdef __cplusplus
extern "C"
{
#endif

#ifdef __cplusplus
}
#endif

#endif /* FFI_RTKLIB_H */
