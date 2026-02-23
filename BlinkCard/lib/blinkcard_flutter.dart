
import 'blinkcard_flutter_platform_interface.dart';

class BlinkcardFlutter {
  Future<String?> getPlatformVersion() {
    return BlinkcardFlutterPlatform.instance.getPlatformVersion();
  }
}
