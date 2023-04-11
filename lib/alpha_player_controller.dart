import 'package:flutter/services.dart';

///建立原生与Flutter的通道，通过_channel向原生发送消息
class AlphaPlayerController {
  ///是否注册过
  static var _isRegister = false;

  //设置methodChannel通道。
  static const MethodChannel _channel =
      MethodChannel("flutter_alpha_player_plugin");

  // ///eventChannel接口回调
  // static const EventChannel _eventChannel =
  //     EventChannel("flutter_alpha_player_plugin_event_channel");

  static EndAction? _endAction;
  static StartAction? _startAction;
  static MonitorCallbacks? _monitorCallbacks;
  static OnVideoSizeChanged? _onVideoSizeChanged;
  static PlatformCallback? _platformCallback;

  ///播放视频
  ///[path] 文件存放路径
  ///[fileName] 路径下面的源文件
  ///[isLooping] 是否循环
  static Future<dynamic> playVideo(String path, String fileName,
      {bool isLooping = false}) async {
    _registerPlatformCall();
    return _channel.invokeMethod(
        'playVideo', {"path": path, "name": fileName, "looping": isLooping});
  }

  ///添加播放视频视图
  static Future<dynamic> attachView() async {
    return _channel.invokeMethod('attachView');
  }

  ///移除视图
  static Future<dynamic> detachView() async {
    return _channel.invokeMethod('detachView');
  }

  ///释放播放器
  static Future<dynamic> releasePlayer() async {
    return _channel.invokeMethod('releasePlayer');
  }

  ///原生接口调用Flutter 注册
  static _registerPlatformCall() {
    if (!_isRegister) {
      _isRegister = true;
      _channel.setMethodCallHandler(_platformCallHandler);
    }
  }

  static Future<dynamic> _platformCallHandler(MethodCall call) async {
    _platformCallback?.call(call.arguments);
    switch (call.method) {
      //播放结束
      case "endAction":
        _endAction?.call();
        break;
      //播放开始
      case "startAction":
        _startAction?.call();
        break;
      //视频变化
      case "onVideoSizeChanged":
        _onVideoSizeChanged?.call(call.arguments);
        break;
      //播放器监听
      case "monitor":
        _monitorCallbacks?.call(call.arguments);
        break;
      default:
        break;
    }
  }

  ///设置播放器回调监听
  static void setAlphaPlayerCallBack(
      {EndAction? endAction,
      StartAction? startAction,
      MonitorCallbacks? monitorCallbacks,
      OnVideoSizeChanged? onVideoSizeChanged,
      PlatformCallback? platformCallback}) {
    _endAction = endAction;
    _startAction = startAction;
    _onVideoSizeChanged = onVideoSizeChanged;
    _monitorCallbacks = monitorCallbacks;
    _platformCallback = platformCallback;
  }
}

///结束监听
typedef EndAction = void Function();

///开始监听器
typedef StartAction = void Function();

///播放器监听
typedef MonitorCallbacks = void Function(dynamic expand);

///视频大小变化监听
typedef OnVideoSizeChanged = void Function(dynamic expand);

typedef PlatformCallback = void Function(dynamic expand);
