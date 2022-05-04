import 'package:flutter_rtklib_example/src/controllers/settings_controller.dart';
import 'package:flutter_rtklib_example/src/controllers/uart_controller.dart';
import 'package:flutter_rtklib_example/src/controllers/ublox_controller.dart';
import 'package:flutter_rtklib_example/src/pages/settings_page.dart';
import 'package:flutter_rtklib_example/src/pages/uart_connection_page.dart';
import 'package:flutter_rtklib_example/src/pages/ublox_page.dart';
import 'package:get/get.dart';

class PageRoutes {
  static const String uartConnectorRoute = UartConnectionPage.routeName;
  static const String ubloxRoute = UbloxPage.routeName;

  static List<String> getRoutes() {
    return const [uartConnectorRoute, ubloxRoute];
  }

  static List<GetPage<dynamic>> getPages(
      SettingsController settingsController) {
    return [
      GetPage(
          name: UartConnectionPage.routeName,
          page: () => const UartConnectionPage(),
          bindings: [UartBind()]),
      GetPage(
          name: UbloxPage.routeName,
          page: () => const UbloxPage(),
          bindings: [UbloxBind()]),
      GetPage(
          name: SettingsPage.routeName,
          page: () => SettingsPage(controller: settingsController)),
    ];
  }
}

class UartBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UartController>(() => UartController(), fenix: true);
  }
}

class UbloxBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UbloxController>(() => UbloxController(), fenix: true);
  }
}