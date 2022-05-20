#include "include/flutter_rtklib/flutter_rtklib_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flutter_rtklib_plugin.h"

void FlutterRtklibPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flutter_rtklib::FlutterRtklibPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
