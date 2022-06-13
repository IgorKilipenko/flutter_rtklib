#include "ffi_ports.hpp"

void PendingFfiCall::PostAndWait(Dart_Port port, Dart_CObject *object)
{
    std::unique_lock<std::mutex> _lock(mutex);
    const bool success = Dart_PostCObject_DL(_send_port, object);
    if (!success)
        FATAL("Failed to send message, invalid port or isolate died");

    trace(3, "PendingFfiCall (PostAndWait):  Waiting for result.\n");
    while (!notified)
    {
        cv.wait(_lock);
    }
}

intptr_t PendingFfiCall::SendRequest(const char* method_name, uint8_t callback_flag, bool with_thread_block ) {

    trace(3, "PendingFfiCall (SendRequest): method name: %s callback_flag: %d\n", method_name, callback_flag);

    size_t request_length = sizeof(uint8_t) * 1;
    void* request_buffer = malloc(request_length);      // FreeFinalizer.
    reinterpret_cast<uint8_t*>(request_buffer)[0] = callback_flag;  // Populate buffer.

    Dart_CObject c_send_port;
    c_send_port.type = Dart_CObject_kSendPort;
    c_send_port.value.as_send_port.id = port();
    c_send_port.value.as_send_port.origin_id = ILLEGAL_PORT;

    Dart_CObject c_pending_call;
    c_pending_call.type = Dart_CObject_kInt64;
    c_pending_call.value.as_int64 = reinterpret_cast<int64_t>(this);

    Dart_CObject c_method_name;
    c_method_name.type = Dart_CObject_kString;
    c_method_name.value.as_string = const_cast<char*>(method_name);

    Dart_CObject c_request_data;
    c_request_data.type = Dart_CObject_kExternalTypedData;
    c_request_data.value.as_external_typed_data.type = Dart_TypedData_kUint8;
    c_request_data.value.as_external_typed_data.length = request_length;
    c_request_data.value.as_external_typed_data.data =
        static_cast<uint8_t*>(request_buffer);
    c_request_data.value.as_external_typed_data.peer = request_buffer;
    c_request_data.value.as_external_typed_data.callback = FreeFinalizer;

    Dart_CObject* c_request_arr[] = {&c_send_port, &c_pending_call,
                                    &c_method_name, &c_request_data};
    Dart_CObject c_request;
    c_request.type = Dart_CObject_kArray;
    c_request.value.as_array.values = c_request_arr;
    c_request.value.as_array.length =
        sizeof(c_request_arr) / sizeof(c_request_arr[0]);

    /*printf("C   :  Dart_PostCObject_(request: %" Px ", call: %" Px ").\n",
            reinterpret_cast<intptr_t>(&c_request),
            reinterpret_cast<intptr_t>(&c_pending_call));*/
    if (with_thread_block) {
        PostAndWait(_send_port, &c_request);
    
        printf("C   :  Received result.\n");

        const intptr_t result = reinterpret_cast<uint8_t*>(_response_buffer)[0];
        free(_response_buffer);

        return result;
    } else {
        const bool success = Dart_PostCObject_DL(_send_port, &c_request);
        if (!success)
            FATAL("Failed to send message, invalid port or isolate died");
    }
    return 0;
}