import 'package:flutter/material.dart';
import 'package:pageview_parallax_onboarding/NotifyingPageView.dart';

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
  ValueNotifier<PageViewState> _notifier = ValueNotifier<PageViewState>(PageViewState(pageProgress: 0, previousPage: 0));
  var _sharedElementKey = GlobalKey(); // TODO:

  @override
  void initState() {
    super.initState();
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
          FlutterLogo(),
          FlutterLogo(),
          FlutterLogo(),
          FlutterLogo(),
          FlutterLogo(),
          FlutterLogo(),
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
