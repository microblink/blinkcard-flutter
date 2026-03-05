#!/bin/bash

appName=sample

# remove any existing code
rm -rf $appName

# create a sample application
flutter create --org com.microblink -a kotlin $appName

# enter into demo project folder
pushd $appName

IS_LOCAL_BUILD=true || exit 1
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

# The BlinkCard SDK uses Kotlin 2.1.0. Replace Kotlin Android plugin version in settings.gradle.kts
sed -i '' 's/id("org.jetbrains.kotlin.android") version "[^"]*" apply false/id("org.jetbrains.kotlin.android") version "2.1.0" apply false/' settings.gradle.kts

# go to flutter root project
popd

# go to the ios project folder
pushd ios

# force minimal iOS version to iOS 16.0 as the BlinkCard SDK requires it
sed -i '' '/<key>MinimumOSVersion<\/key>/{
n
s/<string>12\.0<\/string>/<string>16.0<\/string>/
}' Flutter/AppFrameworkInfo.plist

# Xcode project override
sed -i '' 's/IPHONEOS_DEPLOYMENT_TARGET = [0-9.]*/IPHONEOS_DEPLOYMENT_TARGET = 16.0/' Runner.xcodeproj/project.pbxproj

# xcconfig override
sed -i '' 's/IPHONEOS_DEPLOYMENT_TARGET=[0-9.]*/IPHONEOS_DEPLOYMENT_TARGET=16.0/' Flutter/*.xcconfig

# add the camera and photo usage descriptions into Info.plist as the BlinkCard SDK requires it.
sed -i '' '/<dict>/a\
  <key>NSCameraUsageDescription</key>\
  <string>Enable the camera usage for BlinkCard default UX scanning</string>\
  <key>NSPhotoLibraryUsageDescription</key>\
  <string>Enable photo gallery usage for BlinkCard DirectAPI scanning</string>\
' Runner/Info.plist

# update the config for iOS as the minimum target has been raised
flutter build ios --config-only

# go to flutter root project
popd

# copy the BlinkCard sample app implementation files
cp ../sample_files/main.dart lib/
cp ../sample_files/blinkcard_result_builder.dart lib/

echo ""
echo "Go to Flutter project folder: cd $appName"
echo "To run on Android type: flutter run"
echo "To run on iOS:
1. Open $appName/ios/Runner.xcodeproj
2. Set your development team
3. Press run"
