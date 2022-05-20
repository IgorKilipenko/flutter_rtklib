#ifndef FLUTTER_PLUGIN_FLUTTER_RTKLIB_PLUGIN_H_
#define FLUTTER_PLUGIN_FLUTTER_RTKLIB_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace flutter_rtklib {

class FlutterRtklibPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  FlutterRtklibPlugin();

  virtual ~FlutterRtklibPlugin();

  // Disallow copy and assign.
  FlutterRtklibPlugin(const FlutterRtklibPlugin&) = delete;
  FlutterRtklibPlugin& operator=(const FlutterRtklibPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace flutter_rtklib

#endif  // FLUTTER_PLUGIN_FLUTTER_RTKLIB_PLUGIN_H_
