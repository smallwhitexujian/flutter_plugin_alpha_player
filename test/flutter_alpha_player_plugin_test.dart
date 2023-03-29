import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_alpha_player_plugin/flutter_alpha_player_plugin.dart';
import 'package:flutter_alpha_player_plugin/flutter_alpha_player_plugin_platform_interface.dart';
import 'package:flutter_alpha_player_plugin/flutter_alpha_player_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterAlphaPlayerPluginPlatform
    with MockPlatformInterfaceMixin
    implements FlutterAlphaPlayerPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterAlphaPlayerPluginPlatform initialPlatform = FlutterAlphaPlayerPluginPlatform.instance;

  test('$MethodChannelFlutterAlphaPlayerPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterAlphaPlayerPlugin>());
  });

  test('getPlatformVersion', () async {
    FlutterAlphaPlayerPlugin flutterAlphaPlayerPlugin = FlutterAlphaPlayerPlugin();
    MockFlutterAlphaPlayerPluginPlatform fakePlatform = MockFlutterAlphaPlayerPluginPlatform();
    FlutterAlphaPlayerPluginPlatform.instance = fakePlatform;

    expect(await flutterAlphaPlayerPlugin.getPlatformVersion(), '42');
  });
}
