import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_alpha_player_plugin_platform_interface.dart';

/// An implementation of [FlutterAlphaPlayerPluginPlatform] that uses method channels.
class MethodChannelFlutterAlphaPlayerPlugin extends FlutterAlphaPlayerPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_alpha_player_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
