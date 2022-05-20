import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_rtklib_platform_interface.dart';

/// An implementation of [FlutterRtklibPlatform] that uses method channels.
class MethodChannelFlutterRtklib extends FlutterRtklibPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_rtklib');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
