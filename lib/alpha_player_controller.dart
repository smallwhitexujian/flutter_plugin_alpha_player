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
  ///[portraitPath] 竖向，
  ///[landscapePath] 横向，
  ///                  ScaleToFill(0),             //  拉伸铺满全屏
  ///                  ScaleAspectFitCenter(1),    //  等比例缩放对齐全屏，居中，屏幕多余留空
  ///                  ScaleAspectFill(2),         //  等比例缩放铺满全屏，裁剪视频多余部分
  ///                  TopFill(3),                 //  等比例缩放铺满全屏，顶部对齐
  ///                  BottomFill(4),              //  等比例缩放铺满全屏，底部对齐
  ///                  LeftFill(5),                //  等比例缩放铺满全屏，左边对齐
  ///                  RightFill(6),               //  等比例缩放铺满全屏，右边对齐
  ///                  TopFit(7),                  //  等比例缩放至屏幕宽度，顶部对齐，底部留空
  ///                  BottomFit(8),               //  等比例缩放至屏幕宽度，底部对齐，顶部留空
  ///                  LeftFit(9),                 //  等比例缩放至屏幕高度，左边对齐，右边留空
  ///                  RightFit(10);               //  等比例缩放至屏幕高度，右边对齐，左边留空
  static Future<dynamic> playVideo(String path, String fileName,
      {int portraitPath = 2,
      int landscapePath = 8,
      bool isLooping = false}) async {
    _registerPlatformCall();
    return _channel.invokeMethod('playVideo', {
      "path": path,
      "name": fileName,
      "portraitPath": portraitPath,
      "landscapePath": landscapePath,
      "looping": isLooping
    });
  }

  ///播放Asset目录下的视频 iOS 读取assets 目录的方法
  ///[path] 文件存放路径
  ///[fileName] 路径下面的源文件
  ///[isLooping] 是否循环
  static Future<dynamic> playAssetVideo(String path, String fileName,
      {int portraitPath = 2,
      int landscapePath = 8,
      bool isLooping = false}) async {
    _registerPlatformCall();
    return _channel.invokeMethod('playAssetVideo', {
      "path": path,
      "name": fileName,
      "portraitPath": portraitPath,
      "landscapePath": landscapePath,
      "looping": isLooping
    });
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
