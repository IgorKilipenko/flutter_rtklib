import 'package:flutter/material.dart';
import 'package:flutter_rtklib_example/src/controllers/settings_controller.dart';

import 'package:get/get.dart';
import 'page_routes.dart';

/// The Widget that configures your application.
class App extends StatelessWidget {
  const App({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,

          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          //! restorationScopeId: 'app',

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData.light().copyWith(
            // textButtonTheme: TextButtonThemeData(style: flatButtonStyle),
            // elevatedButtonTheme:
                // ElevatedButtonThemeData(style: raisedButtonStyle),
            // outlinedButtonTheme:
                // OutlinedButtonThemeData(style: outlineButtonStyle),
          ),
          darkTheme: ThemeData.dark().copyWith(), //ThemeData.from(colorScheme: const ColorScheme.dark()),
          themeMode: settingsController.themeMode,

          initialRoute: PageRoutes.ubloxRoute,
          getPages: PageRoutes.getPages(settingsController),
        );
      },
    );
  }
}
