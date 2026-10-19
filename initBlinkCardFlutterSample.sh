#!/bin/bash

appName=sample

# remove any existing code
rm -rf $appName

# create a sample application
flutter create --org com.microblink -a kotlin $appName

# enter into demo project folder
pushd $appName

IS_LOCAL_BUILD=false || exit 1
if [ "$IS_LOCAL_BUILD" = true ]; then
  # add blinkcard_flutter dependency with local path to pubspec.yaml
  perl -i~ -pe "BEGIN{$/ = undef;} s/dependencies:\n  flutter:\n    sdk: flutter/dependencies:\n  flutter:\n    sdk: flutter\n  blinkcard_flutter:\n    path: ..\/BlinkCard\n  image_picker: 1.1.2/" pubspec.yaml
  echo "Using blinkcard_flutter from this repo instead from flutter pub"
else
  # add blinkcard_flutter dependency to pubspec.yaml
  perl -i~ -pe "BEGIN{$/ = undef;} s/dependencies:\n  flutter:\n    sdk: flutter/dependencies:\n  flutter:\n    sdk: flutter\n  blinkcard_flutter:\n  image_picker: 1.1.2/" pubspec.yaml
  echo "Using blinkcard_flutter from pub.dev"
fi

# get and install the dependencies
flutter pub get

# go to the android project folder
pushd android

# The BlinkCard SDK uses minSdk 24. Replace 'minSdk = flutter.minSdkVersion' with 'minSdk = 24' in app/build.gradle.kts
sed -i '' 's/minSdk = flutter\.minSdkVersion/minSdk = 24/' app/build.gradle.kts

# The BlinkCard SDK uses Kotlin 2.2.21. Replace Kotlin Android plugin version in settings.gradle.kts
sed -i '' 's/id("org.jetbrains.kotlin.android") version "[^"]*" apply false/id("org.jetbrains.kotlin.android") version "2.2.21" apply false/' settings.gradle.kts

# go to flutter root project
popd

# go to the ios project folder
pushd ios

# force minimal iOS version to iOS 16.0 as the BlinkCard SDK requires it
if [ -f Flutter/AppFrameworkInfo.plist ]; then
  sed -i '' '/<key>MinimumOSVersion<\/key>/{
n
s/<string>[0-9.]*<\/string>/<string>16.0<\/string>/
}' Flutter/AppFrameworkInfo.plist
fi

# Xcode project override (Runner and any other targets)
sed -i '' 's/IPHONEOS_DEPLOYMENT_TARGET = [0-9.]*/IPHONEOS_DEPLOYMENT_TARGET = 16.0/' Runner.xcodeproj/project.pbxproj

# xcconfig override
if compgen -G "Flutter/*.xcconfig" > /dev/null; then
  sed -i '' 's/IPHONEOS_DEPLOYMENT_TARGET=[0-9.]*/IPHONEOS_DEPLOYMENT_TARGET=16.0/' Flutter/*.xcconfig
fi

# CocoaPods projects (optional; SPM-only Flutter apps may not have a Podfile)
if [ -f Podfile ]; then
  sed -i '' "s/^# platform :ios.*/platform :ios, '16.0'/" Podfile
  sed -i '' "s/^platform :ios.*/platform :ios, '16.0'/" Podfile
fi

# Add camera and photo usage descriptions at the root of Info.plist (app target only).
# Do not match every <dict> — nested UIApplicationSceneManifest dicts must stay unchanged.
perl -i~ -0777 -pe '
  if (!/NSCameraUsageDescription/) {
    s/(<plist version="1.0">\s*<dict>)/$1\n  <key>NSCameraUsageDescription<\/key>\n  <string>Enable the camera usage for BlinkCard default UX scanning<\/string>\n  <key>NSPhotoLibraryUsageDescription<\/key>\n  <string>Enable photo gallery usage for BlinkCard DirectAPI scanning<\/string>/s;
  }
' Runner/Info.plist

# update the config for iOS as the minimum target has been raised
flutter build ios --config-only

# go to flutter root project
popd

# copy the BlinkCard sample app implementation files
cp ../sample_files/sample_license_config.dart lib/
cp ../sample_files/license_settings_panel.dart lib/
cp ../sample_files/sdk_lifecycle_panel.dart lib/
cp ../sample_files/main.dart lib/
cp ../sample_files/blinkcard_result_builder.dart lib/
cp ../sample_files/module_settings_panel.dart lib/
cp ../sample_files/scanning_settings_config.dart lib/
cp ../sample_files/sample_settings_widgets.dart lib/
cp ../sample_files/sample_redaction_options.dart lib/
cp ../sample_files/optional_scan_settings_panel.dart lib/

echo ""
echo "Go to Flutter project folder: cd $appName"
echo "To run on Android type: flutter run"
echo "To run on iOS:
1. Open $appName/ios/Runner.xcodeproj
2. Set your development team
3. Press run"
