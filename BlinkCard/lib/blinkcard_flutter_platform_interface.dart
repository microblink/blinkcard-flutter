import 'package:blinkcard_flutter/blinkcard_result.dart';
import 'package:blinkcard_flutter/blinkcard_settings.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'blinkcard_flutter_method_channel.dart';

abstract class BlinkCardFlutterPlatform extends PlatformInterface {
  /// Constructs a BlinkCardFlutterPlatform.
  BlinkCardFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static BlinkCardFlutterPlatform _instance = MethodChannelBlinkCardFlutter();

  /// The default instance of [BlinkCardFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelBlinkCardFlutter].
  static BlinkCardFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BlinkcardFlutterPlatform] when
  /// they register themselves.
  static set instance(BlinkCardFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Returns the `performScan` method from the [MethodChannelBlinkCardFlutter].
  /// It takes the following parameters: [BlinkCardSdkSettings], and the optional [SessionSettings] and [ScanningUxSettings].
  /// See [MethodChannelBlinkCardFlutter] for more detailed information.
  Future<BlinkCardScanningResult?> performScan({
    required BlinkCardSdkSettings blinkCardSdkSettings,
    required BlinkCardSessionSettings blinkCardSessionSettings,
    ScanningUxSettings? scanningUxSettings,
  }) {
    return instance.performScan(
      blinkCardSdkSettings: blinkCardSdkSettings,
      blinkCardSessionSettings: blinkCardSessionSettings,
      scanningUxSettings: scanningUxSettings,
    );
  }

  /// Returns the `performDirectApiScan` method from the [MethodChannelBlinkCardFlutter].
  /// It takes the following parameters: [BlinkCardSdkSettings], [SessionSettings], `firstSideImage` [String] in the Base64 format
  /// and the optional `secondSideImage` [String] in the Base64 format.
  /// See [MethodChannelBlinkCardFlutter] for more detailed information.
  Future<BlinkCardScanningResult?> performDirectApiScan({
    required BlinkCardSdkSettings blinkCardSdkSettings,
    required BlinkCardSessionSettings blinkCardSessionSettings,
    required String firstSideImage,
    String? secondSideImage,
  }) {
    return instance.performDirectApiScan(
      blinkCardSdkSettings: blinkCardSdkSettings,
      blinkCardSessionSettings: blinkCardSessionSettings,
      firstSideImage: firstSideImage,
      secondSideImage: secondSideImage,
    );
  }

  /// Returns the `loadSdk` method from the [MethodChannelBlinkCardFlutter].
  /// It takes the following parameter: [BlinkCardSdkSettings]
  /// See [MethodChannelBlinkCardFlutter] for more detailed information.
  Future<void> loadSdk({required BlinkCardSdkSettings blinkCardSdkSettings}) {
    return instance.loadSdk(blinkCardSdkSettings: blinkCardSdkSettings);
  }

  /// Returns the `unloadSdk` method from the [MethodChannelBlinkCardFlutter].
  /// It takes the following parameter: [BlinkCardSdkSettings]
  /// See [MethodChannelBlinkCardFlutter] for more detailed information.
  Future<void> unloadSdk({bool deleteCachedResources = false}) {
    return instance.unloadSdk(deleteCachedResources: deleteCachedResources);
  }
}
