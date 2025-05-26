///--------Animation Widget--------
//HyperAnimationLoading
//HyperAnimationSuccess
//HyperAnimationFaild
//HyperAnimationNoInternet
//HyperAnimationNotFound
//HyperAnimationNoData

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HyperLoader {
  HyperLoader._({required this.type});
  final String type;

  static Widget switchLoader(String type) {
    switch (type) {
      case 'loading':
        return const HyperAnimationLoading();
      case 'success':
        return const HyperAnimationSuccess();
      case 'faild':
        return const HyperAnimationFaild();
      case 'load':
        return const HyperAnimationLoad();
      default:
        return const HyperAnimationLoading();
    }
  }

  static OverlayEntry? _overlayEntry;

  static void show(BuildContext context, String type) {
    if (_overlayEntry != null) return;

    final overlayState = Navigator.of(context).overlay;
    print('show');

    if (overlayState == null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Material(
        color: Colors.transparent,
        child: PopScope(
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) {
              hide();
            }
          },
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.black.withOpacity(0.5),
              child: switchLoader(type)),
        ),
      ),
    );

    overlayState.insert(_overlayEntry!);
  }

  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

class HyperAnimationLoading extends StatelessWidget {
  const HyperAnimationLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LottieBuilder.asset(
        'assets/HyperTechAnimationJson/Animation - 1740800080007.json',
        width: 120,
        height: 120,
        repeat: true,
        animate: true,
        frameRate: FrameRate.max,
        filterQuality: FilterQuality.medium,
      ),
    );
  }
}

class HyperAnimationSuccess extends StatelessWidget {
  const HyperAnimationSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LottieBuilder.asset(
        'assets/HyperTechAnimationJson/Animation - 1740801478480.json',
        width: 120,
        height: 120,
        repeat: false,
        animate: true,
        frameRate: FrameRate.max,
        filterQuality: FilterQuality.medium,
      ),
    );
  }
}

class HyperAnimationFaild extends StatelessWidget {
  const HyperAnimationFaild({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LottieBuilder.asset(
        'assets/HyperTechAnimationJson/Animation - 1740801683045.json',
        width: 120,
        height: 120,
        repeat: false,
        animate: true,
        frameRate: FrameRate.max,
        filterQuality: FilterQuality.medium,
      ),
    );
  }
}

class HyperAnimationLoad extends StatelessWidget {
  const HyperAnimationLoad({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LottieBuilder.asset(
        'assets/animationJson/Animation - 1740817947203.json',
        width: 200,
        height: 200,
        repeat: true,
        animate: true,
        frameRate: FrameRate.max,
        filterQuality: FilterQuality.medium,
      ),
    );
  }
}
