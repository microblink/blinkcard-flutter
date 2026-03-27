// ignore_for_file: constant_identifier_names
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:blinkcard_flutter/blinkcard_result.dart';
import 'package:blinkcard_flutter/blinkcard_settings.dart';
import 'blinkcard_flutter_platform_interface.dart';

const ARG_PERFORM_SCAN = "performScan";
const ARG_PERFORM_DIRECT_API_SCAN = "performDirectApiScan";
const ARG_LOAD_SDK = "loadSdk";
const ARG_UNLOAD_SDK = "unloadSdk";

const ARG_BLINKCARD_SDK_SETTINGS = "blinkCardSdkSettings";
const ARG_BLINKCARD_SESSION_SETTINGS = "blinkCardSessionSettings";
const ARG_BLINKCARD_SCANNING_UX_SETTINGS = "scanningUxSettings";
const ARG_DELETE_CACHED_RESOURCES = "deleteCachedResources";
const ARG_FIRST_SIDE_IMAGE = "firstSideImage";
const ARG_SECOND_SIDE_IMAGE = "secondSideImage";

/// An implementation of [BlinkCardFlutterPlatform] that uses method channels.
///
/// MethodChannelCaptureFlutter exposes the appropriate native BlinkCard module as a Flutter/Dart module,
/// based on the detected platform: Android or iOS.
///
/// The method channel contains the methods `performScan` and `performDirectApiScan` which enable the BlinkCard scanning process, with the default UX properties, and with static images.
///
/// The method channel also contains the `loadSdk` and method for loading the BlinkCard SDK before the scanning process to reduce the
/// initilization waiting time
///
/// The method channel contains the `unloadSdk` method for
/// unloading the BlinkCard that can be used for remove the resources connected with the SDK.
class MethodChannelBlinkCardFlutter extends BlinkCardFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('blinkcard_flutter');

  /// The `performScan` platform channel method launches the BlinkCard scanning process with the default UX properties.
  /// It takes the following parameters: [BlinkCardSdkSettings], and the optional [BlinkCardSessionSettings] and [ScanningUxSettings] classes.
  ///
  /// 1. BlinkCard SDK Settings - [BlinkCardSdkSettings]: the class that contains all of the available SDK settings.
  /// It contains settings for the license key, and how the models (that the SDK needs for the scanning process) should be obtained.
  /// To obtain a valid license key, please visit https://developer.microblink.com/ or contact us directly at https://help.microblink.com
  ///
  /// 2. BlinkCard Session Settings - [BlinkCardSessionSettings]: the class that contains specific scanning configurations that define how the scanning session should behave. If not used, the default `SessionSettings` will be applied.
  ///
  /// 3. BlinkCard scanning UX settings class - [ScanningUxSettings] - the class that allows customization of various aspects of the UI & UX
  /// used during the scanning process.
  ///
  @override
  Future<BlinkCardScanningResult?> performScan({
    required BlinkCardSdkSettings? blinkCardSdkSettings,
    required BlinkCardSessionSettings blinkCardSessionSettings,
    ScanningUxSettings? scanningUxSettings,
  }) async {
    final jsonBlinkCardResult = await methodChannel
        .invokeMethod(ARG_PERFORM_SCAN, {
          ARG_BLINKCARD_SDK_SETTINGS: jsonDecode(
            jsonEncode(blinkCardSdkSettings),
          ),
          ARG_BLINKCARD_SESSION_SETTINGS: jsonDecode(
            jsonEncode(blinkCardSessionSettings),
          ),
          ARG_BLINKCARD_SCANNING_UX_SETTINGS: jsonDecode(
            jsonEncode(scanningUxSettings),
          ),
        });
    final decodedNativeBlinkCardResult = Map<String, dynamic>.from(
      jsonDecode(jsonBlinkCardResult),
    );
    return BlinkCardScanningResult(decodedNativeBlinkCardResult);
  }

  /// The `performDirectApiScan` platform channel method launches the BlinkCard scanning process intended for information extraction from static images.
  /// It takes the following parameters: [BlinkCardSdkSettings], [BlinkCardSessionSettings], `firstImage` [String] in the Base64 format and the optional `secondImage` [String] in the Base64 format.
  ///
  /// 1. BlinkCard SDK Settings - [BlinkCardSdkSettings]: the class that contains all of the available SDK settings.
  /// It contains settings for the license key, and how the models (that the SDK needs for the scanning process) should be obtained.
  /// To obtain a valid license key, please visit https://developer.microblink.com/ or contact us directly at https://help.microblink.com
  ///
  /// 2. BlinkCard Session Settings - [BlinkCardSessionSettings]: the class that contains specific scanning configurations that define how the scanning session should behave. If not used, the default `SessionSettings` will be applied.
  ///
  /// 3. The `firstImage` Base64 string - [String]: image that represents one side of the card.
  /// **Should be the image where the card number is located.**
  ///
  /// 4. The optional `secondImage` Base64 string - [String]: needed if the information from other side of the document is required and not all information from the first side of the
  ///
  @override
  Future<BlinkCardScanningResult?> performDirectApiScan({
    required BlinkCardSdkSettings blinkCardSdkSettings,
    required BlinkCardSessionSettings blinkCardSessionSettings,
    required String firstSideImage,
    String? secondSideImage,
  }) async {
    final jsonBlinkCardResult = await methodChannel
        .invokeMethod(ARG_PERFORM_DIRECT_API_SCAN, {
          ARG_BLINKCARD_SDK_SETTINGS: jsonDecode(
            jsonEncode(blinkCardSdkSettings),
          ),
          ARG_BLINKCARD_SESSION_SETTINGS: jsonDecode(
            jsonEncode(blinkCardSessionSettings),
          ),
          ARG_FIRST_SIDE_IMAGE: firstSideImage,
          ARG_SECOND_SIDE_IMAGE: secondSideImage,
        });

    final decodedNativeBlinkCardResult = Map<String, dynamic>.from(
      jsonDecode(jsonBlinkCardResult),
    );
    return BlinkCardScanningResult(decodedNativeBlinkCardResult);
  }

  /// The `loadSdk` platform channel method creates or retrieves the instance of the BlinkCard SDK.
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
  @override
  Future<void> loadSdk({required BlinkCardSdkSettings blinkCardSdkSettings}) {
    return methodChannel.invokeMethod(ARG_LOAD_SDK, {
      ARG_BLINKCARD_SDK_SETTINGS: jsonDecode(jsonEncode(blinkCardSdkSettings)),
    });
  }

  /// The `unloadSdk` platform channel method terminates the BlinkCard SDK and releases all associated resources.
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
  @override
  Future<void> unloadSdk({bool deleteCachedResources = false}) {
    return methodChannel.invokeMethod(ARG_UNLOAD_SDK, {
      ARG_DELETE_CACHED_RESOURCES: deleteCachedResources,
    });
  }
}
