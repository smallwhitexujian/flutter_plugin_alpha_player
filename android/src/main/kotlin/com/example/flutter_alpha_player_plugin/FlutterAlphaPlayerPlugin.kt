package com.example.flutter_alpha_player_plugin

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterAlphaPlayerPlugin */
class FlutterAlphaPlayerPlugin: FlutterPlugin {

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    //将flutter_alpha_player 注册到Flutterplugin上，并且同步到View上
    flutterPluginBinding.platformViewRegistry.registerViewFactory(
      "flutter_alpha_player",
      NativeAlphaPlayerFactory(flutterPluginBinding.binaryMessenger))
  }
  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
  }
}
