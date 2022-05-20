import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_rtklib_method_channel.dart';

abstract class FlutterRtklibPlatform extends PlatformInterface {
  /// Constructs a FlutterRtklibPlatform.
  FlutterRtklibPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterRtklibPlatform _instance = MethodChannelFlutterRtklib();

  /// The default instance of [FlutterRtklibPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterRtklib].
  static FlutterRtklibPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterRtklibPlatform] when
  /// they register themselves.
  static set instance(FlutterRtklibPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
