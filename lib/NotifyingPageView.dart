import 'package:flutter/widgets.dart';

import 'PageViewState.dart';

class NotifyingPageView extends StatefulWidget {
  final ValueNotifier<PageViewState> notifier;
  final GlobalKey sharedElement;
  final List<Widget> children;

  const NotifyingPageView({
    required this.children,
    required this.notifier,
    required this.sharedElement
  });

  @override
  _NotifyingPageViewState createState() => _NotifyingPageViewState();
}

class _NotifyingPageViewState extends State<NotifyingPageView> {
  late int _previousPage;
  late PageController _pageController;
  var sharedElementKey;

  void _onScroll() {
    if (_pageController.page!.toInt() == _pageController.page || _pageController.page!.toInt() < _previousPage) {
      _previousPage = _pageController.page!.toInt();
    }
    widget.notifier.value = PageViewState(
        pageProgress: _pageController.page! - _previousPage,
        previousPage: _previousPage
    );
  }

  @override
  void initState() {
    sharedElementKey = widget.sharedElement;
    _pageController = PageController(
      initialPage: 0,
    )
      ..addListener(_onScroll);

    _previousPage = _pageController.initialPage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: widget.children,
      controller: _pageController,
    );
  }
}