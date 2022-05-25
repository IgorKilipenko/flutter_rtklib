import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rtklib/flutter_rtklib.dart';
import 'package:flutter_rtklib_example/src/controllers/ublox_controller.dart';
import 'package:flutter_rtklib_example/src/pages/settings_page.dart';
import 'package:flutter_rtklib_example/src/widgets/app_drawer.dart';
import 'package:get/get.dart';

class UbloxPage extends StatefulWidget {
  static const routeName = '/ublox';

  const UbloxPage({Key? key}) : super(key: key);

  @override
  State<UbloxPage> createState() => _UbloxPageState();
}

class _UbloxPageState extends State<UbloxPage> {
  final UbloxController ubloxController = Get.find();

  @override
  void initState() {
    super.initState();
    ubloxController.testDecodeUbxData();
    print("Decode complete");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Uart connection'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Navigate to the settings page. If the user leaves and returns
                // to the app after it has been killed while running in the
                // background, the navigation stack is restored.
                Navigator.restorablePushNamed(context, SettingsPage.routeName);
              },
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: Center(child: Obx(() {
          return Text('${ubloxController.observations.value ?? "EMPTY"}');
        })));
  }
}
