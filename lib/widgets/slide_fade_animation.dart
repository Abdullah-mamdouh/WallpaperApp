import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class SlideFadeAnimation extends StatelessWidget {
  final int index;
  final Widget child;
  final double verticalOffset;
  final int animationDuration;
  const SlideFadeAnimation({
    Key? key,
    required this.index,
    required this.child,
    this.verticalOffset = 0,
    this.animationDuration = 225,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: Duration(milliseconds: animationDuration),
      child: SlideAnimation(
        verticalOffset: verticalOffset,
        child: FadeInAnimation(
          child: child,
        ),
      ),
    );
  }
}
