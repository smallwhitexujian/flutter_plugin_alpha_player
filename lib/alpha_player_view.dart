import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_alpha_player_plugin/alpha_player_for_android.dart';
import 'package:flutter_alpha_player_plugin/alpha_player_for_ios.dart';

class AlphaPlayerView extends StatelessWidget {
  const AlphaPlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return const AlphaPlayerForAndroid();
    } else if (Platform.isIOS) {
      return const AlphaPlayerForIOS();
    }
    return Container();
  }
}
