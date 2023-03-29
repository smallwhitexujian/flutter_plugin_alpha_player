import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///Flutter向iOS原生传递参数
class AlphaPlayerForIOS extends StatelessWidget {
  const AlphaPlayerForIOS({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> params = <String, dynamic>{};
    return UiKitView(
      viewType: "flutter_alpha_player",
      layoutDirection: TextDirection.ltr,
      creationParams: params,
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}
