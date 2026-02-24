import 'package:blinkcard_flutter/blinkcard_result.dart';
import 'package:blinkcard_flutter/blinkcard_settings.dart';
import 'blinkcard_flutter_platform_interface.dart';

/// BlinkCardFlutter plugin exposes the appropriate native BlinkCard module as a Flutter/Dart module,
/// based on the detected platform: Android or iOS.
///
/// The BlinkCard plugin contains the the following methods
/// 1. `performScan` - used for card scanning with the default BlinkCard UI/UX.
/// 2. `performDirectApiScan` - used for extracting card from static images.
/// 3. `loadSdk` - used for preloading the BlinkCard SDK, resulting in reducing the initalization time of scanning methods.
/// 4. `unloadSdk` - used for removing BlinkCard SDK resources.
///
class BlinkCardFlutter {
  /// The `loadSdk` method creates or retrieves the instance of the BlinkCard SDK.
  ///
  /// Initializes and loads the BlinkCard SDK if it is not already loaded.
  ///
  /// This method handles:
  /// - SDK initialization
  /// - Resource downloading
  /// - License verification
  ///
  /// It ensures that only one SDK instance exists at any time.
  ///
  /// You can call this method in advance to **preload** the SDK before starting a scanning session.
  /// Doing so reduces loading time for the [`performScan`] and [`performDirectApiScan`] methods,
  /// since all resources will already be available and the license verified.
  ///
  /// If you do not call this method beforehand, it will still be automatically invoked on the native platform channels
  /// when a scan starts. However, the initial scan may take longer due to resource loading and license checks.
  ///
  /// It takes the following parameter: [BlinkCardSdkSettings].
  ///
  /// BlinkCard SDK Settings - [BlinkCardSdkSettings]: the class that contains all of the available SDK settings. It contains settings for the license key, and how the models (that the SDK needs for the scanning process) should be obtained.
  ///
  /// To obtain a valid license key, please visit https://developer.microblink.com/ or contact us directly at https://help.microblink.com
  Future<void> loadSdk({
    required BlinkCardSdkSettings blinkCardSdkSettings,
  }) async {
    return BlinkCardFlutterPlatform.instance.loadSdk(
      blinkCardSdkSettings: blinkCardSdkSettings,
    );
  }

  /// The `unloadSdk` method terminates the BlinkCard SDK and releases all associated resources.
  ///
  /// This method safely shuts down the SDK instance and frees any allocated memory.
  /// After calling this method, you must reinitialize the SDK (by calling [`loadSdk`]
  /// or any of the scanning methods) before using it again.
  ///
  /// The method accepts a single `bool` parameter, [deleteCachedResources].
  ///
  /// If set to `true` (`false` is default), the method performs a **complete cleanup**, including deletion of
  /// all downloaded and cached SDK resources from the device.
  ///
  /// This method is automatically called after each successful scan session.
  Future<void> unloadSdk({bool deleteCachedResources = false}) async {
    return BlinkCardFlutterPlatform.instance.unloadSdk(
      deleteCachedResources: deleteCachedResources,
    );
  }

  /// The `performScan` method launches the BlinkCard scanning process with the default UX properties.
  /// It takes the following parameters: [BlinkCardSdkSettings], and the optional [SessionSettings] and [ScanningUxSettings] classes.
  ///
  /// 1. BlinkCard SDK Settings - [BlinkCardSdkSettings]: the class that contains all of the available SDK settings.
  /// It contains settings for the license key, and how the models (that the SDK needs for the scanning process) should be obtained.
  /// To obtain a valid license key, please visit https://developer.microblink.com/ or contact us directly at https://help.microblink.com
  ///
  /// 2. BlinkCard Session Settings - [SessionSettings]: the class that contains specific scanning configurations that define how the scanning session should behave. If not used, the default `SessionSettings` will be applied.
  ///
  /// 3. BlinkCard scanning UX settings class - [ScanningUxSettings] - the class that allows customization of various aspects of the UI & UX
  /// used during the scanning process.
  ///
  Future<BlinkCardScanningResult?> performScan({
    required BlinkCardSdkSettings blinkCardSdkSettings,
    SessionSettings? sessionSettings,
    ScanningUxSettings? scanningUxSettings,
  }) async {
    return BlinkCardFlutterPlatform.instance.performScan(
      blinkCardSdkSettings: blinkCardSdkSettings,
      sessionSettings: sessionSettings,
      scanningUxSettings: scanningUxSettings,
    );
  }

  /// The `performDirectApiScan` method launches the BlinkCard scanning process intended for information extraction from static images.
  /// It takes the following parameters: [BlinkCardSdkSettings], [SessionSettings], `firstImage` [String] in the Base64 format and the optional `secondImage` [String] in the Base64 format.
  ///
  /// 1. BlinkCard SDK Settings - [BlinkCardSdkSettings]: the class that contains all of the available SDK settings.
  /// It contains settings for the license key, and how the models (that the SDK needs for the scanning process) should be obtained.
  /// To obtain a valid license key, please visit https://developer.microblink.com/ or contact us directly at https://help.microblink.com
  ///
  /// 2. BlinkCard Session Settings - [SessionSettings]: the class that contains specific scanning configurations that define how the scanning session should behave. If not used, the default `SessionSettings` will be applied.
  ///
  /// 3. The `firstImage` Base64 string - [String]: image that represents one side of the card.
  /// **Should be the image where the card number is located.**
  ///
  /// 4. The optional `secondImage` Base64 string - [String]: needed if the information from other side of the document is required and not all information from the first side of the
  ///
  Future<BlinkCardScanningResult?> performDirectApiScan({
    required BlinkCardSdkSettings blinkCardSdkSettings,
    SessionSettings? sessionSettings,
    required String firstSideImage,
    String? secondSideImage,
  }) async {
    return BlinkCardFlutterPlatform.instance.performDirectApiScan(
      blinkCardSdkSettings: blinkCardSdkSettings,
      sessionSettings: sessionSettings,
      firstSideImage: firstSideImage,
      secondSideImage: secondSideImage,
    );
  }
}
