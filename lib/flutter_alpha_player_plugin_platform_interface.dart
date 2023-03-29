import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_alpha_player_plugin_method_channel.dart';

abstract class FlutterAlphaPlayerPluginPlatform extends PlatformInterface {
  /// Constructs a FlutterAlphaPlayerPluginPlatform.
  FlutterAlphaPlayerPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterAlphaPlayerPluginPlatform _instance = MethodChannelFlutterAlphaPlayerPlugin();

  /// The default instance of [FlutterAlphaPlayerPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterAlphaPlayerPlugin].
  static FlutterAlphaPlayerPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterAlphaPlayerPluginPlatform] when
  /// they register themselves.
  static set instance(FlutterAlphaPlayerPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
