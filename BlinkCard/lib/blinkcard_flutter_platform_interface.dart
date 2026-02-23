import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'blinkcard_flutter_method_channel.dart';

abstract class BlinkcardFlutterPlatform extends PlatformInterface {
  /// Constructs a BlinkcardFlutterPlatform.
  BlinkcardFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static BlinkcardFlutterPlatform _instance = MethodChannelBlinkcardFlutter();

  /// The default instance of [BlinkcardFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelBlinkcardFlutter].
  static BlinkcardFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BlinkcardFlutterPlatform] when
  /// they register themselves.
  static set instance(BlinkcardFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
