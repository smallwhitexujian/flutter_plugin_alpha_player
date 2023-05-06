# flutter_alpha_player_plugin

一个可以播放透明通道视频的播放器，基于AlphaPlayer改造成plugin插件，适用于Android和iOS平台，支持文件播放。

## AlphaPlayer

AlphaPlayer是直播中台使用的一个视频动画特效SDK，可以通过制作Alpha通道分离的视频素材，再在客户端上通过OpenGL ES重新实现Alpha通道和RGB通道的混合，从而实现在端上播放带透明通道的视频。
[!字节AlphaPlayer](https://github.com/bytedance/AlphaPlayer)

## 方案对比
目前较常见的动画实现方案有原生动画、帧动画、gif/webp、lottie/SVGA、cocos引擎，对于复杂动画特效的实现做个简单对比
|  方案   |  实现成本  |  还原程度  |   接入成本  |
|  ----  |   -----   |   -----   |   -----   |
| 原生动画  | 复杂动画实现成本高 | 中 |  低|
| 帧动画  | 实现成本低，但资源消耗大 | 中| 低|
|gif/webp|	实现成本低，但资源消耗大|只支持8位颜色	|低|
|Lottie/SVGA	|实现成本低，部分复杂特效不支持	|部分复杂特效不支持	|低|
|cocos2d引擎	|实现成本高	|	较高	|较高|
|AlphaPlayer	|开发无任何实现成本，一次接入永久使用|	高	|低|

## 优势
相比于上面提到的几个方案，AlphaPlayer的接入体积极小（只有40KB左右），而且对动画资源的还原程度极高，资源制作时不用考虑特效是否支持的问题，对开发者和设计师都非常友好。通过接入ExoPlayer或者自研播放器可以解决系统播放器在部分机型上可能存在的兼容性问题，且能带来更好的解码性能。

## 运行效果
![运行效果](/example/assets/demo.gif)

## 基本原理
主要有两个核心，一个是IMediaPlayer，负责视频解码，支持外部自行实现；另一个是VideoRenderer，负责将解析出来的每一帧画面进行透明度混合，再输出到GLTextureView或者GLSurfaceView上。

大致的混合过程可以看下图示例
![基本原理图](/example/assets/introduction.png)
原素材的画面中左边部分使用RGB通道存储了原透明视频的Alpha值，右边部分使用RGB通道存储了原透明视频的RGB值，然后在端上通过OpenGL重新将每个像素点的Alpha值和RGB值进行组合，重新得到ARGB视频画面，实现透明视频的动画效果。

## 快速接入
添加依赖
```
flutter_alpha_player_plugin: ^1.x.x
```
或者执行
```
$ flutter pub add flutter_alpha_player_plugin
```

## 使用方式
```Dart
 @override
  void initState() {
    super.initState();
    ///注册监听器
    AlphaPlayerController.setAlphaPlayerCallBack(
        ///播放结束回调
      endAction: () {
        
      },
      ///播放开始回调
      startAction: () {
        
      },
      ///播放器监听
      monitorCallbacks: (expand) {
        
      },
      ///视频尺寸变化回调
      onVideoSizeChanged: (expand) {
        
      },
      ///扩展回调
      platformCallback: (ex) {
        log("message $ex");
      },
    );
  }

  .....

  const IgnorePointer(
    ///添加透明视频布局，添加到合适的位置
    child: AlphaPlayerView(),
    ),

///播放视频
///[path] 文件存放地址
///[name] 文件名称
///[isLooper] 是否重复播放
 var result = await AlphaPlayerController.playVideo( dir.path, "demo_play.mp4");

///添加视图
AlphaPlayerController.attachView();

///移除视图
AlphaPlayerController.detachView();

///释放播放器
AlphaPlayerController.releasePlayer();
```

