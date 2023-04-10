import 'package:flutter/services.dart';

///建立原生与Flutter的通道，通过_channel向原生发送消息
class AlphaPlayerController {
  //设置methodChannel通道。
  static const MethodChannel _channel =
      MethodChannel("flutter_alpha_player_plugin");

  ///向原生发送带参数的并且调用方法
  ///[path] 文件存放路径
  ///[fileName] 路径下面的源文件
  ///[isLooping] 是否循环
  static Future<Map<dynamic, dynamic>?> play(String path, String fileName,
      {bool isLooping = false}) async {
    return _channel.invokeMethod('play', {
      "path":
          "/data/user/0/com.example.flutter_alpha_player_plugin_example/files/",
      "name": "demo_play.mp4",
      "looping": isLooping
    });
  }

  // static stop() {
  //   _channel.invokeMethod('stop');
  // }
}
