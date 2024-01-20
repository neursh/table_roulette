import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SceneButton extends StatelessWidget {
  final Widget child;
  final Color color;
  final Color? backgroundColor;
  final void Function()? onPressed;
  final double width, height;
  const SceneButton(
      {super.key,
      this.onPressed,
      required this.child,
      required this.color,
      this.backgroundColor,
      required this.width,
      required this.height});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
        child: SizedBox(
            height: height,
            width: width,
            child: Stack(alignment: AlignmentDirectional.center, children: [
              Container(color: color, width: 3, height: height).animate().moveX(
                  curve: Curves.ease,
                  begin: 0,
                  end: width / 2,
                  duration: .5.seconds),
              Container(color: color, width: 3, height: height).animate().moveX(
                  curve: Curves.ease,
                  begin: 0,
                  end: -width / 2,
                  duration: .5.seconds),
              Container(
                color: backgroundColor ?? color.withOpacity(.5),
                width: width * .85,
                height: height * .85,
                child: child,
              ).animate().fadeIn(delay: .4.seconds, duration: .25.seconds)
            ])));
  }
}
