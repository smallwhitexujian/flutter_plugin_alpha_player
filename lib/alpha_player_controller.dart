import 'package:flutter/services.dart';

///建立原生与Flutter的通道，通过_channel向原生发送消息
class AlphaPlayerController {
  //设置methodChannel通道。
  static const MethodChannel _channel =
      MethodChannel("flutter_alpha_player_plugin");

  static Future<Map<dynamic, dynamic>?> playPath(String path) async {
    return _channel.invokeMethod('playPath', {"path": path});
  }

  static Future<Map<dynamic, dynamic>?> playAsset(String asset) {
    return _channel.invokeMethod('playAsset', {"asset": asset});
  }

  static stop() {
    _channel.invokeMethod('stop');
  }
}
