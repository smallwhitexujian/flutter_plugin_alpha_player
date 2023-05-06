# flutter_alpha_player_plugin_example

Demonstrates how to use the flutter_alpha_player_plugin plugin.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

由于播放器是基于字节的播放器进行的二次开发，对于字节的iOS播放器，内部会通过解析config.json 文件来读取资源
1.如果是播放本地沙盒目录下的视频资源，需要将demo里的路径替换为自己的视频路径，每一个视频都要有一个独立的文件夹，内部会进行config.json 文件的配置
 此路径为自己调试的沙盒存储路径，开发者可根据自己的文件存储路径进行相应替换，完整路径应该为（$library/自定义文件夹/x/x.mp4（x 表示上级文件夹以及视频名字是同一个名字））

2.如果是播放项目目录里面的视频资源，视频文件同级目录下也要有config.json 文件，里面的配置信息，可参考demo中进行自行配置，也可参考字节的官方链接进行json 文件的配置
3. info.plist  里面要添加 
io.flutter.embedded_views_preview  boolean  1


For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
