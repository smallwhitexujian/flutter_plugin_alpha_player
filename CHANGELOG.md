# change Log

## [1.0.4] 2024-09-05

修复iOS在release版本下释放资源会导致崩溃的问题

## [1.0.3] 2024-08-26

增加修改视频播放器的尺寸,

```dart
  ///播放视频
  ///[path] 文件存放路径
  ///[fileName] 路径下面的源文件
  ///[isLooping] 是否循环 默认false 
  ///[portraitPath] 竖向， 默认2
  ///[landscapePath] 横向， 默认8
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
 AlphaPlayerController.playVideo(dir.path, "1.mp4",portraitPath: 1, landscapePath: 8);
```

## [1.0.2] 2023-05-5

修复IOS无法播放的问题

## [1.0.1] 2023-04-11

增加实现IOS可以播放alphaPlayer播放

## [1.0.0] 2023-04-11

实现Android可以播放alphaPlayer播放
