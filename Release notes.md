## 3000.0.0
Version 3000.0.0 of the BlinkCard Flutter SDK.
- Updated to [Android SDK v3000.0.0](https://github.com/microblink/blinkcard-android/releases/tag/v3000.0.0) and [iOS SDK v3000.0.0](https://github.com/microblink/blinkcard-ios/releases/tag/v3000.0.0)

## Breaking changes
- The plugin now requires:
    - iOS version 16.0 and above.
    - Android API version 24 and above.
    - Flutter version 3.29 and above.

**iOS-specific**
- The iOS package is now distribued via Swift Package Manager.
- To enable Swift Package Manager for Flutter, run the following command:
```
flutter config --enable-swift-package-manager
```

**Changes in Dart**
- Class `MicroblinkScanner` has been renamed to `BlinkCardFlutter`.
- Method `scanWithCamera` has been renamed to `performScan`.
- Method `scanWithDirectApi` has been renamed to `performDirectApiScan`.
- Many of the older settings have been renamed to be more intuitive, for more information see the [blinkcard_settings.dart](https://github.com/microblink/blinkcard-flutter/blob/main/BlinkCard/lib/blinkcard_settings.dart) file, and the native documentation for [Android](https://blinkcard.github.io/blinkcard-android/blinkcard-core/index.html) and [iOS](https://blinkcard.github.io/blinkcard-swift-package/documentation/blinkcard).
- See section **Version 3000 plugin usage** for more details about how to use each method, and how to handle the scanned results.
- See section **Implementation guide** for more details about the implementation steps required to integrate the new BlinkCard SDK.

## Version 3000 plugin usage
**Scanning with default BlinkCard UI/UX**

The `performScan` method launches the BlinkCard scanning process with the default UX properties.\
It takes the following parameters: 
1. BlinkCard SDK settings
2. BlinkCard Session settings
3. The optional BlinkCard scanning UX settings

**BlinkCard SDK Settings** - `BlinkCardSdkSettings`: the class that contains all of the available SDK settings. It contains settings for the license key, and how the models (that the SDK needs for the scanning process) should be obtained.

**BlinkCard Session Settings** - `BlinkCardSessionSettings`: the class that contains specific scanning configurations that define how the scanning session should behave.

**BlinkCard Scanning UX settings** - `ScanningUxSettings` - the optional class that allows customization of various aspects of the UI used during the scanning process.

- The implementation of the `performScan` method can be viewed here in the [blinkcard_flutter_method_channel.dart](https://github.com/microblink/blinkcard-flutter/blob/main/BlinkCard/lib/blinkcard_flutter_method_channel.dart) file.

**Scanning information from static images**

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

- The implementation of the `performDirectApiScanning` method can be viewed here in the [blinkcard_flutter_method_channel.dart](https://github.com/microblink/BlinkCard-flutter/blob/main/BlinkCard/lib/blinkcard_flutter_method_channel.dart) file.

**SDK loading and unloading**

The BlinkCard SDK now also contains methods for loading and unloading. These methods can be called before the scanning methods described above to preload the required resources and reduce the startup time of a scanning session. They can also be used to release resources after the scanning session has finished.
- See the [SDK loading & unloading](https://github.com/microblink/blinkcard-flutter?tab=readme-ov-file#sdk-loading--unloading) section in README.md for more information.

**BlinkCard result**

- Both methods return the `BlinkCardScanningResult` object. It contains the results of scanning a card, including the extracted data, liveness information, and the card images:

- All of the available results can be viewed [here](https://github.com/microblink/blinkcard-flutter/blob/main/BlinkCard/lib/blinkcard_result.dart).

**Implementation guide**
- A detailed guide about the integration and usage of the plugin can be viewed [here](https://github.com/microblink/blinkcard-flutter/tree/main?tab=readme-ov-file#plugin-integration).
- The sample application which demonstrates the usage of the SDK can be found in the [main.dart](https://github.com/microblink/blinkcard-flutter/blob/main/sample_files/main.dart) file.

**Documentation**
- The SDK documentation can also be viewed [here](https://pub.dev/documentation/blinkcard_flutter/latest/) on pub.dev.

## 2.12.0
- Updated to [Android SDK v2.12.0](https://github.com/microblink/blinkcard-android/releases/tag/v2.12.0) and [iOS SDK v2.12.0](https://github.com/microblink/blinkcard-ios/releases/tag/v2.12.0)

### Improvements
- Integrated a tilt detector that will improve the quality of captured images and the extracted data
    - Added `tiltDetectionLevel` in `BlinkCardRecognizer`, which defines the level of allowed detected tilt of the document in the image.
    - New UI message `Keep card parallel to phone` when the camera angle is too steep. It is available in the `BlinkCardOverlaySettings`
- Integrated a stability check to ensure consecutive images for extraction are consistent
- Improved accuracy of owner field extraction

### Bug fixes
- Fixed issue with anonymization of vertical cards where in some cases sensitive fields were not anonymized correctly
- Fixed issue with anonymization of cards when document was scanned at a steep angle
- Fixed issue with images when extension are enabled that resulted in an incorrect aspect ratio

## 2.11.1

- Updated to [Android SDK v2.11.1](https://github.com/microblink/blinkcard-android/releases/tag/v2.11.1) and [iOS SDK v2.11.1](https://github.com/microblink/blinkcard-ios/releases/tag/v2.11.1)

### Improvements
- Improved data extraction accuracy across all supported card types

### Behavior Changes
- Improved extraction of the owner field
- Only digits are allowed in card number, CVV, and date of expiry results
- Only letters are allowed in owner field result

### UI changes
- Added success checkmark after a successful first side scan
- Added an error state when scanning the wrong side of the card
    - Added new `scanningWrongSideMessage` property in the `BlinkCardOverlaySettings`.
- Minor changes in scanning instruction messages

### Bug fixes
- Fixed compatibility issues with Flutter v3.29

## 2.10.0

- Updated to [Android SDK v2.10.0](https://github.com/microblink/blinkcard-android/releases/tag/v2.10.0) and [iOS SDK v2.10.0](https://github.com/microblink/blinkcard-ios/releases/tag/v2.10.0)

**Improvements**

- Significant improvements in photocopy detection.
    - Both the False Rejection Rate and False Acceptance Rate are reduced by ~50% as measured on the default match level.

**Bug fixes**

- Android specific:
    - Removed `libc++_shared.so` from the SDK
    - Fix for duplicate attrs resource: `attr/mb_onboardingImageColor` when combining multiple Microblink's SDKs in the same app

## 2.9.3

### Bug fixes

- iOS-specific
  - Revert dependency update for iOS BlinkCard

## 2.9.2

### Bug fixes

- Android-specific
  - We have removed the package attribute from AndroidManifest.xml

## 2.9.1

- Updated the plugin to [Android SDK v2.9.3](https://github.com/microblink/blinkcard-android/releases/tag/v2.9.3) and [iOS SDK v2.9.1](https://github.com/microblink/blinkcard-ios/releases/tag/v2.9.1)
- This version of the SDK contains the native iOS `BlinkCard.xcframework` with the privacy manifest file (`PrivacyInfo.xcprivacy`).

### Major API update

- We have introduced the **DirectAPI** method of scanning, which allows the SDK to extract the card information from static images without the need to use the device’s camera and our UI.
- Usage:
    - The `scanWithDirectApi` method requires four parameters:
    - `collection`, which is a collection of Recognizers used for card scanning.
    - `frontImage`, which would represent the image of the card where the card number in located in the Base64 format string
    - `backImage`,  which would represent the image of the second side of the card in the Base64 format string
        - the `backImage` parameter is optional when scanning the card that contains all of the information on one side (or if you extract specific information located only on one side), and can be passed as `null` or an empty string (`””`). 
    - `license`, the licenses for iOS and Android required to unlock the SDK
- An example of its usage can be found in the [sample application](https://github.com/microblink/blinkcard-flutter/blob/main/sample_files/main.dart) , both for the two-sided and one-sided card scanning. 
- More information about the DirectAPI scanning can be found here in the native documentation for [Android](https://github.com/microblink/blinkcard-android?tab=readme-ov-file#direct-api) and [iOS](https://github.com/microblink/blinkcard-ios?tab=readme-ov-file#direct-api-processing)
- We still recommend using direct camera scanning, as static images can sometimes be in lower-quality which can cause SDK extraction error. It would be best to use the `scanWithDirectApi` method when using the device’s camera is not an option.

## 2.9.0

- Updated to [Android SDK v2.9.0](https://github.com/microblink/blinkcard-android/releases/tag/v2.9.0) and [iOS SDK v2.9.0](https://github.com/microblink/blinkcard-ios/releases/tag/v2.9.0)
- Improved scanning performance and added support for virtually any card layout
- Added new result `documentLivenessCheck` that contains liveness information for the first and second sides of the scanned card.
    - `handPresenceCheck` , `photocopyCheck` and `screenCheck` liveness information can be obtained.
- Added `BlinkCardMatchLevel` for configuring the strictness of the check result for the document liveness properties
- Added `BlinkCardCheckResult` for enumerating document liveness check results
- Added `allowInvalidCardNumber` setting that allows reading invalid card numbers to avoid endless scanning on testing cards.
    - Added `cardNumberValid` flag within the `BlinkCardRecognizer` result to check if the card number is valid.
- Added additional properties to `BlinkCardOverlaySettings` that can be modified.
- Fixed issue with the SDK localization.

**Breaking API changes:**
- Removed `LegacyBlinkCardRecognizer` and `LegacyBlinkCardEliteRecognizer` legacy recognizers.

## 2.6.0

- Updated to [Android SDK v2.6.0](https://github.com/microblink/blinkcard-android/releases/tag/v2.6.0) and [iOS SDK v2.6.0](https://github.com/microblink/blinkcard-ios/releases/tag/v2.6.0)

## 2.4.2

- Hotfix - change channel name

## 2.4.1

- Changed file prefixes to support interoperability with BlinkID.

## 2.4.0

- Updated to [Android SDK v2.4.0](https://github.com/microblink/blinkcard-android/releases/tag/v2.4.0) and [iOS SDK v2.4.0](https://github.com/microblink/blinkcard-ios/releases/tag/v2.4.0)
- Migrated to Null Safety

## 2.3.0

Initial plugin release with [Android SDK v2.3.0](https://github.com/microblink/blinkcard-android/releases/tag/v2.3.0) and [iOS SDK v2.3.0](https://github.com/microblink/blinkcard-ios/releases/tag/v2.3.0)
