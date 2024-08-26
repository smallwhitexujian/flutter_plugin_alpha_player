import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alpha_player_plugin/alpha_player_controller.dart';
import 'package:flutter_alpha_player_plugin/alpha_player_view.dart';

import 'package:oktoast/oktoast.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> downloadPathList = [];
  bool isDownload = false;

  @override
  void initState() {
    super.initState();
    AlphaPlayerController.setAlphaPlayerCallBack(
      endAction: () {},
      startAction: () {},
      monitorCallbacks: (expand) {},
      onVideoSizeChanged: (expand) {},
      platformCallback: (ex) {
        log("message $ex");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CupertinoButton(
                      color: Colors.purple,
                      child: Text("播放demo_play.mp4"),
                      onPressed: () async {
                        if (Platform.isAndroid) {
                          /// 安卓路径读取方式
                          var dir = await getExternalStorageDirectory();
                          log("-------------${dir?.path}->");
                          Directory(dir!.path).create(recursive: true);

                          var result = await AlphaPlayerController.playVideo(
                              dir.path, "1.mp4",
                              portraitPath: 1, landscapePath: 8);
                        } else if (Platform.isIOS) {
                          /// iOS 路径读取方式
                          var dir = await getLibraryDirectory();
                          var library = dir.path;

                          /// 此路径为自己调试的沙盒存储路径，开发者可根据自己的文件存储路径进行相应替换，完整路径应该为（$library/自定义文件夹/x/x.mp4）
                          var filePath = "$library/ttyy/1";
                          var result = await AlphaPlayerController.playVideo(
                              filePath, "1.mp4",
                              portraitPath: 2, landscapePath: 8);
                        }
                      },
                    ),
                    CupertinoButton(
                      color: Colors.purple,
                      child: Text("播放assets demo1.mp4"),
                      onPressed: () {
                        if (Platform.isAndroid) {
                          /// 安卓路径读取方式
                          AlphaPlayerController.playVideo(
                              "/assets/", "demo.mp4");
                        } else if (Platform.isIOS) {
                          /// iOS 路径读取方式
                          /// iOS 由于基于字节播放器的二次封装，内部需要解析config.json 文件来读取资源，所以，视频同级目录内都要有一个对应的config.json文件
                          /// assets 文件夹，也可替换为自定义的文件夹
                          AlphaPlayerController.playAssetVideo(
                              "assets", "demo1.mp4");
                        }
                      },
                    ),
                    CupertinoButton(
                      color: Colors.purple,
                      child: Text("attachView"),
                      onPressed: () {
                        AlphaPlayerController.attachView();
                      },
                    ),
                    CupertinoButton(
                      color: Colors.purple,
                      child: Text("detachView"),
                      onPressed: () {
                        AlphaPlayerController.detachView();
                      },
                    ),
                    CupertinoButton(
                      color: Colors.purple,
                      child: Text("releasePlayer"),
                      onPressed: () {
                        AlphaPlayerController.releasePlayer();
                      },
                    ),
                  ],
                ),
                const IgnorePointer(
                  child: AlphaPlayerView(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
