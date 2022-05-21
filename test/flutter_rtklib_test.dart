import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart' as testing;
import 'package:flutter_rtklib/flutter_rtklib.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_rtklib');

  testing.TestWidgetsFlutterBinding.ensureInitialized();

  testing.test('Test ublox', () async {
    final environment = Platform.environment;
    print(environment);
    final executableArguments = Platform.executableArguments;
    final localHostname = Platform.localHostname;
    final packageConfig = Platform.packageConfig;
    final resolvedExecutable = Platform.resolvedExecutable;
    final script = Platform.script.toString();
    final bool isTest = Platform.environment.containsKey("FLUTTER_TEST");
    print(resolvedExecutable);

    UbloxImpl ublox = UbloxImpl();
    testing.expect(ublox, testing.isA<UbloxImpl>());
  });
}
