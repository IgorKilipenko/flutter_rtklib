import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_rtklib/flutter_rtklib_method_channel.dart';

void main() {
  MethodChannelFlutterRtklib platform = MethodChannelFlutterRtklib();
  const MethodChannel channel = MethodChannel('flutter_rtklib');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
