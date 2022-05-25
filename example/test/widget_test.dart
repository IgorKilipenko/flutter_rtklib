// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rtklib_example/src/app.dart';
import 'package:flutter_rtklib_example/src/controllers/settings_controller.dart';
import 'package:flutter_rtklib_example/src/pages/ublox_page.dart';
import 'package:flutter_rtklib_example/src/settings/settings_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  //TestWidgetsFlutterBinding.ensureInitialized();
  /*TestWidgetsFlutterBinding.ensureInitialized(<String, String>{
    'FLUTTER_TEST': 'true',
    'LIBSERIALPORT_PATH': 'test/.libs/',
    'RTKLIB_PATH': 'test/.libs/'
  });*/
  //LiveTestWidgetsFlutterBinding.ensureInitialized();

  //TestWidgetsFlutterBinding.ensureInitialized();
  TestWidgetsFlutterBinding.ensureInitialized();
  //LiveTestWidgetsFlutterBinding.ensureInitialized();
  
  testWidgets('Verify UbloxPage', (WidgetTester tester) async {
    //debugDefaultTargetPlatformOverride = TargetPlatform.windows;
    final settingsController = SettingsController(SettingsService());
    await settingsController.loadSettings();
    // Build our app and trigger a frame.
    await tester.pumpWidget(App(settingsController: settingsController));

    expect(
      find.byWidgetPredicate(
        (Widget widget) =>
            widget is UbloxPage,
      ),
      findsOneWidget,
    );

    // Verify that platform version is retrieved.
    /*
    expect(
      find.byWidgetPredicate(
        (Widget widget) =>
            widget is Text && widget.data!.startsWith('Running on:'),
      ),
      findsOneWidget,
    );
    */
  });
}
