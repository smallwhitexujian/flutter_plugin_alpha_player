import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_alpha_player_plugin/alpha_player_controller.dart';
import 'package:flutter_alpha_player_plugin/alpha_player_view.dart';
import 'package:flutter_alpha_player_plugin/queue_util.dart';

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
    initDownloadPath();
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

  Future<void> initDownloadPath() async {
    Directory appDocDir = await getApplicationSupportDirectory();
    String rootPath = appDocDir.path;
    downloadPathList = ["$rootPath/vap_demo1.mp4", "$rootPath/vap_demo2.mp4"];
    print("downloadPathList:$downloadPathList");
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
                      onPressed: _download,
                      child: Text(
                          "download video source${isDownload ? "(✅)" : ""}"),
                    ),
                    CupertinoButton(
                      color: Colors.purple,
                      child: Text("播放demo_play.mp4"),
                      onPressed: () async {
                        var dir = await getExternalStorageDirectory();
                        log("-------------${dir?.path}->");
                        Directory(dir!.path).create(recursive: true);

                        var result = await AlphaPlayerController.playVideo(
                            dir.path, "demo_play.mp4");
                      },
                    ),
                    CupertinoButton(
                      color: Colors.purple,
                      child: Text("播放assets demo1.mp4"),
                      onPressed: () {
                        AlphaPlayerController.playVideo("/assets/", "demo.mp4");
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
                  // VapView可以通过外层包Container(),设置宽高来限制弹出视频的宽高
                  // VapView can set the width and height through the outer package Container() to limit the width and height of the pop-up video
                  child: AlphaPlayerView(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _download() async {
    await Dio().download(
        "http://file.jinxianyun.com/vap_demo1.mp4", downloadPathList[0]);
    await Dio().download(
        "http://file.jinxianyun.com/vap_demo2.mp4", downloadPathList[1]);
    setState(() {
      isDownload = true;
    });
  }

  _queuePlay() async {
    // 模拟多个地方同时调用播放,使得队列执行播放。
    // Simultaneously call playback in multiple places, making the queue perform playback.
    QueueUtil.get("vapQueue")?.addTask(() =>
        AlphaPlayerController.playVideo(downloadPathList[0], "demo_play.mp4"));
    QueueUtil.get("vapQueue")?.addTask(() =>
        AlphaPlayerController.playVideo(downloadPathList[1], "demo_play.mp4"));
  }

  _cancelQueuePlay() {
    QueueUtil.get("vapQueue")?.cancelTask();
  }
}
