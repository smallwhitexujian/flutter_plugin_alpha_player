
import 'flutter_alpha_player_plugin_platform_interface.dart';

class FlutterAlphaPlayerPlugin {
  Future<String?> getPlatformVersion() {
    return FlutterAlphaPlayerPluginPlatform.instance.getPlatformVersion();
  }
}
