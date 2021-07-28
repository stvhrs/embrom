import 'dart:io';

import 'package:flutter/material.dart';

class DisplayImage extends StatefulWidget {
  static const routeame = '/displayImage';
  final String? filePath;
  DisplayImage([this.filePath]);

  @override
  _DisplayImageState createState() => _DisplayImageState();
}

class _DisplayImageState extends State<DisplayImage>
    with SingleTickerProviderStateMixin {
  void initState() {
    super.initState();
    _controllerReset = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  final TransformationController _transformationController =
      TransformationController();

  Animation<Matrix4>? _animationReset;

  late final AnimationController _controllerReset;

  void _onAnimateReset() {
    _transformationController.value = _animationReset!.value;
    if (!_controllerReset.isAnimating) {
      _animationReset!.removeListener(_onAnimateReset);
      _animationReset = null;
      _controllerReset.reset();
    }
  }

  void _animateResetInitialize() {
    _controllerReset.reset();
    _animationReset = Matrix4Tween(
      begin: _transformationController.value,
      end: Matrix4.identity(),
    ).animate(_controllerReset);
    _animationReset!.addListener(_onAnimateReset);
    _controllerReset.forward();
  }

// Stop a running reset to home transform animation.
  void _animateResetStop() {
    _controllerReset.stop();
    _animationReset?.removeListener(_onAnimateReset);
    _animationReset = null;
    _controllerReset.reset();
  }

  void _onInteractionStart(ScaleStartDetails details) {
    // If the user tries to cause a transformation while the reset animation is
    // running, cancel the reset animation.
    if (_controllerReset.status == AnimationStatus.forward) {
      _animateResetStop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InteractiveViewer(
        transformationController: _transformationController,
        onInteractionEnd: (d) {
          _animateResetInitialize();
        },
        child: Hero(
          tag: widget.filePath!,
          child: Container(
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width,
              child: Image.file(
                File(widget.filePath!),
                fit: BoxFit.fitWidth,
              )),
        ),
      ),
    );
  }
}
