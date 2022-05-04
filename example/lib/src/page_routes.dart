import 'package:flutter_rtklib_example/src/controllers/settings_controller.dart';
import 'package:flutter_rtklib_example/src/controllers/uart_controller.dart';
import 'package:flutter_rtklib_example/src/pages/settings_page.dart';
import 'package:flutter_rtklib_example/src/pages/uart_connection_page.dart';
import 'package:get/get.dart';

class PageRoutes {
  static const String uartConnector = UartConnectionPage.routeName;
  static List<String> getRoutes() {
    return const [uartConnector];
  }

  static List<GetPage<dynamic>> getPages(
      SettingsController settingsController) {
    return [
      GetPage(
          name: UartConnectionPage.routeName,
          page: () => const UartConnectionPage(),
          bindings: [UartBind()]),
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
