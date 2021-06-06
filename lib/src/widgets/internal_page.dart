import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Controls internal pages for bottom navigation
class InternalPage extends StatefulHookWidget {
  final Widget? child;

  const InternalPage({Key? key, this.child}) : super(key: key);

  @override
  InternalPageState createState() => InternalPageState();
}

class InternalPageState extends State<InternalPage> {
  var internalPages = <Page>[];

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onPopPage: (route, response) {
        return true;
      },
      pages: [
        CustomPage(
          key: UniqueKey(),
          child: widget.child,
        ),
        ...internalPages,
      ],
    );
  }

  /// Adds an new page to the stack
  void addPage(Widget? page) {
    setState(() {
      internalPages.add(
        CustomPage(key: UniqueKey(), child: page),
      );
    });
  }

  /// Replaces the current page with new one
  void replaceTopPage(Widget page) {
    internalPages.removeLast();
    addPage(page);
  }

  /// Checks if any internal page can be removed
  bool get canPop => internalPages.isNotEmpty;

  /// Removes the current page from the stackA
  void popPage() {
    if (canPop) {
      setState(() {
        internalPages.removeLast();
      });
    }
  }

  /// Removes all pages from the stack
  void popAll() {
    while (canPop) {
      popPage();
    }
  }
}

/// Custom page with PageRouteBuilder
class CustomPage extends Page {
  final Widget? child;

  CustomPage({
    Key? key,
    this.child,
  }) : super(key: key as LocalKey?);

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, animation, animation2) => child!,

      // We have disabled this for now
      // when needed, just uncomment the lines below to have a right->left transition

      // transitionsBuilder: (context, animation, secondaryAnimation, child) {
      //   // start at right, finishes at left
      //   var begin = Offset(1.0, 0.0);
      //   var end = Offset.zero;

      //   // this will update the offset value
      //   var offsetTween = Tween(begin: begin, end: end);

      //   // We use a Curve to control HOW (fast, slow) we update the offset value
      //   var curveTween = CurveTween(curve: Curves.ease);
      //   final offsetTweenCurved = offsetTween.chain(curveTween);

      //   return SlideTransition(
      //     position: animation.drive(offsetTweenCurved),
      //     child: child,
      //   );
      // },

      // Because we're using the '_defaultTransition' (no transition)
      // we change the duration to 0 and 1, so that the
      // transparent background becomes invisible to user's eyes
      transitionDuration: const Duration(milliseconds: 0),
      reverseTransitionDuration: const Duration(milliseconds: 1),
    );
  }
}
