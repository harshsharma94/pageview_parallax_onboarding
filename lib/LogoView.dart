import 'dart:ui';

import 'package:flutter/widgets.dart';

class LogoView extends StatelessWidget {
  final Color color;
  final String assetName;

  const LogoView({required this.color, required this.assetName});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Center(
        child: Image.asset(
          "assets/"+assetName+".png",
          width: 50,
          height: 50,
        ),
      ),
    );
  }
}
