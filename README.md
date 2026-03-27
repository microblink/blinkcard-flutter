<p align="center" >
  <img src="https://raw.githubusercontent.com/wiki/BlinkCard/BlinkCard-android/images/logo-microblink.png" alt="Microblink" title="Microblink">
</p>

# _BlinkCard_ Flutter plugin

The BlinkCard SDK is a comprehensive solution for implementing secure card scanning on Flutter. It offers powerful capabilities for capturing and analyzing a wide range of payment cards. The package consists of BlinkCard, which serves as the core module, and the BlinkCardUX package that provides a complete, ready-to-use solution with a user-friendly interface.

**Please note that, for maximum performance and full access to all features, it’s best to go with one of our native SDKs (for [iOS](https://github.com/BlinkCard/blinkcard-ios) or [Android](https://github.com/BlinkCard/blinkcard-android)).**

However, since the wrapper is open source, you can add the features you need on your own.

# Table of contents
- [Licensing](#licensing)
- [Requirements](#requirements)
- [Quickstart with the sample application](#quickstart-with-the-sample-application)
- [Plugin integration](#plugin-integration)
- [Plugin usage](#plugin-usage)
- [Plugin specifics](#plugin-specifics)
  - [Scanning methods](#scanning-methods)
  - [SDK loading & unloading](#sdk-loading--unloading)
  - [BlinkCard Settings](#blinkcard-settings)
  - [BlinkCard Results](#blinkcard-results)
- [pub.dev](#pubdev)
- [Additional information](#additional-information)

## <a name="licensing"></a> Licensing
A valid license key is required to initialize the BlinkCard plugin. A free trial license key can be requested after registering at the [Microblink Developer Hub](https://developer.microblink.com/).

## <a name="requirements"></a> Requirements

| Requirement        | Flutter                | iOS                    | Android                   |
|:------------------:|:----------------------:|:----------------------:|:-------------------------:|
| OS/API version     | Flutter 3.29 and newer  | iOS 16.0 and newer      | API version 24 and newer   |
| Camera quality     | -                       | At least 1080p          | At least 1080p             |


- For additional help with the Flutter setup, view the official [documentation](https://flutter.dev/docs).
- For more detailed information about the BlinkCard Android and iOS requirements, view the native SDK documentation here ([Android](https://github.com/blinkcard/blinkcard-android?tab=readme-ov-file#device-requirements) & [iOS](https://github.com/blinkcard/blinkcard-ios?tab=readme-ov-file#requirements)).


## <a name="quickstart-with-the-sample-application"></a> Quickstart with the sample application
The sample application demonstrates how the BlinkCard plugin is implemented, used and shows how to obtain the scanned results. It contains the implementation for:
1. The **default implementation** with the default BlinkCard UX scanning experience.
2. **Multiside DirectAPI scanning** - extracting the document information from multiple static images (from the gallery).
3. **Singleside DirectAPI scanning** - extracting the document information from a single static images (from the gallery).

To obtain and run the sample application, follow the steps below:
1. Git clone the repository:
```bash
git clone https://github.com/BlinkCard/blinkcard-flutter.git
```
2. Position to the obtained BlinkCard folder and run the `initBlinkCardFlutterSample.sh` script:
```bash
cd blinkCard-flutter && ./initBlinkCardFlutterSample.sh
```
3. After the script finishes running, position to the `sample` folder and run the `flutter run` command:
```bash
cd sample && flutter run
```
4. Pick the platform to run the BlinkCard plugin on.

Note: the plugin can be run directly via Xcode (iOS) and Android Studio (Android):
1. Open the `Runner.xcodeproj` in the path: `sample/ios/Runner.xcodeproj` to run the iOS sample application.
2. Open the `android` folder via Android Studio in the `sample` folder to run the Android sample application.

**Sample app on iOS additional instructions**
- Error: `Module 'blinkcard-flutter' not found`

If you are getting the error above when running the sample application, this usually means that support for Swift Package Manager was not enabled in the Flutter configuration. Simply run the following command to enable it:
```bash
flutter config --enable-swift-package-manager
```
After this, try to run the sample application again.

- Error: `FlutterGeneratedPluginSwiftPackage has a lower minimum deployment target`

To resolve the issue with the minimum deployment target for the `FlutterGeneratedPluginSwiftPackage` package, do the following:
1. Exit Xcode
2. Run the following command:
```bash
flutter build ios --config-only
```
3. Run the sample application

This should properly configure the minimum deployment target of the package.

## <a name="plugin-integration"></a> Plugin integration

1. To add the BlinkCard plugin to a Flutter project, first create empty project if needed:
```bash
flutter create project_name
```
2. Since the native BlinkCard iOS SDK is only distributed via Swift Package Manager, Flutter's Swift Package Manager support also needs to be enabled:
```bash
flutter config --enable-swift-package-manager
```

3. Add the blinkcard_flutter dependency to your `pubspec.yaml` file:
```yaml
dependencies:
  ...
  blinkcard_flutter:
```

4. Run the command to install the dependency:
```bash
flutter pub get
```

## <a name="plugin-usage"></a> Plugin usage
### Minimal plugin example
```dart
/// import the blinkcard_flutter package
import 'package:blinkcard_flutter/blinkcard_flutter.dart';

/// set the license key
late String blinkCardLicenseKey;

if (Platform.isAndroid) {
  blinkCardLicenseKey = "android-license-key";
} else if (Platform.isIOS) {
  blinkCardLicenseKey = "ios-license-key";
}

/// Initialize the plugin
final blinkCardPlugin = BlinkCardFlutter();

/// Add the license key
/// Call the `performScan` method
/// Get the results
Future<void> performScan() async {
  final blinkCardResult = await blinkCardPlugin.performScan(
    blinkCardSdkSettings: BlinkCardSdkSettings(
      licenseKey: "your-license-key",
    ),
    blinkCardSessionSettings: BlinkCardSessionSettings(),
  );

  print(blinkCardResult?.cardholderName);
}
```
### Advanced plugin example

1. After the dependency has been added to the project, first add the necessary import:
```dart
import 'package:blinkcard_flutter/blinkcard_flutter.dart';
```
2. Initialize the BlinkCard plugin:
```dart
final blinkCardPlugin = BlinkCardFlutter();
```
3. Set all of the necessary BlinkCard settings (SDK settings, session settings, and the scanning settings). If the mentioned settings are not modified, the default values will be used:

```dart
// Add the license key for each platform
late String blinkCardLicenseKey;

if (Platform.isAndroid) {
  blinkCardLicenseKey = "android-license-key";
} else if (Platform.isIOS) {
  blinkCardLicenseKey = "ios-license-key";
}

final sdkSettings = BlinkCardSdkSettings(licenseKey: blinkCardLicenseKey);
sdkSettings.downloadResources = true;

/// Create and modify the Session Settings
final sessionSettings = BlinkCardSessionSettings();

/// Create and modify the scanning settings
final scanningSettings = ScanningSettings();
scanningSettings.skipImagesWithBlur = true;
scanningSettings.tiltDetectionLevel = DetectionLevel.mid;

/// Create and modify the liveness settings
final livenessSettings = LivenessSettings();
livenessSettings.enableCardHelpInHandCheck = true;
livenessSettings.photocopyCheckStrictnessLevel = StrictnessLevel.level5;

/// Create and modify the extraction settings
final extractionSettings = ExtractionSettings();
extractionSettings.extractCardholderName = true;
extractionSettings.extractCvv = true;
extractionSettings.extractInvalidCardNumber = false;

/// Create and modify the anonymization settings
final anonymizationSettings = AnonymizationSettings();
anonymizationSettings.cardHolderNameAnonymizationMode = AnonymizationMode.imageOnly;
anonymizationSettings.cvvAnonymizationMode = AnonymizationMode.fullResult;
anonymizationSettings.cardNumberAnonymizationSettings = CardNumberAnonymizationSettings(
  prefixDigitsVisible: 1,
  suffixDigitsVisible: 2,
);

/// Create and modify the cropped image settings
final croppedImageSettings = CroppedImageSettings();
croppedImageSettings.returnCardImage = true;

/// Place the above defined settings in the Scanning settings
scanningSettings.extractionSettings = extractionSettings;
scanningSettings.livenessSettings = livenessSettings;
scanningSettings.anonymizationSettings = anonymizationSettings;
scanningSettings.croppedImageSettings = croppedImageSettings;

/// Place the Scanning settings in the Session settings
sessionSettings.scanningSettings = scanningSettings;

/// Create and modify the UX settings
/// This paramater is optional
final scanningUxSettings = ScanningUxSettings();
scanningUxSettings.showHelpButton = true;
scanningUxSettings.showIntroductionAlert = false;
scanningUxSettings.preferredCameraPosition = CameraPosition.back;
scanningUxSettings.allowHapticFeedback = true;
```

4. Call the appropriate scanning method (with the default UX, or DirectAPI for static images), handle the results and catch any errors:
```dart
// Call the performScan method, where the SDK and session settings need to be passed
// Here, you can also pass the optional ScanningUX object from step 3.
final blinkCardResult = await blinkCardPlugin.performScan(
        blinkCardSdkSettings: sdkSettings,
        blinkCardSessionSettings: sessionSettings,
        scanningUxSettings: scanningUxSettings,
      );
```

- The whole integration process can be found in the sample app `main.dart` file [here](https://github.com/BlinkCard/blinkcard-flutter/blob/main/sample_files/main.dart).
- The settings and the results that can be used with the BlinkCard plugin can be found in the paragraphs below, but also in the comments of each BlinkCard Dart file.

## <a name="plugin-specifics"></a> Plugin specifics
The BlinkCard plugin implementation is located in the `lib` folder, while platform-specific implementation is located in the `android` and `ios` folders.

### <a name="scanning-methods"></a> Scanning methods
Currently, the BlinkCard plugin contains the following methods: `performScan` and `performDirectApiScan`.

**The `performScan` method**

The `performScan` method launches the BlinkCard scanning process with the default UX properties.\
It takes the following parameters: 
1. BlinkCard SDK settings
2. BlinkCard Session settings
3. The optional BlinkCard scanning UX settings

**BlinkCard SDK Settings** - `BlinkCardSdkSettings`: the class that contains all of the available SDK settings. It contains settings for the license key, and how the models (that the SDK needs for the scanning process) should be obtained.

**BlinkCard Session Settings** - `BlinkCardSessionSettings`: the class that contains specific scanning configurations that define how the scanning session should behave.

**BlinkCard Scanning UX settings** - `ScanningUxSettings` - the optional class that allows customization of various aspects of the UI used during the scanning process.

- The implementation of the `performScan` method can be viewed here in the [blinkcard_flutter_method_channel.dart](https://github.com/BlinkCard/blinkcard-flutter/blob/main/BlinkCard/lib/blinkcard_flutter_method_channel.dart) file.

**The `performDirectApiScan` method**

The `performDirectApiScan` method launches the BlinkCard scanning process intended for information extraction from static images.\
It takes the following parameters: 
1. BlinkCard SDK settings
2. BlinkCard Session settings
3. The first side image string in the Base64 format
4. The optional second side image string in the Base64 format

**BlinkCard SDK Settings** - `BlinkCardSdkSettings`: the class that contains all of the available SDK settings. It contains settings for the license key, and how the models (that the SDK needs for the scanning process) should be obtained.

**BlinkCard Session Settings** - `BlinkCardSessionSettings`: the class that contains specific scanning configurations that define how the scanning session should behave.

The first image Base64 string - `String`: image that represents one side of the card. 
- This image must contain the card side where the card number (PAN) is located. 
- If this side of the card contains all of the neccessary information (e.g. CVV, cardholder name) that were set in the `ExtractionSettings`, then no second image is required.

The optional second image Base64 string - `String`: image that represents one side of the card.
- Required only if not all information specified in `ExtractionSettings` can be obtained from the first side of the card.

- The implementation of the `performDirectApiScanning` method can be viewed here in the [blinkcard_flutter_method_channel.dart](https://github.com/BlinkCard/BlinkCard-flutter/blob/main/BlinkCard/lib/blinkCard_flutter_method_channel.dart) file.

### <a name="sdk-loading--unloading"></a> SDK loading & unloading
The BlinkCard SDK also contains methods for loading and unloading. These methods can be called before the scanning methods described above to preload the required resources and reduce the startup time of a scanning session. They can also be used to release resources after the scanning session has finished.

**SDK loading**

The `loadSdk` method creates or retrieves the instance of the BlinkCard SDK. It initializes and loads the BlinkCard SDK if it is not already loaded.

It can be called in advance to **preload** the SDK before starting a scanning session. Doing so reduces loading time for the `performScan` and `performDirectApiScan` methods, since all resources will already be available and the license verified.

If the method is not called beforehand, it will still be automatically invoked on the native platform channels when a scan starts. However, the initial scan may take longer due to resource loading and license checks.

It takes the following parameter: [BlinkCardSdkSettings](#BlinkCard-settings), which is explained in more details below.

**SDK unloading**

The `unloadSdk` platform method terminates the BlinkCard SDK and releases all associated resources. It safely shuts down the SDK instance and frees any allocated memory.
After calling this method, you must reinitialize the SDK (by calling `loadSdk` or any of the scanning methods) before using it again.

It takes the following parameter: `deleteCachedResources`.
- If set to `true` (`false` is default), the method performs a **complete cleanup**, including deletion of all downloaded and cached SDK resources from the device.

This method is automatically called after each successful scan session.

### <a name="BlinkCard-settings"></a> BlinkCard Settings
The BlinkCard SDK contains various settings, modifying different parts of scanning process:
- BlinkCard SDK settings
- BlinkCard Session settings
- Scanning settings
- Liveness settings
- Extraction settings
- Anonymization settings
- Cropped image settings
- Scanning UX settings

1. [BlinkCard SDK settings](https://github.com/BlinkCard/blinkcard-flutter/blob/main/BlinkCard/lib/blinkcard_settings.dart#L6) - `BlinkCardSdkSettings` \
These settings are used for the initialization of the BlinkCard SDK. It contains settings for the license key, and how the models (that the SDK needs for the scanning process) should be obtained.

2. [BlinkCard Session settings](https://github.com/BlinkCard/blinkcard-flutter/main/BlinkCard/lib/blinkCard_settings.dart#L55) - `BlinkCardSessionSettings`\
These settings represent the configuration settings for a scanning session.\
The class that contains specific scanning configurations that define how the scanning session should behave.

3. [Scanning settings](https://github.com/BlinkCard/blinkcard-flutter/blob/main/BlinkCard/lib/blinkcard_settings.dart#L87) - `ScanningSettings`\
These settings represent the configurable settings for scanning a card.\
This class defines various parameters and policies related to the scanning process, including image quality handling, data extraction, anonymization, and liveness detection, along with options for frame processing and image extraction.

4. [Liveness settings](https://github.com/BlinkCard/blinkcard-flutter/blob/main/BlinkCard/lib/blinkcard_settings.dart#L159) - `LivenessSettings`\
Settings for liveness detection during card scanning.\
This class defines various parameters that control the behavior of liveness detection, including thresholds for hand detection, screen and photocopy analysis, and options to skip processing certain frames based on liveness criteria.

5. [Extraction settings](https://github.com/BlinkCard/blinkcard-flutter/blob/main/BlinkCard/lib/blinkcard_settings.dart#L227) - `ExtractionSettings`\
Settings that control which fields and images should be extracted from the payment card.\
Disabling extraction of unused fields can improve recognition performance or reduce memory usage.

6. [Anonymization settings](https://github.com/BlinkCard/blinkcard-flutter/blob/main/BlinkCard/lib/blinkcard_settings.dart#L318) - `AnonymizationSettings`\
Holds the settings which control the anonymization of returned data.

7. [Cropped image settings](https://github.com/BlinkCard/blinkCard-flutter/blob/main/BlinkCard/lib/blinkcard_settings.dart#L336) - `CroppedImageSettings`\
These settings represent the image cropping settings.\
This class controls how card images are cropped, including the resolution, extension of the cropping area, and whether the cropped image should be returned in the results.

8. [Scanning UX settings](https://github.com/BlinkCard/blinkCard-flutter/blob/main/BlinkCard/lib/blinkcard_settings.dart#L359) - `ScanningUxSettings`\
These settings allow customization of various aspects of the UI/UX.
Displaying certain UI elements, haptic feedback, along with choosing the preffered camera position used when capturing document can modified.

**Additional notes:**

- The [blinkcard_settings.dart](https://github.com/BlinkCard/blinkcard-flutter/blob/main/BlinkCard/lib/blinkcard_settings.dart) file contains all the settings that can be modified and explains what each setting does in more detail.

- The native documentation for the above mentioned settings can be found here for [Android](https://blinkcard.github.io/blinkcard-android/blinkcard-core/index.html) & [iOS](https://blinkcard.github.io/blinkcard-swift-package/documentation/blinkcard/).

- The native Kotlin & Swift implementation of all BlinkCard settings can be found here for [Android](https://github.com/blinkcard/blinkcard-flutter/blob/main/BlinkCard/android/src/main/kotlin/com/microblink/blinkcard/flutter/serialization/BlinkCardDeserializationUtils.kt) & [iOS](https://github.com/blinkcard/blinkcard-flutter/blob/main/BlinkCard/ios/blinkcard_flutter/Sources/blinkcard_flutter/Serialization/BlinkCardDeserializationUtils.swift) in the BlinkCard deserialization utilities.

### <a name="BlinkCard-result"></a> BlinkCard Results

The result of the scanning process is stored in the `BlinkCardScanningResult`. It contains the results of scanning a card, including the extracted data, liveness information, and the card images:

1. **Issuing network**- `String`\
Payment card's issuing network.

2. **Card account result** - `List<CardAccountResult>`\
Payment card accounts found on the card.\
A list of payment card accounts found on the card. Each result in the list represents a distinct payment account containing details like the card number, CVV, and expiry date.

3. **IBAN** - `String?`\
The IBAN (International Bank Account Number) of the card, or null if not available.

4. **Cardholder name** - `String?`\
Information about the cardholder name, or null if not available.

5. **Overall card liveness result** - `CheckResult`\
The overall liveness check result for the card.\
This result aggregates the outcomes of various liveness checks performed on the card to determine its authenticity
- Set to `pass` if all individual checks have passed.
- Set to `fail` if any individual check has failed.

**Additional notes:**

- The [blinkCard_result.dart](https://github.com/BlinkCard/blinkCard-flutter/blob/main/BlinkCard/lib/blinkcard_result.dart) file contains all the results that can be obtained and explains what each result represents in more detail.

- The native documentation for the above mentioned results can be found here for [Android](https://github.com/blinkcard/blinkcard-flutter/blob/main/BlinkCard/android/src/main/kotlin/com/microblink/blinkcard/flutter/serialization/BlinkCardSerializationUtils.kt) & [iOS](https://github.com/blinkcard/blinkcard-flutter/blob/main/BlinkCard/ios/blinkcard_flutter/Sources/blinkcard_flutter/Serialization/BlinkCardSerializationUtils.swift).

- The native Kotlin & Swift implementation of all BlinkCard results can be found here for [Android](https://github.com/BlinkCard/BlinkCard-flutter/blob/feature/android-platform-channel/BlinkCard/android/src/main/kotlin/com/microblink/BlinkCard/flutter/BlinkCardSerializationUtils.kt) & [iOS](https://github.com/BlinkCard/BlinkCard-flutter/blob/feature/ios-platform-channel/BlinkCard/ios/BlinkCard_flutter/Sources/BlinkCard_flutter/BlinkCardSerializationUtils.swift) in the BlinkCard serialization utilities.

## <a name="pub-dev"></a> pub.dev
- The BlinkCard Flutter package can also be found on pub.dev [here](https://pub.dev/packages/blinkcard_flutter).
- The package documentation/API references can be viewed [here](https://pub.dev/documentation/blinkcard_flutter/latest/).

## <a name="additional-information"></a> Additional information
For any additional questions and information, feel free to contact us [here](https://help.microblink.com), or directly to the Support team via mail support@microblink.com.
