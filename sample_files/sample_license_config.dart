import 'dart:io';

/// Sample app license keys for QA (platform-specific).
class SampleLicenseConfig {
  static const defaultAndroidLicenseKey =
      'sRwCABVjb20ubWljcm9ibGluay5zYW1wbGUAbGV5SkRjbVZoZEdWa1QyNGlPakUzTnpJM01USXlOamt4T1RNc0lrTnlaV0YwWldSR2IzSWlPaUprWkdRd05qWmxaaTAxT0RJekxUUXdNRGd0T1RRNE1DMDFORFU0WWpBeFlUVTJZamdpZlE9PdXzP6loVm3KEys/pvWnco8AYZHWjNoSnU0owabUT/XVMbU2VhlvbyDzXfCeW+NkZJA3upTcu73cs/WbPzbsVoD6wjbHbYwP0+3f51CLps32C13bg/h9DS+73OYmTw==';

  static const defaultIosLicenseKey =
      'sRwCABVjb20ubWljcm9ibGluay5zYW1wbGUBbGV5SkRjbVZoZEdWa1QyNGlPakUzTnpJM01USXlNemt3T0Rrc0lrTnlaV0YwWldSR2IzSWlPaUprWkdRd05qWmxaaTAxT0RJekxUUXdNRGd0T1RRNE1DMDFORFU0WWpBeFlUVTJZamdpZlE9PXDZkGGlrcyQx8Ic8eGrb7YuRfJYO1Ez+bOLcQtLyQ3HNMc+htny28u5Etjj3BTk2Q39au9g1hJpJQm0J/utSGiRhQT/rVQFdFKU+vS4eUVr2im0FnMtdCS3EVofbA==';

  String androidLicenseKey = defaultAndroidLicenseKey;
  String iosLicenseKey = defaultIosLicenseKey;

  String get activePlatformName {
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    return 'Unknown';
  }

  String get activeLicenseKey {
    if (Platform.isAndroid) return androidLicenseKey;
    if (Platform.isIOS) return iosLicenseKey;
    return '';
  }

  set activeLicenseKey(String value) {
    if (Platform.isAndroid) {
      androidLicenseKey = value;
    } else if (Platform.isIOS) {
      iosLicenseKey = value;
    }
  }

  String get trimmedActiveLicenseKey => activeLicenseKey.trim();

  bool get hasValidActiveLicenseKey => trimmedActiveLicenseKey.isNotEmpty;

  void resetActivePlatformToDefault() {
    if (Platform.isAndroid) {
      androidLicenseKey = defaultAndroidLicenseKey;
    } else if (Platform.isIOS) {
      iosLicenseKey = defaultIosLicenseKey;
    }
  }

  /// Short prefix for debug logs (do not log full license keys).
  String activeLicenseKeyLogLabel() {
    final key = trimmedActiveLicenseKey;
    if (key.isEmpty) return '(empty)';
    if (key.length <= 12) return '(set)';
    return '${key.substring(0, 8)}…';
  }
}
