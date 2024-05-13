import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_search_diff/logger.dart';
import 'package:logger/logger.dart';

class AnimatedRefreshIconButton extends StatefulWidget {
  final void Function() onPressed;
  final Key buttonKey;

  const AnimatedRefreshIconButton(
      {super.key, required this.onPressed, required this.buttonKey});

  @override
  State<StatefulWidget> createState() => _AnimatedRefreshIconButtonState();
}

class _AnimatedRefreshIconButtonState extends State<AnimatedRefreshIconButton>
    with TickerProviderStateMixin {
  late AnimationController controller;

  late Animation<double> rotateAnimation;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(seconds: 100));
    rotateAnimation = Tween<double>(begin: 0.0, end: 360.0).animate(controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _AnimatedRefreshIconButton(
      buttonKey: widget.buttonKey,
      animation: rotateAnimation,
      controller: controller,
      onPressed: widget.onPressed,
    );
  }
}

class _AnimatedRefreshIconButton extends AnimatedWidget {
  final Animation<double> animation;
  final FutureOr<void> Function() onPressed;
  final AnimationController controller;

  final Key buttonKey;
  final Logger l = getLogger('button');

  _AnimatedRefreshIconButton(
      {required this.buttonKey,
      required this.onPressed,
      required this.animation,
      required this.controller})
      : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
        angle: animation.value,
        child: IconButton(
          key: buttonKey,
          icon: const Icon(Icons.refresh_outlined),
          onPressed: controller.isAnimating
              ? null
              : () async {
                  controller.forward();
                  await onPressed();
                  controller.stop();
                  controller.reset();
                },
        ));
  }
}
