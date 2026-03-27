import 'dart:io';

import 'package:blinkcard_flutter/blinkcard_flutter.dart';
import 'package:flutter/material.dart';
import "dart:convert";
import "dart:async";
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:sample/blinkcard_result_builder.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _resultString = "";
  String _firstImageBase64 = "";
  String _secondImageBase64 = "";
  late String blinkCardLicenseKey;

  /// Initialize the BlinkCard plugin
  ///
  /// It will be used both for the default UX scan (performScan method),
  /// and the DirectAPI scan (directApiMultiSideScan and directApiSingleSideScan methods).
  final blinkCardPlugin = BlinkCardFlutter();

  @override
  void initState() {
    /// Add a valid license key, based on the platform
    /// A valid license key can be obtained from the Microblink Developer Hub, here: https://developer.microblink.com
    if (Platform.isAndroid) {
      blinkCardLicenseKey =
          "sRwCABVjb20ubWljcm9ibGluay5zYW1wbGUAbGV5SkRjbVZoZEdWa1QyNGlPakUzTnpJM01USXlOamt4T1RNc0lrTnlaV0YwWldSR2IzSWlPaUprWkdRd05qWmxaaTAxT0RJekxUUXdNRGd0T1RRNE1DMDFORFU0WWpBeFlUVTJZamdpZlE9PdXzP6loVm3KEys/pvWnco8AYZHWjNoSnU0owabUT/XVMbU2VhlvbyDzXfCeW+NkZJA3upTcu73cs/WbPzbsVoD6wjbHbYwP0+3f51CLps32C13bg/h9DS+73OYmTw==";
    } else if (Platform.isIOS) {
      blinkCardLicenseKey =
          "sRwCABVjb20ubWljcm9ibGluay5zYW1wbGUBbGV5SkRjbVZoZEdWa1QyNGlPakUzTnpJM01USXlNemt3T0Rrc0lrTnlaV0YwWldSR2IzSWlPaUprWkdRd05qWmxaaTAxT0RJekxUUXdNRGd0T1RRNE1DMDFORFU0WWpBeFlUVTJZamdpZlE9PXDZkGGlrcyQx8Ic8eGrb7YuRfJYO1Ez+bOLcQtLyQ3HNMc+htny28u5Etjj3BTk2Q39au9g1hJpJQm0J/utSGiRhQT/rVQFdFKU+vS4eUVr2im0FnMtdCS3EVofbA==";
    }

    /// If neccessary, the SDK can be pre-loaded with the neccessary resources before the scanning session starts.
    /// This will decreasing the SDK loading time when starting a scanning session (since the resources will be downloaded and the license verified).
    /// blinkCardPlugin.loadSdk(
    ///  blinkCardSdkSettings: BlinkCardSdkSettings(
    ///    licenseKey: blinkCardLicenseKey,
    ///  ),
    /// );

    super.initState();
  }

  Future<void> performScan() async {
    try {
      /// Set the BlinkCard SDK settings
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
      anonymizationSettings.cardHolderNameAnonymizationMode =
          AnonymizationMode.imageOnly;
      anonymizationSettings.cvvAnonymizationMode = AnonymizationMode.fullResult;
      anonymizationSettings.cardNumberAnonymizationSettings =
          CardNumberAnonymizationSettings(
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

      /// Call the 'performScan' method and handle the results
      /// Check how the results are handled in the blinkcard_result_builder.dart file
      final blinkCardResult = await blinkCardPlugin.performScan(
        blinkCardSdkSettings: sdkSettings,
        blinkCardSessionSettings: sessionSettings,
        scanningUxSettings: scanningUxSettings,
      );

      if (blinkCardResult != null) {
        setState(() {
          _resetImages();
          _resultString = BlinkCardResultBuilder.getCardResultString(
            blinkCardResult,
          );
          _setImages(blinkCardResult);
        });
      }
    } catch (blinkCardScanningError) {
      if (blinkCardScanningError is PlatformException) {
        final errorMessage = blinkCardScanningError.message;
        setState(() {
          _resultString = "BlinkCard scanning error: $errorMessage";
          _resetImages();
        });
      }
    }
  }

  /// BlinkCard scanning with DirectAPI that requires both card images.
  /// Best used for getting the information from both front and backside information from various cards
  Future<void> directApiTwoSidesScan() async {
    try {
      /// Get the first and the second side of the card with the pickMultiImage method
      /// First select the side **where the card number is located** and the then back side of the card.
      final images = await ImagePicker().pickMultiImage();

      /// Convert the first picked image to the Base64 format
      String firstImageBase64 = base64Encode(await images[0].readAsBytes());

      /// Get the second selected image as the back side of the document
      /// Convert the picked image to the Base64 format
      String secondImageBase64 = base64Encode(await images[1].readAsBytes());

      /// Set the BlinkCard SDK settings
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
      anonymizationSettings.cardHolderNameAnonymizationMode =
          AnonymizationMode.imageOnly;
      anonymizationSettings.cvvAnonymizationMode = AnonymizationMode.fullResult;
      anonymizationSettings.cardNumberAnonymizationSettings =
          CardNumberAnonymizationSettings(
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

      /// Call the 'performScan' method and handle the results
      /// Check how the results are handled in the blinkcard_result_builder.dart file
      final blinkCardResult = await blinkCardPlugin.performDirectApiScan(
        blinkCardSdkSettings: sdkSettings,
        blinkCardSessionSettings: sessionSettings,
        firstSideImage: firstImageBase64,
        secondSideImage: secondImageBase64,
      );

      if (blinkCardResult != null) {
        setState(() {
          _resetImages();
          _resultString = BlinkCardResultBuilder.getCardResultString(
            blinkCardResult,
          );
          _setImages(blinkCardResult);
        });
      }
    } catch (directApiError) {
      if (directApiError is PlatformException) {
        setState(() {
          _resultString =
              "BlinkCard DirectAPI error: ${directApiError.message ?? "Unknown error occurred"}";
          _resetImages();
        });
      }
    }
  }

  /// BlinkCard scanning with DirectAPI that requires one card image.
  /// Best used for cards that have all of the information on one side, or if the needed information is on one side
  Future<void> directApiOneSideScan() async {
    try {
      // Pick the image where the card number is located
      final carNumberImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (carNumberImage == null) return;

      // Convert the picked image to base64
      List<int> imageBytes = await carNumberImage.readAsBytes();
      String imageBase64 = base64Encode(imageBytes);

      /// Set the BlinkCard SDK settings
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
      /// Since all of the information is set to `false`
      /// Only one image is required
      final extractionSettings = ExtractionSettings();
      extractionSettings.extractCardholderName = false;
      extractionSettings.extractCvv = true;
      extractionSettings.extractExpiryDate = false;
      extractionSettings.extractIban = false;
      extractionSettings.extractInvalidCardNumber = false;

      /// Create and modify the anonymization settings
      final anonymizationSettings = AnonymizationSettings();
      anonymizationSettings.cardHolderNameAnonymizationMode =
          AnonymizationMode.imageOnly;
      anonymizationSettings.cvvAnonymizationMode = AnonymizationMode.fullResult;
      anonymizationSettings.cardNumberAnonymizationSettings =
          CardNumberAnonymizationSettings(
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

      /// Call the 'performScan' method and handle the results
      /// Check how the results are handled in the blinkcard_result_builder.dart file
      final blinkCardResult = await blinkCardPlugin.performDirectApiScan(
        blinkCardSdkSettings: sdkSettings,
        blinkCardSessionSettings: sessionSettings,
        firstSideImage: imageBase64,
      );

      if (blinkCardResult != null) {
        setState(() {
          _resetImages();
          _resultString = BlinkCardResultBuilder.getCardResultString(
            blinkCardResult,
          );
          _setImages(blinkCardResult);
        });
      }
    } catch (directApiError) {
      if (directApiError is PlatformException) {
        setState(() {
          _resultString =
              "BlinkCard DirectAPI error: ${directApiError.message ?? "Unknown error occurred"}";
          _resetImages();
        });
      }
    }
  }

  Future<void> showAlertDialog(
    BuildContext context,
    String title,
    String message,
  ) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _setImages(BlinkCardScanningResult result) {
    final firstImage = result.firstSideResult?.cardImage?.image;
    if (firstImage != null) {
      _firstImageBase64 = firstImage;
    }
    final secondImage = result.secondSideResult?.cardImage?.image;
    if (secondImage != null) {
      _secondImageBase64 = secondImage;
    }
  }

  void _resetImages() {
    _firstImageBase64 = "";
    _secondImageBase64 = "";
  }

  @override
  Widget build(BuildContext context) {
    Widget fullDocumentFirstImage = Container();
    if (_firstImageBase64 != "") {
      fullDocumentFirstImage = Column(
        children: <Widget>[
          Text("First card image:"),
          Image.memory(
            Base64Decoder().convert(_firstImageBase64),
            height: 180,
            width: 350,
          ),
        ],
      );
    }

    Widget fullDocumentSecondImage = Container();
    if (_secondImageBase64 != "") {
      fullDocumentSecondImage = Column(
        children: <Widget>[
          Text("Second card image:"),
          Image.memory(
            Base64Decoder().convert(_secondImageBase64),
            height: 180,
            width: 350,
          ),
        ],
      );
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("BlinkCard Sample")),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Builder(
            builder: (BuildContext context) {
              return Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: ElevatedButton(
                      onPressed: () => performScan(),
                      child: Text("Scan with camera"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        showAlertDialog(
                          context,
                          'DirectAPI TwoSides instructions',
                          'Select two images for processing.\nThe first selected image needs to be side where the card number is located.\nThe second image needs to be the other side of the card.',
                        ).then((_) {
                          directApiTwoSidesScan();
                        });
                      },
                      child: Text("DirectAPI two side scan"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        showAlertDialog(
                          context,
                          'DirectAPI OneSide instructions',
                          'Select one image for processing.\nThe image needs to be side of the card where the card number is located.',
                        ).then((_) {
                          directApiOneSideScan();
                        });
                      },
                      child: Text("DirectAPI one side scan"),
                    ),
                  ),
                  Text(_resultString),
                  fullDocumentFirstImage,
                  fullDocumentSecondImage,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
