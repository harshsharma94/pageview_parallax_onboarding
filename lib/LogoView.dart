import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:pageview_parallax_onboarding/PageViewState.dart';

class LogoView extends StatelessWidget {
  final Color color;
  final String assetName;
  final ValueListenable<PageViewState> listenable;

  const LogoView({required this.color, required this.assetName, required this.listenable});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Center(
        child: AnimatedBuilder(
          animation: listenable,
          builder: (context, child) {

            final offsetX = listenable.value.previousPage == 0
                ? lerpDouble(0, -100, listenable.value.pageProgress)!
                : 0.0;

            final opacity = listenable.value.previousPage == 0
                ? lerpDouble(1, 0.3, listenable.value.pageProgress)!
                : 0.3;

            return Opacity(
              opacity: opacity,
              child: Transform.translate(
                offset: Offset(offsetX, 0),
                child: child,
              ),
            );
          },
          child: Image.asset(
            "assets/"+assetName+".png",
            width: 50,
            height: 50,
          ),
        ),
      ),
    );
  }
}
