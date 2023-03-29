import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Flutter 向原生的View传递参数
class AlphaPlayerForAndroid extends StatelessWidget {
  const AlphaPlayerForAndroid({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> params = <String, dynamic>{};
    return AndroidView(
      viewType: "flutter_alpha_player",
      layoutDirection: TextDirection.ltr,
      creationParams: params,
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}
