import 'package:blinkcard_flutter/blinkcard_flutter.dart';
import 'package:flutter/material.dart';
import "dart:convert";
import "dart:async";
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:sample/blinkcard_result_builder.dart';
import 'package:sample/license_settings_panel.dart';
import 'package:sample/module_settings_panel.dart';
import 'package:sample/optional_scan_settings_panel.dart';
import 'package:sample/sample_license_config.dart';
import 'package:sample/scanning_settings_config.dart';
import 'package:sample/sdk_lifecycle_panel.dart';

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

  final blinkCardPlugin = BlinkCardFlutter();
  final _scanConfig = ScanningSettingsConfig();
  final _licenseConfig = SampleLicenseConfig();

  /// License key used for the last SDK initialization (after unload/prepare).
  String? _lastInitializedLicenseKey;

  bool _scanInProgress = false;
  bool _sdkLifecycleInProgress = false;
  bool _deleteCachedResourcesOnUnload = false;

  bool get _sdkActionsEnabled => !_scanInProgress && !_sdkLifecycleInProgress;

  BlinkCardSdkSettings _buildSdkSettings() {
    final sdkSettings = BlinkCardSdkSettings(
      licenseKey: _licenseConfig.trimmedActiveLicenseKey,
    );
    sdkSettings.downloadResources = true;
    return sdkSettings;
  }

  ScanningUxSettings _buildUxSettings() {
    final scanningUxSettings = ScanningUxSettings();
    scanningUxSettings.showHelpButton = true;
    scanningUxSettings.showIntroductionAlert = false;
    scanningUxSettings.preferredCameraPosition = CameraPosition.back;
    scanningUxSettings.allowHapticFeedback = true;
    return scanningUxSettings;
  }

  void _logScanConfiguration(String action) {
    final sessionSettings = _scanConfig.buildSessionSettings();
    debugPrint('[BlinkCardSample] $action');
    debugPrint(
      '[BlinkCardSample] license (${_licenseConfig.activePlatformName}): '
      '${_licenseConfig.activeLicenseKeyLogLabel()}',
    );
    debugPrint(
      '[BlinkCardSample] redactionSettingsEnabled: '
      '${_scanConfig.redactionSettingsEnabled}',
    );
    debugPrint(
      '[BlinkCardSample] redactionSettings: '
      '${_scanConfig.toRedactionSettings() != null ? jsonEncode(_scanConfig.toRedactionSettings()!.toJson()) : 'null'}',
    );
    debugPrint(
      '[BlinkCardSample] full sessionSettings JSON: '
      '${jsonEncode(sessionSettings.toJson())}',
    );
  }

  Future<bool> _syncSdkForCurrentLicense() async {
    if (!_licenseConfig.hasValidActiveLicenseKey) {
      setState(() {
        _resultString = 'License key is required.';
        _resetImages();
      });
      return false;
    }

    final licenseKey = _licenseConfig.trimmedActiveLicenseKey;
    if (_lastInitializedLicenseKey != null &&
        _lastInitializedLicenseKey != licenseKey) {
      try {
        await blinkCardPlugin.unloadSdk();
      } catch (error) {
        debugPrint('[BlinkCardSample] unloadSdk before license change: $error');
      }
    }

    _lastInitializedLicenseKey = licenseKey;
    return true;
  }

  Future<void> loadSdkManually() async {
    if (!_sdkActionsEnabled) return;
    if (!await _syncSdkForCurrentLicense()) return;

    setState(() => _sdkLifecycleInProgress = true);
    try {
      await blinkCardPlugin.loadSdk(blinkCardSdkSettings: _buildSdkSettings());
      if (!mounted) return;
      setState(() {
        _resultString = 'SDK loaded successfully.';
      });
    } catch (error) {
      _lastInitializedLicenseKey = null;
      if (!mounted) return;
      setState(() {
        if (error is PlatformException) {
          _resultString = 'Load SDK error: ${error.message}';
        } else {
          _resultString = 'Load SDK error: $error';
        }
      });
    } finally {
      if (mounted) {
        setState(() => _sdkLifecycleInProgress = false);
      }
    }
  }

  Future<void> unloadSdkManually() async {
    if (!_sdkActionsEnabled) return;

    setState(() => _sdkLifecycleInProgress = true);
    try {
      await blinkCardPlugin.unloadSdk(
        deleteCachedResources: _deleteCachedResourcesOnUnload,
      );
      _lastInitializedLicenseKey = null;
      if (!mounted) return;
      setState(() {
        _resultString = _deleteCachedResourcesOnUnload
            ? 'SDK unloaded (cached resources deleted).'
            : 'SDK unloaded.';
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        if (error is PlatformException) {
          _resultString = 'Unload SDK error: ${error.message}';
        } else {
          _resultString = 'Unload SDK error: $error';
        }
      });
    } finally {
      if (mounted) {
        setState(() => _sdkLifecycleInProgress = false);
      }
    }
  }

  Future<void> _runScan(Future<void> Function() scanAction) async {
    if (_scanInProgress) return;
    setState(() => _scanInProgress = true);
    try {
      if (!await _syncSdkForCurrentLicense()) return;
      await scanAction();
    } finally {
      if (mounted) {
        setState(() => _scanInProgress = false);
      }
    }
  }

  Future<void> performScan() async {
    await _runScan(() async {
      try {
        _logScanConfiguration('Scan with camera');
        final blinkCardResult = await blinkCardPlugin.performScan(
          blinkCardSdkSettings: _buildSdkSettings(),
          blinkCardSessionSettings: _scanConfig.buildSessionSettings(),
          scanningUxSettings: _buildUxSettings(),
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
    });
  }

  Future<void> directApiTwoSidesScan() async {
    await _runScan(() async {
      try {
        final images = await ImagePicker().pickMultiImage();
        if (images.length < 2) return;

        String firstImageBase64 = base64Encode(await images[0].readAsBytes());
        String secondImageBase64 = base64Encode(await images[1].readAsBytes());

        _logScanConfiguration('DirectAPI two sides');
        final blinkCardResult = await blinkCardPlugin.performDirectApiScan(
          blinkCardSdkSettings: _buildSdkSettings(),
          blinkCardSessionSettings: _scanConfig.buildSessionSettings(),
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
    });
  }

  Future<void> directApiOneSideScan() async {
    await _runScan(() async {
      try {
        final carNumberImage = await ImagePicker().pickImage(
          source: ImageSource.gallery,
        );
        if (carNumberImage == null) return;

        String imageBase64 = base64Encode(await carNumberImage.readAsBytes());

        _logScanConfiguration('DirectAPI one side');
        final blinkCardResult = await blinkCardPlugin.performDirectApiScan(
          blinkCardSdkSettings: _buildSdkSettings(),
          blinkCardSessionSettings: _scanConfig.buildSessionSettings(),
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
    });
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text("BlinkCard Sample")),
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          behavior: HitTestBehavior.translucent,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.all(16.0),
            child: Builder(
              builder: (BuildContext context) {
                return Column(
                  children: <Widget>[
                    LicenseSettingsPanel(
                      config: _licenseConfig,
                      onChanged: () => setState(() {}),
                    ),
                    ModuleSettingsPanel(
                      config: _scanConfig,
                      onChanged: () => setState(() {}),
                    ),
                    OptionalScanSettingsPanel(
                      config: _scanConfig,
                      onChanged: () => setState(() {}),
                    ),
                    SdkLifecyclePanel(
                      deleteCachedResourcesOnUnload:
                          _deleteCachedResourcesOnUnload,
                      onDeleteCachedResourcesOnUnloadChanged: (value) {
                        setState(() => _deleteCachedResourcesOnUnload = value);
                      },
                      onLoadSdk: loadSdkManually,
                      onUnloadSdk: unloadSdkManually,
                      actionsEnabled: _sdkActionsEnabled,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: ElevatedButton(
                        onPressed: _sdkActionsEnabled
                            ? () => performScan()
                            : null,
                        child: Text("Scan with camera"),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: ElevatedButton(
                        onPressed: _sdkActionsEnabled
                            ? () {
                                showAlertDialog(
                                  context,
                                  'DirectAPI TwoSides instructions',
                                  'Select two images for processing.\nThe first selected image needs to be side where the card number is located.\nThe second image needs to be the other side of the card.',
                                ).then((_) {
                                  directApiTwoSidesScan();
                                });
                              }
                            : null,
                        child: Text("DirectAPI two side scan"),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: ElevatedButton(
                        onPressed: _sdkActionsEnabled
                            ? () {
                                showAlertDialog(
                                  context,
                                  'DirectAPI OneSide instructions',
                                  'Select one image for processing.\nThe image needs to be side of the card where the card number is located.',
                                ).then((_) {
                                  directApiOneSideScan();
                                });
                              }
                            : null,
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
      ),
    );
  }
}
