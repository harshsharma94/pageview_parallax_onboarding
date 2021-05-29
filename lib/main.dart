import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pageview_parallax_onboarding/LogoView.dart';
import 'package:pageview_parallax_onboarding/NotifyingPageView.dart';
import 'package:rect_getter/rect_getter.dart';

import 'PageViewState.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PageView Parallax Onboarding',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ValueNotifier<PageViewState> _notifier = ValueNotifier<PageViewState>(
      PageViewState(pageProgress: 0, previousPage: 0));
  var _sharedElementKey = RectGetter.createGlobalKey();
  late Offset _finalOffset; // Position after first page ends
  late Path _path;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Rect sharedRect = RectGetter.getRectFromKey(_sharedElementKey)!;
      OverlayState overlayState = Overlay.of(context)!;
      _initPathToFinalState(sharedRect);

      var overlayEntry = OverlayEntry(
        builder: (context) {
          return AnimatedBuilder(
            animation: _notifier,
            builder: (context, child) {

              Size evaluatedSize = _getSharedElementSize(
                _notifier.value,
                sharedRect
              ); // returns shared element size based on page position for all pages

              if(_notifier.value.previousPage == 0) {
                return _getPage1TransformedWidget(evaluatedSize);
              } else if(_notifier.value.previousPage == 1) {
                return _getPage1TransformedWidget(evaluatedSize);
              } else {
                throw FormatException();
              }
            }
          );
        },
      );
      overlayState.insert(overlayEntry);
    });
    super.initState();
  }

  void _initPathToFinalState(Rect initialRect) {
    Size screenSize = MediaQuery.of(context).size;
    _finalOffset = Offset(screenSize.width/2, screenSize.height/2);
    _path = _getPathToCenter(initialRect, _finalOffset);
  }

  Widget _getPage1TransformedWidget(Size evaluatedSize) {
    return Positioned(
        left: _getOffsetFor(
            _notifier.value.pageProgress,
            _path
        ).dx - evaluatedSize.width/2,
        top: _getOffsetFor(
            _notifier.value.pageProgress,
            _path
        ).dy - evaluatedSize.height/2,
        child: SizedBox(
            width: evaluatedSize.width,
            height: evaluatedSize.height,
            child:  Container(
                decoration: BoxDecoration(
                  color: Color(0x5060c9f8),
                  borderRadius: BorderRadius.all(
                      Radius.circular(_getSharedElementRadius())),
                ),
                child: Center(
                    child: Image.asset("assets/flutter.png",
                        width: _getSharedElementLogoSize(),
                        height: _getSharedElementLogoSize())
                )
            )
        )
    );
  }

  Size _getSharedElementSize(PageViewState pageViewState, Rect sharedRect) {
    Size initialSize = Size(sharedRect.width, sharedRect.height);
    Size finalSize = Size(sharedRect.width/3, sharedRect.height/3);

    if(pageViewState.previousPage == 0) {
      return Size.lerp(
          initialSize,
          finalSize,
          _notifier.value.pageProgress)!;
    } else if(pageViewState.previousPage == 1) {
      // final state of page 1 should be same as
      // initial state of page 2
      return finalSize;
    } else {
      throw FormatException();
    }
  }

  Path _getPathToCenter(Rect rect, Offset centre) {
    return Path()
      ..moveTo(rect.center.dx, rect.center.dy)
      ..quadraticBezierTo(rect.center.dx, rect.center.dy, _finalOffset.dx, _finalOffset.dy);
  }

  Offset _getOffsetFor(double value, Path path) {
    if(_notifier.value.previousPage == 0) {
      PathMetric pathMetric = path.computeMetrics().elementAt(0);
      value = value * pathMetric.length;
      Tangent tangent = pathMetric.getTangentForOffset(value)!;
      return tangent.position;
    } else if(_notifier.value.previousPage == 1) {
      return _finalOffset;
    } else {
      throw FormatException();
    }
  }

  double _getSharedElementRadius() {
    double initialRadius = 0;
    double finalRadius = 40;

    if(_notifier.value.previousPage == 0) {
      return lerpDouble(initialRadius, finalRadius, _notifier.value.pageProgress)!;
    } else if(_notifier.value.previousPage == 1) {
      return finalRadius;
    } else {
      throw FormatException();
    }
  }

  double _getSharedElementLogoSize() {
    double initialSize = 50; // same as LogoView.dart widget size
    double finalSize = 25;

    if(_notifier.value.previousPage == 0) {
      return lerpDouble(initialSize, finalSize, _notifier.value.pageProgress)!;
    } else if(_notifier.value.previousPage == 1) {
      return finalSize;
    } else {
      throw FormatException();
    }
  }

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: NotifyingPageView(
                children: _pages(),
                notifier: _notifier,
                sharedElement: _sharedElementKey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _pages() {
    return <Widget>[
      GridView.count(
        crossAxisCount: 2,
        children: <Widget>[
          LogoView(color: Color(0x50000000), assetName: "reactnative",),
          RectGetter(key: _sharedElementKey, child: Container()),
          LogoView(color: Color(0x50478aff), assetName: "ionic",),
          LogoView(color: Color(0x50344955), assetName: "cordova",),
          LogoView(color: Color(0x50000000), assetName: "phonegap",),
          LogoView(color: Color(0x503498db), assetName: "xamarin",),
        ],
      ),
      Container(
          decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.black,
                  width: 25
              ),
              borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          child: Text('You\'re God damn right'),
      )
    ];
  }
}
