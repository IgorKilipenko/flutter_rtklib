import 'package:flutter/material.dart';
import 'package:flutter_rtklib_example/src/app.dart';
import 'package:flutter_rtklib_example/src/controllers/settings_controller.dart';
import 'package:flutter_rtklib_example/src/pages/ublox_page.dart';
import 'package:flutter_rtklib_example/src/settings/settings_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  //LiveTestWidgetsFlutterBinding.ensureInitialized();
  
  testWidgets('Verify UbloxPage', (WidgetTester tester) async {
    //debugDefaultTargetPlatformOverride = TargetPlatform.windows;
    final settingsController = SettingsController(SettingsService());
    await settingsController.loadSettings();

    await tester.pumpWidget(App(settingsController: settingsController));
    await tester.pumpAndSettle();

    expect(
      find.byWidgetPredicate(
        (Widget widget) =>
            widget is UbloxPage,
      ),
      findsOneWidget,
    );

  });
}
