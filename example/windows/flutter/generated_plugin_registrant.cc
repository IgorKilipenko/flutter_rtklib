//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <flutter_libserialport/flutter_libserialport_plugin_c_api.h>
#include <flutter_rtklib/flutter_rtklib_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  FlutterLibserialportPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterLibserialportPluginCApi"));
  FlutterRtklibPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterRtklibPlugin"));
}
